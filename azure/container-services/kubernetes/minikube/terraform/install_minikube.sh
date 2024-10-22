#!/bin/bash

# Update and install necessary packages
echo "Updating package list..." | tee -a /tmp/install_minikube.log
sudo apt-get update | tee -a /tmp/install_minikube.log

echo "Installing Docker..." | tee -a /tmp/install_minikube.log
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common docker.io | tee -a /tmp/install_minikube.log

echo "Adding user to Docker group..." | tee -a /tmp/install_minikube.log
sudo usermod -aG docker adminuser | tee -a /tmp/install_minikube.log

echo "Downloading Minikube..." | tee -a /tmp/install_minikube.log
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 | tee -a /tmp/install_minikube.log

echo "Installing Minikube..." | tee -a /tmp/install_minikube.log
sudo install minikube-linux-amd64 /usr/local/bin/minikube | tee -a /tmp/install_minikube.log

echo "Starting Minikube..." | tee -a /tmp/install_minikube.log
minikube start --driver=docker | tee -a /tmp/install_minikube.log

echo "Minikube status..." | tee -a /tmp/install_minikube.log
minikube status | tee -a /tmp/install_minikube.log

minikube kubectl -- get pods -A | tee -a /tmp/install_minikube.log
sudo snap install kubectl --classic | tee -a /tmp/install_minikube.log

echo "Installation complete." | tee -a /tmp/install_minikube.log