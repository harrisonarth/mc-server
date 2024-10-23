#!/bin/bash

# Update the system
echo "Updating DNF package manager..."
sudo dnf update -y >> logs.txt
echo "Update complete." 

# List of packages
PACKAGES=(
    "curl"
    "vim"
    "ncurses"
    "openssh-server"
    "git"
)

# Install list of packages
echo "Installing packages..."
for package in "${PACKAGES[@]}"; do
    echo "Installing $package..."
    sudo dnf install -y "$package" >> logs.txt
done
echo "All packages have been installed."

# Start ssh
echo "Starting SSH..."
sudo systemctl start sshd >> logs.txt
sudo systemctl enable sshd >> logs.txt
sudo systemctl status sshd 

# Install docker
echo "Downloading and installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh >> logs.txt

# Start docker
echo "Starting docker..."
sudo systemctl start docker.service >> logs.txt
sudo systemctl enable docker.service >> logs.txt
sudo systemctl status docker.service
sudo systemctl start containerd.service
sudo systemctl enable containerd.service >> logs.txt
sudo systemctl status containerd.service >> logs.txt

# Run docker as a nonroot user
echo "Configuring docker to run docker as a nonroot user"
sudo usermod -aG docker $USER
newgrp docker
echo "Configuration complete"

# Install and start portainer
echo "Installing portainer..."
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.3
echo "Portainer started."
