#!/bin/bash
php console.php maintenance:install --admin-user "Admin" --admin-pass "!QAZ1qaz" --database "mysql" --database-name "nextcloud" --database-user "nextcloud" --database-pass "userp@ssword" --database-host "maria-db-2"
php console.php app:disable firstrunwizard
php console.php app:install twofactor_webauthn
php console.php app:enable mfachecker
sed -i "11 i\      1 => 'nc1.docker'," /var/www/html/config/config.php
sed -i "3 i\  'allow_local_remote_servers' => true," config/config.php
