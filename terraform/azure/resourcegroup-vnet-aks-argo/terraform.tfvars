resource_group_name = "km-em-test"
resource_group_location = "centralindia"
vnet_name = "km-em-test"
vnet_address_space = ["10.0.0.0/8"]

k8s_subnet_name = "km-em-test-subnet"
k8s_subnet_address = ["10.10.0.0/16"]

project = "infra"
cluster_name = "km-em-aks1"
blueprint_name = "aks-standard-bp"
blueprint_version = "v1"
cloud_credentials_name = "rafay-demos"
k8s_version = "1.26.3"
vm_size = "Standard_DS2_v2"