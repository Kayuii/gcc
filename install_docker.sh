#!/bin/sh
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

