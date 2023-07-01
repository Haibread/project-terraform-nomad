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

docker run -d -p 9090:9090 --name=prometheus -v /etc/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus --web.enable-remote-write-receiver --config.file=/etc/prometheus/prometheus.yml

mkdir /etc/grafana
mkdir /etc/grafana/dashboards
chmod -R 755 /etc/grafana

## moved to terraform
##wget https://grafana.com/api/dashboards/6278/revisions/1/download -O /etc/grafana/dashboards/nomad.json

docker run -d -p 3000:3000 --name=grafana -v /etc/grafana/dashboards:/etc/grafana/dashboards -e "GF_INSTALL_PLUGINS=natel-discrete-panel" grafana/grafana