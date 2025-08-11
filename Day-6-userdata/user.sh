#!/bin/bash
# Update packages
yum update -y

# Install Apache
yum install -y httpd

# Start Apache
systemctl start httpd
systemctl enable httpd

# Create index.html
echo "<h1>Hello from Terraform User Data!</h1>" > /var/www/html/index.html
