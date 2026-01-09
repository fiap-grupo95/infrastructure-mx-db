## 📝 Descrição da Mudança de Infraestrutura
Descreva as alterações nos recursos da AWS/Terraform. Explique o "porquê" e o "o que" está mudando na arquitetura.

## 🏗 Tipo de Mudança
- [ ] 🆕 Novo Recurso (ex: nova instância EC2, novo bucket S3)
- [ ] 🔄 Atualização de Recurso (ex: mudança de tipo de instância, ajuste de SG)
- [ ] 🗑️ Remoção de Recurso (destruição de infraestrutura)
- [ ] 🔐 Security/IAM (alterações em permissões, SGs, roles)
- [ ] ⚙️ Configuração (alterações em variáveis, providers, backend)
- [ ] 📚 Documentação (README, diagramas, comentários)
- [ ] 🔧 Refatoração (melhorias no código HCL sem alteração lógica)

## 🔍 Verificação do Plano (Terraform Plan)
- [ ] Executei `terraform plan` localmente e o resultado foi o esperado.
- [ ] Verifiquei se não há *destruições* acidentais de recursos críticos (ex: Bancos de dados, Volumes).

**Resumo do Plan:**
```hcl
// Cole aqui um resumo relevante do output do plan (opcional)
// Ex: Plan: 1 to add, 1 to change, 0 to destroy.
```

## 💥 Impacto e Breaking Changes
- [ ] Esta mudança requer recriação de recursos (Destroy & Re-create)?
- [ ] Existem paradas de serviço esperadas (Downtime)?
- [ ] Esta mudança afeta custos significativamente?

## 🔗 Issue Relacionada
Fixes #(número da issue)

## 📋 Checklist de Qualidade
- [ ] O código está formatado (`terraform fmt`)
- [ ] O código é válido (`terraform validate`)
- [ ] Não há credenciais ou segredos hardcoded
- [ ] Atualizei a documentação/diagramas se a arquitetura mudou
- [ ] As variáveis possuem descrições claras e defaults sensatos (quando aplicável)

## 🧪 Testes
- Descreva como você validou a mudança (ex: deploy em ambiente de dev, teste de conectividade, etc).

---
**⚠️ Atenção:** Revise cuidadosamente o `terraform plan` no CI antes de aprovar o merge. Mudanças em infraestrutura podem ser irreversíveis.