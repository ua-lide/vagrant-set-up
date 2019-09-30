#!/bin/bash

apt-get update -y

apt-get remove -y docker docker-engine docker.io

apt install -y docker.io

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

#apt-get install -y \
#    apt-transport-https \
#    ca-certificates \
#    curl \
#    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add –

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable" 
#add-apt-repository \
#   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) \
#   stable"

apt-get update -y

apt-get install -y docker-ce

usermod -aG docker vagrant
