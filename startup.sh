#!/bin/bash

# Update the system
echo "Updating DNF package manager..."
sudo dnf update -y >> logs.txt
echo "Update complete." 

# List of packages
PACKAGES=(
    "dnf-plugins-core"
    "git"
    "ncurses"
    "openssh-server"
    "vim"
)

# Install list of packages
echo "Installing packages..."
for package in "${PACKAGES[@]}"; do
    echo "Installing $package..."
    sudo dnf install -y "$package"
done
echo "All packages have been installed."

# Start ssh
echo "Starting SSH..."
sudo systemctl start sshd >> logs.txt
sudo systemctl enable sshd >> logs.txt
sudo systemctl status sshd 

# Install docker
echo "Downloading and installing Docker..."
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Docker install complete"

# Start docker
echo "Starting docker..."
sudo systemctl start docker >> logs.txt
sudo systemctl enable docker >> logs.txt
sudo systemctl status docker

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
