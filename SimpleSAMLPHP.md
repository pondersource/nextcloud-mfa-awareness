# Installation and configuration of  *Simple SAML php*

- Download the latest version of SSP from [this](https://github.com/simplesamlphp/simplesamlphp/releases/download/v1.19.5/simplesamlphp-1.19.5.tar.gz) link.
- Extract the compressed file into /var/www folder.
- cd /var/www/simplesamlphp-1.19.5 ; composer install
- install the prerequisties by executing this command: 
    
    > sudo apt -y install php-xml php-mbstring php-curl apache2 mysql-server php-date php-xml php-json php-mysql libapache2-mod-php

- Enable Apache mysql and ssl modules:
    
    > a2enmod ssl php7.4

- Generate self signed certificate for secure hosting:
    
    > openssl req -nodes -x509 -newkey rsa:4096 -keyout /etc/ssl/private/key.pem -out /etc/ssl/private/cert.pem -days 365

- Restart the required services
    
    > systemctl restart apache2 mysql

- configure apache by these steps: 
    - Create **samlidp-ssl.conf** inside **/etc/apache2/sites-available** folder.
    - Add insert this configuration inside **samlidp-ssl.conf**:
            
            <VirtualHost *:443>
                ServerName samlidp.localhost

                ServerAdmin webmaster@localhost
                DocumentRoot /var/www/html

                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                SSLCertificateFile /etc/ssl/private/cert.pem
                SSLCertificateKeyFile /etc/ssl/private/key.pem

                SetEnv SIMPLESAMLPHP_CONFIG_DIR /var/www/simplesamlphp-1.19.5/config

                Alias /simplesaml /var/www/simplesamlphp-1.19.5/www
                <Directory /var/www/simplesamlphp-1.19.5/www/>
                        Require all granted
                </Directory>
            </VirtualHost>
    - Run `a2ensite samlidp-ssl`
    - Create a database inside MySQL server I named it **saml**  
 
- Configure SimpleSAMLphp by changing below variables in `/var/www/simplesamlphp-19.1.5/config/config.php`: 

    - `auth.adminpassword` - Set a password. If you’d like to encrypt it (recommended) run /var/www/simplesamlphp-19.1.5/bin/pwgen.php and use its output as a value here.
    - `secretsalt` - A secret key. Use openssl rand -base64 32 to generate a random value to go here (use this to hash users passwords inside database).
    - `production` - Default value is set to true, as this is for testing I did change it to false. That way your UI will show a warning that it’s not productive. Could prevent accidents.
    - `database.dsn` - Set your mysql database connection string here. in my environment it is *mysql:host=localhost;dbname=saml*
    - `database.username` -  Your database username goes here,
    - `database.password` - Your database password goes here,
    - `enable.shib13-idp` - Set this to true.
    - `enable.saml20-idp` - Set this to true.
    - `module.enable.exampleauth` - Set this to false.
    - `module.enable.core` - Set this to true.
    - `module.enable.saml` - Set this to true.
    - `module.enable.sqlauth` - Set this to true.

- create a ssl certificate for sso:
    
    openssl req -newkey rsa:2048 -new -x509 -days 3652 -nodes -out /var/www/simplesamlphp-1.19.5/cert/saml.crt -keyout /var/www/simplesamlphp-1.19.5/cert/saml.pem

- Prepare user data:

    `mysql -e "CREATE DATABASE auth DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;`

    `CREATE USER 'authuser'@'localhost' IDENTIFIED BY 'authuser';`

    `GRANT ALL PRIVILEGES ON auth.* TO 'authuser'@'localhost';`

    `CREATE TABLE auth.users(username VARCHAR(30), password VARBINARY(30), mfa_verified BIT, display_name VARCHAR(50));`
    
    `INSERT INTO auth.users(username, password, mfa_verified, display_name) VALUES`
    `('user1', AES_ENCRYPT('123','secret'), 1, 'navid'),`
    `('user2', AES_ENCRYPT('123','secret'), 0, 'rose'),`
    `('user3', AES_ENCRYPT('123','secret'), 1 , 'ismoil');`
    `FLUSH PRIVILEGES;`
    

- Connect SimpleSAMLphp to mysql: 
      modify /var/simplesamlphp-1.19.5/config/authsources.php and set the example-sql with this data ("SECRET" is the value that you generated for `secretsalt`):
      
      'example-sql' => [
        'sqlauth:SQL',
        'dsn' => 'mysql:host=127.0.0.1;port=3306;dbname=saml',
        'username' => 'DATABASE_USERNAME',
        'password' => 'DATABASE_PASSWORD',
        'query' => 'SELECT username, display_name, mfa_verified  FROM users WHERE username = :username AND AES_DECRYPT(password,"SECRET") = :password',
      ],

- Modify the metadata/shib13-idp-hosted.php 
    
        $metadata['https://samlidp.localhost/simplesaml/saml2/idp/metadata.php'] = [
            'host' => '__DEFAULT__',
            'privatekey' => 'saml.pem',
            'certificate' => 'saml.crt',
            'auth' => 'example-sql',
        ];

- Modify the metadate/saml20-idp-hosted.php 
    
        $metadata['https://samlidp.localhost/simplesaml/saml2/idp/metadata.php'] = [
            'host' => '__DEFAULT__',
            'privatekey' => 'saml.pem',
            'certificate' => 'saml.crt',
            'auth' => 'example-sql',
        ];
- Modify the metadata/saml20-sp-remote.php and add below configuration for your service provider: 
        
        $metadata['http://localhost:8002/index.php/apps/user_saml/saml/metadata'] = [
            'AssertionConsumerService' => 'http://localhost:8002/index.php/apps/user_saml/saml/acs',
            'SingleLogoutService' => 'http://localhost:8002/index.php/apps/user_saml/saml/sls',
        ];
        
# Integrating Nextcloud with SimpleSAMLphp

- Install  SSO & SAML authentication App from app store.
- In settings > SSO and SAML Authentication (e.g. https://cloud.pondersource.org/index.php/settings/admin/saml ), select 'use built-in SAML authentication' and set these values: 
    - `Attribute to map UID` - Set to **username**
    - `Optional display name` - Set to **samlidp** 
    - `ID_Setting.Identity_Of_IDP_Entity` - Set to **https://samlidp.localhost/simplesaml/saml2/idp/metadata.php**
    - `IDP_Setting.UR_Target_Of_IDP` - Set to **https://samlidp.localhost/simplesaml/saml2/idp/SSOService.php**
    - `IDP_Provider_Data.Public_X509_certificate` ('Identity Provider Data' > 'Show optional Identity Provider settings...' > 'Public X.509 certificate of the IdP') - Put certificate inside the idp public cert (example: saml.cert) without dashed lines
    - `Attribute_Mapping.Display_Name` ('Attribute mapping' > 'Show attribute mapping settings...' > 'Attribute to map displayname to') - display_name

# Using the M F A Checker app

* Copy the 'mfachecker' folder from this repo into the /var/www/html/apps/ folder on the nextcloud server
* In there, run `make build`
* Enable the app through the GUI (you need to click 'enable untested app' and then click 'enable app' a second time before it's enabled)

# References
1- https://ericfossas.medium.com/quick-tut-sso-simplesamlphp-837211f43f0d

2- https://www.romangeber.com/simplesamlphp_installation/

3- https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-simplesamlphp-for-saml-authentication-on-ubuntu-18-04

4- https://support.panopto.com/s/article/Configuring-SSO-with-SimpleSAMLphp

5- https://simplesamlphp.org/docs/
