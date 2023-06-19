#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y openjdk-8-jdk
sudo apt-get install -y maven
sudo apt-get install -y docker.io
sudo docker pull public.ecr.aws/f2m3w5c9/test:01
sudo docker run -d -p 80:8080 public.ecr.aws/f2m3w5c9/test:01