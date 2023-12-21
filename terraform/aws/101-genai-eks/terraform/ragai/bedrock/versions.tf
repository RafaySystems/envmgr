terraform {
	required_version = ">= 1.4.4"

	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 5.0"
		}
        kubernetes = {
             version = "~> 2.24.0"
             source = "hashicorp/kubernetes"
		}
    }

}

