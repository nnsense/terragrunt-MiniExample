SHELL := /usr/bin/env bash
.RECIPEPREFIX = >

all-test: clean tf-plan-eks

.PHONY: clean
clean:
> rm -rf ${deployment_name}/.terraform*

.PHONY: tf-gsdb-deploy
tf-plan-eks:
> export AWS_REGION=${region} && \
terraform -chdir=${deployment_name} init -reconfigure && \
terraform -chdir=${deployment_name} fmt && \
terraform -chdir=${deployment_name} validate && \
terraform -chdir=${deployment_name} apply -var-file ${deployment_name}/terraform.tfvars -auto-approve

.PHONY: short-region
short-region:
> echo ${region} | awk '{split($$0,a,"-"); print a[1]substr(a[2],0,1)a[3]}'
