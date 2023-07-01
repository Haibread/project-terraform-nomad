output "nomad_address" {
  value = "http://${scaleway_instance_server.nomad-server.0.public_ip}:4646"
}

output "monitoring_instance_ip" {
  value = scaleway_instance_server.monitoring.public_ip
}

output "monitoring_grafana_address" {
  value = "http://${scaleway_instance_server.monitoring.public_ip}:3000/"
}