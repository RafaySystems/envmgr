# ============================================
# Run:AI Access Outputs
# ============================================

output "runai_control_plane_url" {
  value       = "https://${try(data.local_file.runai_control_plane_url.content, "")}"
  description = "Run:AI Control Plane login URL"
}

output "user_email" {
  value       = var.user_email
  description = "Run:AI user email (cluster-scoped Administrator)"
}

output "password" {
  value = try(
    length(data.local_sensitive_file.runai_user_password.content) > 0
      ? data.local_sensitive_file.runai_user_password.content
      : "User already exists - please reset password in Run:AI UI at https://${data.local_file.runai_control_plane_url.content}",
    "User already exists - please reset password in Run:AI UI at https://${data.local_file.runai_control_plane_url.content}"
  )
  description = "Run:AI user password (Run:AI generated temporary password for NEW users only. Existing users must reset password manually in Run:AI UI)"
  sensitive   = true
}
