# Get Latest AMAZON Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  count         = 3
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name = var.key_pair_name
  subnet_id     = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = templatefile("${path.module}/user_data.sh", {
    bucket_name = aws_s3_bucket.shared.bucket
  })
    tags = {
        Name = "${var.project_name}-web-${count.index + 1}"
        AZ = aws_subnet.public[count.index].availability_zone
    }
}