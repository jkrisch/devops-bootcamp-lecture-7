#!/bin/bash
sudo apt update -y
sudo apt install -y docker docker-compose docker.io
sudo systemctl start docker.socket
sudo systemctl start docker.service
sudo docker run -d -p 8081:8081 --name nexus-repo-manager sonatype/nexus3:3.48.0


