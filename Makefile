
install:
	@ echo $(SHELL)
	./script/install.sh

plan: install
	@if [ ! -d ./infra/terraform/.terraform ] ; then ( cd ./infra/terraform/ && terraform init ) ; fi
	ansible-playbook --connection=local --inventory localhost, ./infra/playbooks/terraform-asg.yml

apply: install
	@if [ ! -d ./infra/terraform/.terraform ] ; then ( cd ./infra/terraform/ && terraform init ) ; fi
	ansible-playbook --connection=local --inventory localhost, --extra-vars "tf_apply=True" ./infra/playbooks/terraform-asg.yml

.PHONY: install apply
.DEFAULT_GOAL := plan
