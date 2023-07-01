terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }

    nomad = {
      source = "hashicorp/nomad"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "1.42.0"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  project_id = "5cd6941c-6b1d-474a-80c7-1c2ae8ba6719"
  zone       = "fr-par-1"
  region     = "fr-par"
}

provider "nomad" {
  address = "http://${scaleway_instance_server.nomad-server.0.public_ip}:4646"
}

provider "grafana"{
  url = "http://${scaleway_instance_server.monitoring.public_ip}:3000"
  auth = "admin:admin"
}