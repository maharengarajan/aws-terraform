#!/bin/bash
yum update -y

# Install cloudwatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

# create cloudwatch config file
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
{
    "logs": {
        "logs_collected": {
        "files": {
            "collect_list": [
            {
                "file_path": "/var/log/messages",
                "log_group_name": "aws-terraform-case6-logs",
                "log_stream_name": "{instance_id}/messages"
            },
            {
                "file_path": "/var/log/secure",
                "log_group_name": "aws-terraform-case6-logs",
                "log_stream_name": "{instance_id}/secure"
            }
            ]
        }
        }
    }
}
EOF

# start cloudwatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config -m ec2 -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# Install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# create s3 read script
cat > /home/ec2-user/read_s3.sh << 'EOF'
#!/bin/bash
BUCKET_NAME="${bucket_name}"
echo "Reading objects in S3 bucket: $BUCKET_NAME"

# List objects in the specified S3 bucket
aws s3 ls "s3://$BUCKET_NAME/" --recursive

# Download files to local directory
mkdir -p /home/ec2-user/s3_files
aws s3 sync "s3://$BUCKET_NAME/" /home/ec2-user/s3_files

echo "Files downloaded to /home/ec2-user/s3_files"
ls -l /home/ec2-user/s3_files
EOF

chmod +x /home/ec2-user/read_s3.sh
chown ec2-user:ec2-user /home/ec2-user/read_s3.sh
