# AWS RDS Postgres (Free Tier) - Terraform

Provision a simple AWS RDS Postgres instance in `us-east-1` (North Virginia) with:
- Instance class `db.t3.micro`
- Storage `gp2` 20GB, no autoscaling
- Public accessibility enabled for easy DBeaver access
- Security group allowing `5432` from `allowed_cidrs` and optionally from an EKS SG
- Performance Insights disabled
- Initial database `db-mecanica-xpto`
- Username `admin_user`, password set from variable (default provided)

## Files
- `main.tf`: Provider, networking, security group, and RDS instance
- `variables.tf`: Inputs with safe defaults
- `outputs.tf`: Endpoint, port, username outputs

## Quick Start

1. Ensure AWS credentials are configured (e.g., `AWS_PROFILE`, `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`).
2. Optionally set your IP in `allowed_cidrs` to tighten access.

```zsh
cd infrastructure-mx-db
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

## Variables
- `aws_region`: defaults to `us-east-1`
- `allowed_cidrs`: list of CIDRs allowed to access Postgres (default `0.0.0.0/0` for simplicity)
- `eks_security_group_id`: optional SG id from your EKS cluster to allow DB access
- `postgres_engine_version`: defaults to `15.5`
- `initial_db_name`: defaults to `db-mecanica-xpto`
- `postgres_username`: defaults to `admin_user`
- `postgres_password`: default set to `U2VuaGExMjM=` (as provided)

You can override via CLI:

```zsh
terraform apply \
	-var "allowed_cidrs=[\"YOUR.IP.ADDR.0/24\"]" \
	-var "eks_security_group_id=sg-0123456789abcdef"
```

## Connect via DBeaver
- Host: output `rds_endpoint`
- Port: `5432`
- Database: `dbmecanicaxpto`
- User: `admin_user`
- Password: `U2VuaGExMjM=` (or your override)

## Notes
- Publicly accessible is enabled for simplicity; consider restricting `allowed_cidrs`.
- Final snapshot is skipped on destroy; set according to your policies.

# database-mecanica-xpto

## CI/CD (GitHub Actions)
- Workflow file: `.github/workflows/terraform.yml`
- Runs only on push to `main` (i.e., after PR merge).
- Steps: `terraform fmt`, `validate`, `plan`, and automatic `apply` to production.
- AWS access: configure `Secrets`:
	- `AWS_ROLE_TO_ASSUME`: IAM role ARN trusted for GitHub OIDC (recommended).
	- Or classic credentials: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` (then remove `role-to-assume` in workflow).

Example to tighten access via variables (Plan/Apply picks these up from defaults or overrides):

```zsh
terraform apply \
	-var "allowed_cidrs=[\"YOUR.IP.ADDR.0/32\"]" \
	-var "eks_security_group_id=sg-0123456789abcdef"
```