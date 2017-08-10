SHELL=/bin/bash
ENVTYPE=solarch
VARFILE=

include ../../creds

clean:
	rm -rf .terraform ./modules

init: clean
	terraform get .
	terraform init

refresh: init
	terraform refresh -var-file=./params/solarch/params.tfvars .

plan: init
	terraform plan -var-file=./params/solarch/params.tfvars .

apply: plan
	terraform apply -var-file=./params/solarch/params.tfvars .

output: plan
	terraform output

destroy: init
	terraform plan -destroy -var-file=./params/solarch/params.tfvars .
	terraform destroy -var-file=./params/solarch/params.tfvars .
