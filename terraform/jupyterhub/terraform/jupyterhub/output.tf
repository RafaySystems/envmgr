output "jupiterhub_url" {
  value = "http://${data.local_file.jupyterhub-ip.content}"
}


