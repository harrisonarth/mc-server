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

DOCKPACKS=(
    "docker-ce"
    "docker-ce-cli"
    "containerd.io"
    "docker-buildx-plugin"
    "docker-compose-plugin"
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
sudo systemctl status sshd >> logs.txt
echo "SSH enabled!"

# Install docker
echo "Downloading and installing Docker..."
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo >> logs.txt
for dockpack in "${DOCKPACKS[@]}"; do
    echo "Installing $dockpack..."
    sudo dnf install -y "$dockpack" >> logs.txt
done
echo "Docker install complete!"

# Start docker
echo "Starting docker..."
sudo systemctl start docker >> logs.txt
sudo systemctl enable docker >> logs.txt
sudo systemctl status docker >> logs.txt
echo "Docker enabled!"

# Install and start portainer
echo "Installing portainer..."
sudo docker volume create portainer_data >> logs.txt
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.21.3
echo "Portainer started!"
echo "Script complete!