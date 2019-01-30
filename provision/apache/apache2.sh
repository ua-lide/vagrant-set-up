apt-get install -y apache2 libapache2-mod-proxy-html libxml2-dev

sudo a2enmod ssl
sudo a2enmod headers
sudo a2enmod proxy
sudo a2enmod proxy_wstunnel
