#!/bin/bash
set -e

if [[ -z "$1" ]]; then
    echo "Please run './setup.sh gss' or './setup.sh saml' or './setup.sh totp' or './setup.sh webauthn'" 1>&2
    exit 1
fi


if [ $1 == 'saml' ]; then
  echo "Please use ./setup-saml.sh instead"
  exit 1
fi

if [ $1 == 'webauthn' ]; then
  echo "Please use ./setup-with-tls.sh as described in 'NB2' footnote of the readme"
  exit 1
fi

echo Setting up docker testnet for $1

cd apache-php
docker build . -t apache-php
cd ../sunet-nextcloud
docker build . -t sunet-nextcloud
cd ../simple-saml-php
docker build . -t simple-saml-php
cd ..
DOCKER_BUILDKIT=0 docker compose build
docker compose up -d

x=$(docker exec -it sunet-mdb1 ss -tulpn | grep 3306 | wc -l)
until [ $x -ne 0 ]
do
  echo Waiting for sunet-mdb1 to start, this can take up to a minute ... $x
  sleep 1
  x=$(docker exec -it sunet-mdb1 ss -tulpn | grep 3306 | wc -l)
done
echo sunet-mdb1 port is open

x=$(docker exec -it sunet-mdb2 ss -tulpn | grep 3306 | wc -l)
until [ $x -ne 0 ]
do
  echo Waiting for sunet-mdb2 to start, this can take up to a minute ... $x
  sleep 1
  x=$(docker exec -it sunet-mdb2 ss -tulpn | grep 3306 | wc -l)
done
echo sunet-mdb2 port is open

echo "Done waiting, chowning /var/www/html/config on sunet-nc1/2"
docker exec sunet-nc1 chown -R www-data:www-data ./config
docker exec sunet-nc2 chown -R www-data:www-data ./config

echo "Setting up $1"
if [ $1 == 'gss' ]; then
  docker exec -u www-data sunet-nc1 ./init-nc1-gss-master.sh
  docker exec -u www-data sunet-nc2 ./init-nc2-gss-slave.sh
elif [ $1 == 'totp' ]; then
  docker exec -u www-data sunet-nc2 ./init-nc2-totp.sh
else
  echo "Unsupported setup $1" 1>&2
  exit 1
fi
