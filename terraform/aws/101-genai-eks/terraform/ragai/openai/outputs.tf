output "open-ai-secret-key" {
    value = aws_secretsmanager_secret.secret.name_prefix
}