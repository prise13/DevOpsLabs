#!/bin/bash

sudo yum -y update

sudo yum install httpd -y
sudo yum install mod_ssl -y
sudo yum install firewalld

sudo mkdir /etc/ssl/private
sudo chmod 700 /etc/ssl/private

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=UA/ST=LvivRegion/L=Lviv/O=ITStepUniversity/OU=University/CN=127.0.0.1"

sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

sudo cp -f /vagrant/index.html /usr/share/httpd/noindex/index.html

sudo cp -f /vagrant/index.html /var/www/html

sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --state

sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd

sudo cp -f /vagrant/localhost.conf /etc/httpd/conf.d/

sudo cp -f /vagrant/non-ssl.conf /etc/httpd/conf.d/

sudo apachectl configtest
sudo systemctl reload httpd

sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload

