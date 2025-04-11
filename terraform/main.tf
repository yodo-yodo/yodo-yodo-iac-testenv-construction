provider "null" {}

resource "null_resource" "setup" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "vagrant"
      private_key = file("${path.module}/../.vagrant/machines/default/virtualbox/private_key")
      host        = "192.168.56.10"
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apache2"
    ]
  }
}
