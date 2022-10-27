#!/bin/bash
set -e

if [[ -z "$SETUP" ]]; then
    echo "No SETUP env var provided (options are 'gss'/'saml'/'totp'/'webauthn')" 1>&2
    echo "Defaulting to 'gss'" 1>&2
    export SETUP=gss
fi

cd apache-php
docker build . -t apache-php
cd ../nextcloud
docker build . -t sunet-nextcloud
cd ..
DOCKER_BUILDKIT=0 docker compose build 
docker compose up -d
echo "Sleeping 20 seconds"
sleep 20
echo "Done sleeping, chowning /var/www/html/config on sunet-nc1/2"
docker exec sunet-nc1 chown -R www-data:www-data ./config
docker exec sunet-nc2 chown -R www-data:www-data ./config

echo "Setting up $SETUP"
if [ $SETUP == 'gss' ]; then
  docker exec -u www-data sunet-nc1 ./init-nc1-gss-master.sh
  docker exec -u www-data sunet-nc2 ./init-nc2-gss-slave.sh
elif [ $SETUP == 'saml' ]; then
  docker exec -u www-data sunet-nc2 ./init-nc2-local-saml.sh
elif [ $SETUP == 'totp' ]; then
  docker exec -u www-data sunet-nc2 ./init-nc2-totp.sh
elif [ $SETUP == 'webauthn' ]; then
  docker exec -u www-data sunet-nc2 ./init-nc2-webauthn.sh
else
  echo "Unsupported setup $SETUP" 1>&2
  exit 1
fi




# sed -i "8 i\      1 => 'nc1.docker'," /var/www/html/config/config.php
# sed -i "9 i\      2 => 'nc2.docker'," /var/www/html/config/config.php
# sed -i "10 i\      3 => 'nc1.pondersource.net'," /var/www/html/config/config.php
# sed -i "11 i\      4 => 'nc2.pondersource.net'," /var/www/html/config/config.php
# sed -i "3 i\  'allow_local_remote_servers' => true," config/config.php
