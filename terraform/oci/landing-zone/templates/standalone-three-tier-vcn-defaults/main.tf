# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# ----------------------------------------------------------------------------------------
# -- This configuration deploys a CIS compliant landing zone with default VCN settings.
# -- See other templates for other CIS compliant landing zones with alternative settings.
# -- 1. Rename this file to main.tf. 
# -- 2. Provide/review the variable assignments below.
# -- 3. In this folder, execute the typical Terraform workflow:
# ----- $ terraform init
# ----- $ terraform plan
# ----- $ terraform apply
# ----------------------------------------------------------------------------------------

variable "oci_config_raw" {
  description = "Raw content of the OCI config file section [DEFAULT]"
  type        = string
}

variable "private_key" {
  description = "Raw contents of the OCI API private key"
  type        = string
  sensitive   = true
}

variable "private_key_password" {
  description = "API private key password"
  type        = string
  sensitive   = true
}

variable "service_label" {
  description = "Prefix prepended to deployed resource names."
  type        = string
}


locals {
  # Split lines, filter out empty and comment lines
  config_lines = [
    for line in split("\n", var.oci_config_raw) :
    trim(line, " \t\n\r")
    if trim(line, " \t\n\r") != "" &&
       !startswith(trim(line, " \t\n\r"), "#") &&
       !startswith(trim(line, " \t\n\r"), "[")
  ]

  # Convert lines into a map of key = value
  config_kv_map = {
    for kv in local.config_lines :
    trim(split("=", kv)[0], " \t\n\r") =>
    trim(join("=", slice(split("=", kv), 1, length(split("=", kv)))), " \t\n\r")
  }
}

provider "oci" {
  tenancy_ocid     = local.config_kv_map["tenancy"]
  user_ocid        = local.config_kv_map["user"]
  fingerprint      = local.config_kv_map["fingerprint"]
  private_key      = var.private_key
  region           = local.config_kv_map["region"]
}


resource "local_file" "private_key_file" {
  content              = var.private_key
  filename             = "${path.module}/temp_private_key.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}

module "core_lz" {
    source = "../../"
    # ------------------------------------------------------
    # ----- Environment
    # ------------------------------------------------------
    tenancy_ocid         = lookup(local.config_kv_map, "tenancy", null)
    user_ocid            = lookup(local.config_kv_map, "user", null)
    fingerprint          = lookup(local.config_kv_map, "fingerprint", null)
#	private_key_path     = local_file.private_key_file.filename
    private_key          = var.private_key
    private_key_password = var.private_key_password
    region               = lookup(local.config_kv_map, "region", null)
    service_label        = var.service_label

    # ------------------------------------------------------
    # ----- Networking
    # ------------------------------------------------------
    define_net  = true # enables network resources provisioning
    add_tt_vcn1 = true # This deploys one three-tier VCN with default settings, like default name, CIDR, DNS name, subnet names, subnet CIDRs, subnet DNS names.

    # ------------------------------------------------------
    # ----- Notifications
    # ------------------------------------------------------
    network_admin_email_endpoints  = ["email.address@example.com"] # for network-related events. Replace with a real email address.
    security_admin_email_endpoints = ["email.address@example.com"] # for security-related events. Replace with a real email address.

    # ------------------------------------------------------
    # ----- Logging
    # ------------------------------------------------------
    enable_service_connector      = true # Enables service connector for logging consolidation.
    activate_service_connector    = true # Activates service connector.
    service_connector_target_kind = "streaming" # Sends collected logs to an OCI stream.

    # ------------------------------------------------------
    # ----- Security
    # ------------------------------------------------------
    enable_security_zones = true # Deploys a security zone for this deployment in the enclosing compartment.
    vss_create            = true # Enables Vulnerability Scanning Service for Compute instances.

    # ------------------------------------------------------
    # ----- Governance
    # ------------------------------------------------------
    create_budget = true # Deploys a default budget.
}
