# bucket
resource "aws_s3_bucket" "terraformstate" {
  bucket = "terraform-state-samcn26"
  acl = "private"
  tags = {
    Name = "bucketdev"
    Environment = "Dev"
  }
  versioning {
    enabled = true
  }
}

# bucket public access
resource "aws_s3_bucket_public_access_block" "devaccess" {
  bucket = "${aws_s3_bucket.terraformstate.id}"
  block_public_acls = true
  block_public_policy = true
}

# backend terraform on bucket (along with terraform init)
# terraform {
#   backend "s3" {
#     bucket = "terraform-state-samcn26"
#     key = "dev/sam"
#     region = "us-east-1"
#   }
# }

# keypair
resource "aws_key_pair" "devkey" {
  key_name = "devkey"
  public_key ="${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_security_group" "devlocal" {
  name = "devlocal_jpsam"
  description = "dev test using jp ip"
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["123.226.244.84/32","124.41.90.10/32"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "devec2" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.devkey.key_name}"
  tags = {
    Name = "devec2"
  }
  security_groups = ["${aws_security_group.devlocal.name}"]
  provisioner "file" {
    source = "install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh"
    ]
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.devec2.private_ip}>>privateip.txt"
  }
  connection {
    host = "${self.public_ip}"
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
}

output "publicip" {
  value = "${aws_instance.devec2.public_ip}"
}

