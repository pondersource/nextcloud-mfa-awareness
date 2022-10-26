#!/bin/bash
set -e
DOCKER_BUILDKIT=0 docker compose build 
docker compose up -d 
sleep 15
docker exec -it nextcloud ./init.sh
docker exec -it nextcloud chown -R www-data:www-data ../html



# sed -i "8 i\      1 => 'nc1.docker'," /var/www/html/config/config.php
# sed -i "9 i\      2 => 'nc2.docker'," /var/www/html/config/config.php
# sed -i "10 i\      3 => 'nc1.pondersource.net'," /var/www/html/config/config.php
# sed -i "11 i\      4 => 'nc2.pondersource.net'," /var/www/html/config/config.php
# sed -i "3 i\  'allow_local_remote_servers' => true," config/config.php