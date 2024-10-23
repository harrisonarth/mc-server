#!/bin/bash

# Update the system
echo "Updating DNF package manager..."
sudo dnf update -y

# List of packages
PACKAGES=(
    "curl"
    "vim"
    "ncurses"
    "openssh-server"
)

# Install list of packages
echo "Installing packages..."
for package in "${PACKAGES[@]}"; do
    echo "Installing $package..."
    sudo dnf install -y "$package"
done
echo "All programs have been installed."

# Start ssh
sudo systemctl start sshd
sudo systemctl enable sshd
sudo systemctl status sshd

# Install docker
echo "Downloading and installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Start docker
echo "Starting docker..."
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo systemctl status docker.service
sudo systemctl start containerd.service
sudo systemctl enable containerd.service
sudo systemctl status containerd.service

# Run docker as a nonroot user
echo "Configuring docker to run docker as a nonroot user"
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Install and start portainer
echo "Installing portainer..."
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.3
echo "Portainer started."
