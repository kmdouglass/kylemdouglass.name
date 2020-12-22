# kylemdouglass.name Infra

Terraform configuration files for provisioning the kylemdouglass.name backend infrastructure.

## Common operations

*All operations must be performed as the Administrator user.*

Show any pending infrastructure changes:

```console
terraform plan -var-file backend.hcl
```

Apply any pending infrastructure changes:

```console
terraform apply -var-file backend.hcl
```

## Initialize a new working directory

```console
terraform init -backend-config=backend.hcl
```
