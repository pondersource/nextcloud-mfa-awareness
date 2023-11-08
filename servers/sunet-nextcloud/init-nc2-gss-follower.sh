#!/bin/bash
echo Installing Nextcloud
php console.php maintenance:install --admin-user "Admin" --admin-pass "!QAZ1qaz" --database "mysql" --database-name "nextcloud" --database-user "nextcloud" --database-pass "userp@ssword" --database-host "sunet-mdb2"
echo Enabling apps
php console.php app:disable firstrunwizard
php console.php app:enable globalsiteselector
php console.php app:enable mfachecker
php console.php app:enable files_accesscontrol
# php console.php app:enable twofactor_totp - this causes an internal server error when Admin/!QAZ1qaz logs in on http://sunet-nc2/index.php/login?direct=1
php console.php app:enable mfazones
echo Editing config
sed -i "8 i\    2 => 'sunet-nc2'," config/config.php
sed -i "8 i\    1 => 'mesh.pondersource.org'," config/config.php
sed -i "3 i\  'allow_local_remote_servers' => true," config/config.php
sed -i "3 i\  'gss.jwt.key' => '123456',"  config/config.php
sed -i "3 i\  'gss.mode' => 'slave',"  config/config.php
sed -i "3 i\  'gss.master.url' => 'http://$LEADER',"  config/config.php
