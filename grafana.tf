resource "time_sleep" "wait_20_seconds_grafana" {
  depends_on      = [scaleway_instance_server.monitoring]
  create_duration = "20s"
}

resource "grafana_data_source" "prometheus"{
    type = "prometheus"
    name = "prometheus"
    url = "http://172.17.0.1:9090"
    depends_on = [time_sleep.wait_20_seconds_grafana]
}

resource "grafana_folder" "nomad" {
  title = "Nomad"
  depends_on = [time_sleep.wait_20_seconds_grafana]
}

resource "grafana_dashboard" "nomad-cluster" {
  config_json  = file("./dashboards/nomad-cluster_rev1.json")
  folder = grafana_folder.nomad.id
  depends_on = [time_sleep.wait_20_seconds_grafana]
}