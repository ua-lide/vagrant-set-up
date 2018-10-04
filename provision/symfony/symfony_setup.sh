#!/bin/bash

symfony_dir="$1"
www_dir="/var/www/"
parameters_src="/home/vagrant/parameters.yml"
parameters_dest="$symfony_dir/app/config/parameters.yml"

cd "$symfony_dir"

composer install -n
sudo mv "$parameters_src" "$parameters_dest"
php bin/console cache:clear --no-warmup

sudo yarn install
sudo global add gulp
gulp all

sudo yarn encore dev

php bin/console doctrine:database:create
php bin/console doctrine:schema:create
php bin/console doctrine:fixtures:load

ln -s "$symfony_dir" "$www_dir"
