#Terraform ANF Demo Setup
v1.0 Created by Donnie Page
This configuration can deploy a full ANF deployment with fully configured domain services, Windows SMB and Linux NFS capabilities.

#Instructions
This assumes you have already configured Terraform and are logged into Azure CLI

1. Simply change the default values in variables.tf to configure anything specific to your environment such as region.
2. Run the following command ```terraform apply```

To clean-up the lab

1. Simply run ```Terraform destroy```

If there are any portions of the evironment that you would like to leave out, simply place '#' sign in front of each line of that code. 

