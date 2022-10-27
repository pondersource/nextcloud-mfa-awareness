#!/bin/bash
set -e

if [[ -z "$1" ]]; then
    echo "Please run './setup.sh gss' or './setup.sh saml' or './setup.sh totp' or './setup.sh webauthn'" 1>&2
    exit 1
fi
echo Setting up docker testnet for $1

if [ $1 == 'webauthn' ]; then
  if [[ ! -f servers/apache-php/tls/server.cert ]]; then
    echo "For the webautn setup, servers/apache-php/tls/server.cert needs to exist!"
    exit 1
  fi
  if [[ ! -f servers/apache-php/tls/server.key ]]; then
    echo "For the webautn setup, servers/apache-php/tls/server.key needs to exist!"
    exit 1
  fi
fi

cd apache-php
docker build . -t apache-php
cd ../sunet-nextcloud
docker build . -t sunet-nextcloud
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




# sed -i "8 i\      1 => 'nc1.docker'," /var/www/html/config/config.php
# sed -i "9 i\      2 => 'nc2.docker'," /var/www/html/config/config.php
# sed -i "10 i\      3 => 'nc1.pondersource.net'," /var/www/html/config/config.php
# sed -i "11 i\      4 => 'nc2.pondersource.net'," /var/www/html/config/config.php
# sed -i "3 i\  'allow_local_remote_servers' => true," config/config.php
