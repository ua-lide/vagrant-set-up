#!/bin/bash

# Installation PHP 7.2
apt-get install -y python-software-properties

add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:ondrej/apache2

apt-get update -y

apt-get install -y php7.2
apt-get install -y php7.2-intl php-pear php7.2-curl php7.2-dev php7.2-gd php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xml libssh2-1 php-ssh2

# Installation Composer
curl -sS https://getcomposer.org/installer | php

mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
