# We need to wait on nomad server to be up and running before we can provision the nomad client.

resource "time_sleep" "wait_160_seconds_nomad" {
  depends_on      = [scaleway_instance_server.nomad-server.1]
  create_duration = "160s"
}

resource "nomad_job" "sample_app" {
  jobspec    = file("./templates/sample_job.nomad")
  depends_on = [time_sleep.wait_160_seconds_nomad]
}
