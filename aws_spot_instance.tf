variable "collection_name" {
    default = "terranigmatic"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_spot_instance_request" "spot_instance" {
  ami           = "${data.aws_ami.ubuntu.id}"
  spot_price    = "0.03"
  instance_type = "t2.micro"
  key_name      = "terranigmatic-key-pair-disposable"

  provisioner "remote-exec" {
    inline = [
      "which aws",
      "which python",
    ]

    connection {
      type          = "ssh"
      user          = "ubuntu"
      agent         = "false"
      host          = "${self.public_ip}"
      private_key   = "${file("./secrets/terranigmatic-key-pair-disposable.pem")}"
    }
  }

  tags {
    collection = "${var.collection_name}"
  }

}