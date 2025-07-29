# Enterprise Terraform 
## Cumberland Cloud Platform
## AWS Network - Virtual Private Cloud

This module provisions a VPC with public and private subnets on AWS.

### Usage

The bare minimum deployment can be achieved with the following configuration,

### Usage

The bare minimum deployment can be achieved with the following configuration,

**providers.tf**

```hcl
provider "aws" {
	alias 								= "tenant"
	region								= "<region>"

	assume_role {
		role_arn 						= "arn:aws:iam::<tenant-account>:role/<role-name>"
	}
}
```

**modules.tf**

```
module "vpc" {
	source          					= "ssh://git@source.mdthink.maryland.gov:22/etm/mdt-eter-aws-core-network-vpc.git"
	
	providers 							= {
		aws 							= aws.tenant
	}

	platform	                		= {
		client 							= "<client>"
		environment 					= "<environment>"
	}

	vpc									= {
        vpc								= {
			cidr_blocks        			= ["10.0.0.0/16"]
			availability_zones 			= ["us-east-1a", "us-east-1b"]
		}
	}
}
```

`platform` is a parameter for *all* **Cumberland Cloud Terraform** modules. For more information about the `platform`, in particular the permitted values of the nested fields, see the Platform module documentation. The following section goes into more detail regarding the `vpc` variable.

### Parameters

- ``vpc``: Virtual Private Cloud configuration object. 
	- ``enable_nat_gateway``: Flag for NAT gateway in private subnets.
