terraform {
  backend "s3" {
  # The values are passed in terraform init which is written in Jenkinsfile
  }
}

provider "aws" {
  region = var.aws_region
}

# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
# }

resource "aws_instance" "example" {
  ami           = "ami-0731becbf832f281e"
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = var.name
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y apache2
              echo "Hello from Ubuntu Apache server" | sudo tee /var/www/html/index.html
              sudo systemctl start apache2
              sudo systemctl enable apache2
              EOF

  lifecycle {
    create_before_destroy = true
  }
}
