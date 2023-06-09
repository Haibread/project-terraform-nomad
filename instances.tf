resource "scaleway_instance_server" "nomad-server" {
  name              = "nomad-server-${count.index}"
  type              = var.instance_type
  image             = var.image
  count             = var.server_count
  enable_dynamic_ip = true

  root_volume {
    size_in_gb = 50
  }

  provisioner "file" {
    source      = "./templates/system.service"
    destination = "/tmp/nomad.service"
  }

  connection {
    host        = self.public_ip
    type        = "ssh"
    private_key = file("~/.ssh/id_rsa")
    user        = "root"
    timeout     = "3m"
  }

  provisioner "file" {
    content = templatefile("./templates/server.hcl.tftpl",
      {
        BIND_IP_ADDRESS = "0.0.0.0"
        PRIVATE_IP      = self.private_ip
        SERVER_COUNT    = var.server_count
        SERVER_IP = scaleway_instance_server.nomad-server.0.private_ip
      }
    )
    destination = "/tmp/server.hcl"

    connection {
      host        = self.public_ip
      type        = "ssh"
      private_key = file("~/.ssh/id_rsa")
      user        = "root"
      timeout     = "3m"
    }
  }

  provisioner "remote-exec" {
    scripts = [
      "./scripts/nomad/install.sh",
      "./scripts/nomad/configure.sh",
    ]

    connection {
      host        = self.public_ip
      type        = "ssh"
      private_key = file("~/.ssh/id_rsa")
      user        = "root"
      timeout     = "3m"
    }
  }
}
