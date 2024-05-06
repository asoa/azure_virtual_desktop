PACKER_TEMPLATE = ubuntu.pkr.hcl

include .env
export

.PHONY: all validate build create_image_def

all: validate build 

validate:
	packer init packer/packer.pkr.hcl 
	packer validate --var-file=packer/packer.pkrvars.hcl ./packer

build:
	packer build --var-file=packer/packer.pkrvars.hcl ./packer

create_image_def:
	@echo "Creating image definition"
	. ./scripts/create_image_def.sh