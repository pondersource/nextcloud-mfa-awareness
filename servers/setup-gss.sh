#!/bin/bash
set -e

echo Setting up full docker testnet for gss using docker-compose.

cd apache-php
docker build . -t apache-php
cd ../sunet-nextcloud
docker build . -t sunet-nextcloud
cd ../simple-saml-php
docker build . -t simple-saml-php
cd ..
DOCKER_BUILDKIT=0 docker compose build
docker compose up -d

function waitForMysql {
  x=$(docker exec -it $1 ss -tulpn | grep 3306 | wc -l)
  until [ $x -ne 0 ]
  do
    echo Waiting for $1 to start, this usually takes about 8 seconds ... $x
    sleep 1
    x=$(docker exec -it $1 ss -tulpn | grep 3306 | wc -l)
  done
  echo $1 port is open
}
waitForMysql sunet-mdb1
waitForMysql sunet-mdb2
waitForMysql sunet-ssp-mdb

echo "Done waiting, chowning /var/www/html/config on sunet-nc1/2"
docker exec sunet-nc1 chown -R www-data:www-data ./config
docker exec sunet-nc2 chown -R www-data:www-data ./config

echo "Setting up leader"
docker exec -u www-data sunet-nc1 ./init-nc1-gss-leader.sh
echo "Setting up follower"
docker exec -u www-data sunet-nc2 ./init-nc2-gss-follower.sh
