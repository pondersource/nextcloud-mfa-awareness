#!/bin/bash
set -e

if [[ -z "$1" ]]; then
    echo "Please run './setup.sh gss' or './setup.sh saml' or './setup.sh totp' or './setup.sh webauthn'" 1>&2
    exit 1
fi
echo Setting up docker testnet for $1

cd apache-php
docker build . -t apache-php
cd ../sunet-nextcloud
docker build . -t sunet-nextcloud
cd ../simple-sample-php
docker build . -t simple-saml-php
cd ..
DOCKER_BUILDKIT=0 docker compose build
docker compose up -d
echo "Sleeping 20 seconds"
sleep 20
echo "Done sleeping, chowning /var/www/html/config on sunet-nc1/2"
docker exec sunet-nc1 chown -R www-data:www-data ./config
docker exec sunet-nc2 chown -R www-data:www-data ./config

echo "Setting up $1"
if [ $1 == 'gss' ]; then
  docker exec -u www-data sunet-nc1 ./init-nc1-gss-master.sh
  docker exec -u www-data sunet-nc2 ./init-nc2-gss-slave.sh
elif [ $1 == 'saml' ]; then
  docker exec -u www-data sunet-nc2 ./init-nc2-local-saml.sh
elif [ $1 == 'totp' ]; then
  docker exec -u www-data sunet-nc2 ./init-nc2-totp.sh
elif [ $1 == 'webauthn' ]; then
  docker exec -u www-data sunet-nc2 ./init-nc2-webauthn.sh
else
  echo "Unsupported setup $1" 1>&2
  exit 1
fi
