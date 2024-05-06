Summary
---
Packer pipeline builds Azure AVD compute gallery image with DISA STIGs applied; Terraform creates an AVD workpace, host pool, and application group.

Prerequisites
---
- access to Gitlab instance and runners with az cli, packer, terraform dependencies 
- Update .env_template with your Azure credentials and rename to .env

Pipeline/Automation Flow
---
1. run ```<project root>/scripts/add_project_vars.py``` to add .env variables to gitlab project variables
1. .gitlab-ci.yml will replace secrets in packer.pkrvars.hcl using sed utility
1. packer templates creates a compute gallery image version, builds AVD image, and publishes it to the gallery
1. terraform template creates AVD workspace, host pool (uses AVD image from compute gallery)

TODO/Roadmap
---
- [ ] Configure cloud-init to start coder and download containers / templates
- [ ] Add DISA Chef STIG configuration to build: https://public.cyber.mil/announcement/disa-releases-microsoft-windows-11-stig-with-chef/
- [x] Create Terraform template to deploy AVD host pool, workspace, and application group
- [ ] Add EvaluateStig.ps1 to run STIG evaluation on the managed image -- after Chef STIG configuration is added
- [ ] Create parent-child pipeline that provisions Azure Firewall then triggers this pipeline