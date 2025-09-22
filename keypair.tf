# Generate private key
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a key pair using the generated private key
resource "aws_key_pair" "deployer_key" {
    key_name   = var.key_pair_name
    public_key = tls_private_key.ec2_key.public_key_openssh

    tags = {
        Name = "${var.key_pair_name}-keypair"
    }
}

# Save the private key to a local file (ensure this file is in .gitignore)
resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "${var.key_pair_name}.pem"
  file_permission = "0600"
}
