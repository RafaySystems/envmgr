output "jupyterhub_url" {
  value = "http://${data.local_file.jupyterhub-ip.content}"
}


