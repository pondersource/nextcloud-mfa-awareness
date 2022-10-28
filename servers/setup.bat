set -e
cd apache-php
docker build . -t apache-php
cd ../sunet-nextcloud
docker build . -t sunet-nextcloud
cd ..
DOCKER_BUILDKIT=0 docker compose build 
docker compose up -d 
timeout /t 20 /nobreak
docker exec -it sunet-nc1 ./init-nc1-gss-follower.sh
docker exec -it sunet-nc1 chown -R www-data:www-data ../html


docker exec -it sunet-nc2 ./init-nc2-gss-follower.sh
docker exec -it sunet-nc2 chown -R www-data:www-data ../html


:: sed -i "8 i\      1 => 'nc1.docker'," /var/www/html/config/config.php
:: sed -i "9 i\      2 => 'nc2.docker'," /var/www/html/config/config.php
:: sed -i "10 i\      3 => 'nc1.pondersource.net'," /var/www/html/config/config.php
:: sed -i "11 i\      4 => 'nc2.pondersource.net'," /var/www/html/config/config.php
:: sed -i "3 i\  'allow_local_remote_servers' => true," config/config.php