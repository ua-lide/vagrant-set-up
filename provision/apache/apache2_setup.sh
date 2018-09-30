#!/bin/bash

home_vagrant="/home/vagrant"
apache_conf_dir="/etc/apache2/sites-available"
apache_conf_file="$1"

sudo mv "$home_vagrant/$apache_conf_file" "$apache_conf_dir"

a2dissite 000-default.conf
a2ensite $apache_conf_file
service apache2 reload
