#!/bin/bash

symfony_dir="$1"
cd "$symfony_dir"
php bin/console doctrine:database:create
php bin/console doctrine:schema:create
php bin/console doctrine:fixtures:load
