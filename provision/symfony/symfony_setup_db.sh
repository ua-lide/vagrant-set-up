#!/bin/bash

symfony_dir="$1"
cd "$symfony_dir"
php app/console doctrine:database:create
php app/console doctrine:schema:create
php app/console doctrine:fixtures:load
