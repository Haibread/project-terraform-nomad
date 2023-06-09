#!/usr/bin/env bash
set -e

# Install prerequisites
apt-get update -y
apt-get install -y unzip

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
NOMAD_FLAGS="-server -data-dir /opt/nomad/data -config /etc/nomad.d"
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
