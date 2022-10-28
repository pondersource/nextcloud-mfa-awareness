#!/bin/bash
set -e

echo "Starting the mariadb containers"
docker run -d --network=testnet --name=sunet-mdb2 \
  -e "MARIADB_ROOT_PASSWORD=r00tp@ssw0rd" -e "MARIADB_PASSWORD=userp@ssword" \
  -e "MARIADB_USER=nextcloud" -e "MARIADB_DATABASE=nextcloud" mariadb
docker run -d --network=testnet --name=sunet-ssp-mdb \
  -e "MARIADB_ROOT_PASSWORD=r00tp@ssw0rd" -e "MARIADB_PASSWORD=sspus3r" \
  -e "MARIADB_USER=sspuser" -e "MARIADB_DATABASE=saml" mariadb

echo "Starting the Nextcloud container"
docker run -d --network=testnet --name=sunet-nc2  sunet-nextcloud
echo "Starting the SSP container"
docker run -d --network=testnet --name=sunet-ssp simple-saml-php

x=$(docker exec -it sunet-mdb2 ss -tulpn | grep 3306 | wc -l)
until [ $x -ne 0 ]
do
  echo Waiting for sunet-mdb2 to start, this can take up to a minute ... $x
  sleep 1
  x=$(docker exec -it sunet-mdb2 ss -tulpn | grep 3306 | wc -l)
done
echo sunet-mdb2 port is open

echo "chowning /var/www/html/config on sunet-nc2"
docker exec sunet-nc2 chown -R www-data:www-data ./config

echo "Configuring user_saml on sunet-nc2"
docker exec -u www-data sunet-nc2 ./init-nc2-local-saml.sh

echo "Adding Firefox tester"
docker run -d --name=firefox -p 5800:5800 -v /tmp/shm:/config:rw --network=testnet --shm-size 2g jlesage/firefox:v1.17.1