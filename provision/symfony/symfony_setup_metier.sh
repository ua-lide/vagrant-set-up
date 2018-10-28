#!/bin/bash

symfony_dir="$1"
www_dir="/var/www/"
parameters_src="/home/vagrant/parameters.yml"
parameters_dest="$symfony_dir/app/config/parameters.yml"
lide_storage_dir="/home/vagrant/lide_storage"

cd "$symfony_dir"

composer install -n --no-progress --no-suggest
sudo mv "$parameters_src" "$parameters_dest"
php bin/console cache:clear --no-warmup

git submodule sync
git submodule update --init

ln -s "$symfony_dir" "$www_dir"

mkdir "$lide_storage_dir"

sudo usermod -aG docker www-data
