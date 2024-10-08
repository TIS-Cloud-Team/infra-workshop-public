#### terraform

```
az login
az account show

terraform init
terraform plan
terraform apply --auto-approve

chmod +x push-image-to-acr.sh
./push-image-to-acr.sh

## clean up
terraform destroy --auto-approve
```
