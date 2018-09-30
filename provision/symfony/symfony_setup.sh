#!/bin/bash

symfony_dir="$1"
www_dir="/var/www/"

cd "$symfony_dir"
php app/console doctrine:database:create
php app/console doctrine:schema:create
php app/console doctrine:fixtures:load

ln -s "$symfony_dir" "$www_dir"
