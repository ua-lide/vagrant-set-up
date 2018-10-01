#!/bin/bash

symfony_dir="$1"
www_dir="/var/www/"
parameters_src="/home/vagrant/parameters.yml"
parameters_dest="$symfony_dir/app/config/parameters.yml"

cd "$symfony_dir"

composer install -n
sudo mv "$parameters_src" "$parameters_dest"
php app/console cache:clear --no-warmup

sudo npm install
sudo npm install gulp -g
gulp all

php app/console doctrine:database:create
php app/console doctrine:schema:create
php app/console doctrine:fixtures:load

ln -s "$symfony_dir" "$www_dir"
