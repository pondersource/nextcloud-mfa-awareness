#!/bin/bash
set -e

if [[ -z "$1" ]]; then
    echo "Please run './setup.sh totp' or './setup.sh webauthn'" 1>&2
    exit 1
fi
echo Setting up docker testnet for $1

cd apache-php
docker build . -t apache-php
cd ../sunet-nextcloud
docker build . -t sunet-nextcloud
cd ..

echo "Starting the mariadb container"
docker run -d --network=testnet --name=sunet-mdb2 -p 3306:3306 \
  -e "MARIADB_ROOT_PASSWORD=r00tp@ssw0rd" -e "MARIADB_PASSWORD=userp@ssword" \
  -e "MARIADB_USER=nextcloud" -e "MARIADB_DATABASE=nextcloud" mariadb
echo "Starting the Nextcloud container"
docker run -d --network=testnet --name=sunet-nc2 -p 443:443 -v `pwd`/tls:/tls sunet-nextcloud

x=$(docker exec -it sunet-mdb2 ss -tulpn | grep 3306 | wc -l)
until [ $x -ne 0 ]
do
  echo Waiting for sunet-mdb2 to start, this usually takes about 10 seconds ... $x
  sleep 1
  x=$(docker exec -it sunet-mdb2 ss -tulpn | grep 3306 | wc -l)
done
echo sunet-mdb2 port is open

docker exec sunet-nc2 chown -R www-data:www-data ./config

echo "Setting up $1"
if [ $1 == 'totp' ]; then
  docker exec -u www-data sunet-nc2 ./init-nc2-totp.sh
elif [ $1 == 'webauthn' ]; then
  docker exec -u www-data sunet-nc2 ./init-nc2-webauthn.sh
else
  echo "Unsupported setup $1" 1>&2
  exit 1
fi
