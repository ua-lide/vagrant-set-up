#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password password root'
debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password_again password root'
apt-get install -y mariadb-server

sudo sed -i 's/bind-address/#bind-address/' /etc/mysql/my.cnf

# create database and user
mysql -u root --password=root -e "CREATE USER 'vagrant' IDENTIFIED BY 'vagrant'"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON lide_db.* TO 'vagrant'@'%' IDENTIFIED BY 'vagrant'"
mysql -u root --password=root -e "flush privileges"
