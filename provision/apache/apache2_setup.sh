#!/bin/bash

home_vagrant="/home/vagrant"
apache_conf_dir="/etc/apache2"
apache_conf_file="$1"

sudo mv "$home_vagrant/$apache_conf_file" "$apache_conf_dir/sites-available"

a2dissite 000-default.conf
a2ensite $apache_conf_file

#sudo service apache reload
