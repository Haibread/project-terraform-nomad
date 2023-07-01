#!/usr/bin/env bash
set -e

# Install prerequisites
apt-get update -y
apt-get install -y unzip ca-certificates curl gnupg

# Install Docker engine
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y && apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create nomad working directories
sudo mkdir -p /opt/nomad/data
sudo mkdir -p /etc/nomad.d
sudo mv /tmp/server.hcl /etc/nomad.d

# Download and install Nomad
NOMAD=1.5.6
cd /tmp
echo https://releases.hashicorp.com/nomad/${NOMAD}/nomad_${NOMAD}_linux_amd64.zip
curl -L -o nomad.zip https://releases.hashicorp.com/nomad/${NOMAD}/nomad_${NOMAD}_linux_amd64.zip
unzip nomad.zip >/dev/null
sudo mv nomad /usr/local/bin/nomad
chmod +x /usr/local/bin/nomad

# Configure Nomad
cat >/tmp/nomad_flags <<EOF
NOMAD_FLAGS="-server -data-dir /opt/nomad/data -config /etc/nomad.d -bootstrap-expect=3"
EOF

# Configure Systemd
echo "Installing Systemd service..."
sudo mkdir -p /etc/systemd/system/nomad.d
sudo chown root:root /tmp/nomad.service
sudo mv /tmp/nomad.service /etc/systemd/system/nomad.service
sudo chmod 0644 /etc/systemd/system/nomad.service
sudo mkdir -p /etc/sysconfig/
sudo mv /tmp/nomad_flags /etc/sysconfig/nomad
sudo chown root:root /etc/sysconfig/nomad
sudo chmod 0644 /etc/sysconfig/nomad

# Install Grafana agent
chmod 777 /etc/grafana-agent.yaml
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
apt-get update -y
apt-get -o Dpkg::Options::="--force-confold" install grafana-agent -y
systemctl start grafana-agent