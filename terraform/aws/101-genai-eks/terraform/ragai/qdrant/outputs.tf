output "qadrant-url" {
    value = "http://${helm_release.qdarnt.name}:6333"
}