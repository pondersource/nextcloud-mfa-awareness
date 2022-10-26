#!/bin/bash
php console.php maintenance:install --admin-user "Navid" --admin-pass "!QAZ1qaz" --database "mysql" --database-name "nextcloud" --database-user "nextcloud" --database-pass "userp@ssword" --database-host "maria-db-2"
php console.php app:disable firstrunwizard
php console.php app:install twofactor_totp
php console.php app:install user_saml
php console.php app:install twofactor_webauthn
php console.php app:install globalsiteselector
unset HTTP_PROXY
unset HTTPS_PROXY
unset NO_PROXY
unset http_proxy
sed -i "11 i\      1 => 'nc1.docker'," /var/www/html/config/config.php
sed -i "3 i\  'allow_local_remote_servers' => true," config/config.php
sed -i "3 i\    'gss.jwt.key' => '123456',"  config/config.php
sed -i "3 i\    'gss.mode' => 'slave',"  config/config.php
sed -i "3 i\    'gss.master.url' => 'http://localhost:8080',"  config/config.php
