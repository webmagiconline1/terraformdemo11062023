data "aws_ami" "amzn2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"] # Specify the pattern for Amazon Linux 2 AMI names here
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"] # Specify the owner alias of Amazon Linux 2 AMIs here
  }
}

resource "aws_instance" "example" {
  count         = 3
  ami           = data.aws_ami.amzn2.id
  instance_type = var.instance_type
  tags = {
    Name = "example-instance-${count.index + 1}" # Specify the name tag for your instances
  }
  key_name  = var.keypair
  user_data = <<-EOF
    #!/bin/bash
    yum update -y           # Update the system packages
    yum install -y httpd    # Install Apache HTTP server
    systemctl start httpd   # Start the HTTP server
    systemctl enable httpd  # Enable the HTTP server to start on boot
  EOF
}