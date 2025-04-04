TERRAFORM_INIT = terraform init
TERRAFORM_APPLY = terraform apply -auto-approve
TERRAFORM_DESTROY = terraform destroy
ANSIBLE_MAKEFILE = sleep 30 && make -C create-k8s-cluster -f makefile

all: init terraform ansible

init: 
	$(TERRAFORM_INIT)

terraform:
	$(TERRAFORM_APPLY)

ansible:
	$(ANSIBLE_MAKEFILE)

destroy:
	$(TERRAFORM_DESTROY)
