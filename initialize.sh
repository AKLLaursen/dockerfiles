# Add Nvidia driver repository
sudo add-apt-repository ppa:graphics-drivers

sudo apt-get update
sudo apt-get -y upgrade

# Install latest long-lived branch Nvidia driver
sudo apt-get install -y nvidia-384

# Reboot machine!!

# Install build libraries such as C and Cpp compiler
sudo apt-get install -y build-essential

# Install libraries required for Docker
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set up the stable Docker repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce

# Add Nvidia Docker repo
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# Install Nvidia Docker
sudo apt-get update
sudo apt-get install -y nvidia-docker2

# Reload the Docker daemon configuration
sudo pkill -SIGHUP dockerd

mkdir docker
cd docker 