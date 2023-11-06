#!/bin/bash

echo 'Woot!' > /home/ec2-user/user-script-output.txt

echo "Updating yum package manager"
sudo yum update -y

echo "Installing dependencies..."
echo "Installing Docker..."
sudo yum install docker -y

echo "Installing ruby..."
sudo yum install ruby -y

echo "Installing wget..."
sudo yum install wget -y

echo "Installing CodeDeploy..."
cd /home/ec2-user
wget https://aws-codedeploy-eu-central-1.s3.eu-central-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

echo "Granting ec2-user sudo rights to docker"
sudo usermod -a -G docker ec2-user

echo "Enable system docker.service"
sudo systemctl enable docker.service

echo "Start docker.service"
sudo systemctl start docker.service

echo "Start system CodeDeploy.service"
sudo systemctl start codedeploy.service