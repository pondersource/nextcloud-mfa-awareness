#!/bin/bash
php console.php maintenance:install --admin-user "Admin" --admin-pass "!QAZ1qaz" --database "mysql" --database-name "nextcloud" --database-user "nextcloud" --database-pass "userp@ssword" --database-host "maria-db-1"
php console.php app:disable firstrunwizard
php console.php app:install twofactor_totp
php console.php app:install user_saml
php console.php app:install twofactor_webauthn
php console.php app:install globalsiteselector
sed -i "13 i\      1 => 'nc1.docker'," /var/www/html/config/config.php
sed -i "3 i\  'allow_local_remote_servers' => true," config/config.php
sed -i "3 i\   'gss.jwt.key' => '123456'," config/config.php
sed -i "3 i\   'gss.mode' => 'master'," config/config.php
sed -i "3 i\   'gss.master.admin' => ['admin']," config/config.php
sed -i "3 i\   'gss.user.discovery.module' => '\OCA\GlobalSiteSelector\UserDiscoveryModules\UserDiscoverySAML',"  config/config.php
sed -i "3 i\   'gss.master.csp-allow' => ['*.localhost:8080', '*.localhost:8081'],"  config/config.php

