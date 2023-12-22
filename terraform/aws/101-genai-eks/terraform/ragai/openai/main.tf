provider "aws" {
    region = var.region
}

resource "aws_secretsmanager_secret" "secret" {
  name_prefix = var.secret_name
  tags = {
    Name =  var.secret_name
  }
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = var.secret_value
}
