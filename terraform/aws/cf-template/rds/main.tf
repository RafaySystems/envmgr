resource "aws_cloudformation_stack" "demo-rds-stack" {
  name = var.stack_name
  parameters = {
    AvailabilityZone=var.availability_zone
    EnvironmentType=var.environment
    DBPassword=var.db_password
    DBInstanceIdentifier=var.rds_name
  }
  template_body = "${file("rds.yaml")}"
}
