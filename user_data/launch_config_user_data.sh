#!/bin/bash
sudo snap install docker
sudo addgroup --system docker
sudo adduser ubuntu docker
newgrp docker
sudo snap disable docker
sudo snap enable docker
sleep 30
sudo docker run -d -p 49512:80 jordanjlu/nginxsite:latest 
