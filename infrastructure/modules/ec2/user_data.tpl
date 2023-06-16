#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y openjdk-8-jdk
sudo apt-get install -y maven

sudo apt-get install -y docker.io
sudo usermod -a -G docker ubuntu

sudo docker pull fabiomaster01/backend:latest
sudo docker run -d -p 80:8080 fabiomaster01/backend:latest