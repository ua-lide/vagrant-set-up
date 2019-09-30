#!/bin/bash

# Installation PHP 7.2
apt-get install -y software-properties-common python-software-properties

#add-apt-repository -y ppa:ondrej/php
#add-apt-repository -y ppa:ondrej/apache2

apt-get update -y

apt-get install -y php7.2 php7.2-cli php7.2-common
apt-get install -y php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-intl php7.2-mysql php7.2-xml php7.2-zip

#apt-get install -y php7.2
#apt-get install -y php7.2-intl php-pear php7.2-curl php7.2-dev php7.2-gd php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xml libssh2-1 php-ssh2
#apt-get install php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-intl php7.2-mysql php7.2-xml php7.2-zip

#a2dismod php7.0
#a2enmod php7.2
systemctl restart apache2



# Installation Composer
#curl -sS https://getcomposer.org/installer | php

#mv composer.phar /usr/local/bin/composer
#chmod +x /usr/local/bin/composer

## Installation Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
