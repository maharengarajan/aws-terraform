#!/bin/bash

#update system
yum update -y

# install docker
yum install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# install s3fs-fuse to mount s3 bucket
yum install -y s3fs-fuse

# create mount point directory
mkdir -p /mnt/s3-shared

# create a script to mount the S3 bucket
cat > /home/ec2-user/mount_s3.sh << 'EOF'
#!/bin/bash
BUCKET_NAME="${bucket_name}"
MOUNT_POINT="/mnt/s3-shared"

# Mount S3 bucket using IAM role
s3fs $BUCKET_NAME $MOUNT_POINT -o iam_role=auto -o allow_other -o use_cache=/tmp

# verify mount
if mountpoint -q $MOUNT_POINT; then
    echo "S3 bucket $BUCKET_NAME mounted successfully at $MOUNT_POINT"

    # create a test file
    echo "Hello from $(hostname) at $(date)" > $MOUNT_POINT/testfile.txt

else
    echo "Failed to mount S3 bucket $BUCKET_NAME"
fi
EOF

# make the script executable
chmod +x /home/ec2-user/mount_s3.sh
chown ec2-user:ec2-user /home/ec2-user/mount_s3.sh

# Run the mount script
/home/ec2-user/mount_s3.sh

