
install:
	@ echo $(SHELL)
	./script/install.sh

build: install
	ansible-playbook -u ansible ./ansible/playbooks/terraform-ec2.yml

.PHONY: install build
.DEFAULT_GOAL := build
