#Terraform ANF Demo Setup
v1.0 Created by Donnie Page
This configuration can deploy a full ANF deployment with fully configured domain services, Windows SMB and Linux NFS capabilities.

#Instructions
If not done already, setup local terraform and CLI.  I would suggest running through the simple tutorial one time before using this code in the lab.

https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started


1. Change the default values in variables.tf (located in this folder) to configure anything specific to your environment such as region.

2. Run 'terraform plan' to review the changes.

3. Run `terraform apply` to apply the changes to the lab

To clean-up the lab

4. Run `terraform destroy` to remove all the infrastructure that was applied within the lab.

If there are any portions of the evironment that you would like to leave out, place '#' sign in front of each line of that code. 

