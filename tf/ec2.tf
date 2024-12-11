resource "aws_security_group" "sg_1" {
  name = "default"

  ingress {
    description = "App Port"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "new_ec2_tf_key" {
  key_name   = "new-ec2-tf-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDeOEn/gkD/N3qt+/2lI56rSFzXvLnGevb1bGXgxWXUstrcfLdmwQgjRZkRNHCJ4WafeY5ymOj4NqGYxiOA+xSnpgJXo2SsiFWYn5j4pK3GtS49yk8aAAEqtlx79IIeL9YaW3wUM35wVxjvpMU2scVDIBQLsOI2Z23nLJ1pxD23gyeRouVVvERmDALnWtzrJWP7YRxnsF/3rn0X7FjBBxXySovxCObvhFUjc4GPTV1CHikplj0vGkmVT4ZVlZz+7v56l5gkcZax4fz5SMHprkn8jIMZ5R9LtI7F/i3KQvPvxvI050zAGMuJD7pShwaxNlirx88f2PfM+AwSEyX3FNoZ tsm168@RangseyMac"
}

resource "aws_instance" "server_1" {
  ami  = "ami-df5de72bdb3b"
  instance_type = "t3.micro"
  count = 1
  key_name = aws_key_pair.new_ec2_tf_key.key_name
  security_groups = [aws_security_group.sg_1.name]
    user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install git -y
              apt install curl -y

              # Install NVM
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
              . ~/.nvm/nvm.sh

              # Install Node.js 18
              nvm install 18

              # Install PM2
              npm install pm2 -g

              # Clone Node.js repository
              git clone https://RANGSEYhome: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@github.com/RANGSEYhome/DevOPS.git /root/DevOPS

              # Navigate to the repository and start the app with PM2
              cd /root/devops-ex
              npm install
              pm2 start index.js --name node-app -- -p 8000
            EOF
  user_data_replace_on_change = true
}