# aws-infra

Create access keys in aws using an IAM account
Configure aws profile locally
```
aws configure --profile demo
```

Plan a vpc with variable file
```
terraform fmt && terraform init && terraform plan -var-file="csye6225.tfvars.dev"
terraform fmt && terraform init && terraform plan -var-file="csye6225.tfvars.demo"
```

Apply a vpc with variable file
```
terraform fmt && terraform init && terraform apply -var-file="csye6225.tfvars.dev"
terraform fmt && terraform init && terraform apply -var-file="csye6225.tfvars.demo"
```

After checking everything correct, enter 'yes' to continue creating

Destroy a vpc with variable file
```
terraform destroy -var-file="csye6225.tfvars.dev"
terraform destroy -var-file="csye6225.tfvars.demo"
```
After checking everything correct, enter 'yes' to continue deleting
***
Install SSL certificate to ACM
```
export AWS_PROFILE=demo
aws acm import-certificate --certificate fileb://demo_changyu_me.crt \
    --certificate-chain fileb://demo_changyu_me.ca-bundle \
    --private-key fileb://private.key
```
***
~ Deactivate access keys after demo ~
