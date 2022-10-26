#!/bin/bash
set -e
cd apache-php
docker build . -t apache-php
cd ../nextcloud
docker build . -t sunet-nextcloud
cd ..
DOCKER_BUILDKIT=0 docker compose build 
docker compose up -d 
sleep 15
docker exec -it sunet.nextcloud.first ./init-master.sh
docker exec -it sunet.nextcloud.first chown -R www-data:www-data ../html


docker exec -it sunet.nextcloud.second ./init-slave.sh
docker exec -it sunet.nextcloud.second chown -R www-data:www-data ../html



# sed -i "8 i\      1 => 'nc1.docker'," /var/www/html/config/config.php
# sed -i "9 i\      2 => 'nc2.docker'," /var/www/html/config/config.php
# sed -i "10 i\      3 => 'nc1.pondersource.net'," /var/www/html/config/config.php
# sed -i "11 i\      4 => 'nc2.pondersource.net'," /var/www/html/config/config.php
# sed -i "3 i\  'allow_local_remote_servers' => true," config/config.php
