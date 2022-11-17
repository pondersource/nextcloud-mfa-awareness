#!/bin/bash
set -e

echo Rebuilding the simple-saml-php image
cd ./simple-saml-php
docker build . -t simple-saml-php
cd ..

echo "Starting the containers"
docker compose -f docker-compose-saml.yaml  up -d 
echo "Containers started"

x=$(docker exec -it sunet-mdb2 ss -tulpn | grep 3306 | wc -l)
until [ $x -ne 0 ]
do
  echo Waiting for sunet-mdb2 to start, this can take up to a minute ... $x
  sleep 1
  x=$(docker exec -it sunet-mdb2 ss -tulpn | grep 3306 | wc -l)
done
echo sunet-mdb2 port is open

echo "chowning /var/www/html/config on sunet-nc2"
docker exec sunet-nc2 chown -R www-data:www-data ./config

echo "Configuring user_saml on sunet-nc2"
docker exec -u www-data sunet-nc2 ./init-nc2-local-saml.sh
docker exec -it sunet-mdb2 mysql -u nextcloud -puserp@ssword -h sunet-mdb2 nextcloud -e "INSERT INTO oc_appconfig (appid, configkey, configvalue) VALUES \
(\"user_saml\", \"type\", \"saml\")"
docker exec -it sunet-mdb2 mysql -u nextcloud -puserp@ssword -h sunet-mdb2 nextcloud -e "INSERT INTO oc_user_saml_configurations (id, name, configuration) VALUES \
(1, \"samlidp\", \"{\
\\\"general-uid_mapping\\\":\\\"username\\\",\
\\\"general-idp0_display_name\\\":\\\"samlidp\\\",\
\\\"idp-entityId\\\":\\\"http:\/\/sunet-ssp\/simplesaml\/saml2\/idp\/metadata.php\\\",\
\\\"idp-singleSignOnService.url\\\":\\\"http:\/\/sunet-ssp\/simplesaml\/saml2\/idp\/SSOService.php\\\",\
\\\"idp-x509cert\\\":\\\"MIIDazCCAlOgAwIBAgIUTQg4Wn5st4nmtOT08sQhGRcUbl8wDQYJKoZIhvcNAQEL\
BQAwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgMClNvbWUtU3RhdGUxITAfBgNVBAoM\
GEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDAeFw0yMjEwMjcxMzIxNTlaFw0zMjEw\
MjYxMzIxNTlaMEUxCzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEw\
HwYDVQQKDBhJbnRlcm5ldCBXaWRnaXRzIFB0eSBMdGQwggEiMA0GCSqGSIb3DQEB\
AQUAA4IBDwAwggEKAoIBAQC9hOJBGYdIAqzRNYBYk6BCXUQc8ECSDEFVp3hPxwoM\
7x4eGZNmpr2xrCVMR+YJZ2ofGdjzBwSbxQOWD1xO4e432taJAx9G4sDfNeJuJUGx\
dP4Id/jYMZJ/b6oQ8FTXEbi8ZflSBa/z7bvlGUDm/I7U6XYcAeDxCe0mvOUYVex5\
WcNLGeZO26iq/OOR2c2NuD/IwnIhDAcnyF/eWMeeuLWNxPIew15mUSK2uDzI5b82\
6GTNE9tgYc9TAoz95/IfvJAHyigqJTqjjpvDwGWPufOVUycFGRNCu7HsLSaapyg3\
JlnlRq5PJjmc8pJYGfj5gms0l+lbVvnhcPQHRzRgDsnbAgMBAAGjUzBRMB0GA1Ud\
DgQWBBTqLY1LIUEvyHaKUn90axnp1FPcOjAfBgNVHSMEGDAWgBTqLY1LIUEvyHaK\
Un90axnp1FPcOjAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQCD\
l+p9ZcRoG6z3+LJXZIexOzYVHFRr71UBv1NPiyO5bJw332RdiYhB0s8PAyTCavSL\
hVK4WhAam/lZX9sNMSXb9QwSqjHiYT+DA5loaGJJU7DMHeqvifL1kXz776Lv+70U\
h9qjuXIz74Ye4zQA+ALTb3M65kMaRJ9juLEdUVsnLUPvLhKBG8MHXX6sFv2mE6Cj\
KKNPSvliaChAFHL2gmAEfp2TOzwLF6icRMjuBBCiH/5OiwwViF5mwgpJ938HeC1G\
IIKsVDQgUIDr+KPqQbC4OEsGUCW8bybibdwNdtYgNpDYwysgYHgWDsRdmDmkh5Ly\
Q8CODPPBMk+mAN+xC5hX\\\",\
\\\"saml-attribute-mapping-displayName_mapping\\\":\\\"display_name\\\"}\")"
docker exec -it sunet-mdb2 mysql -u sspuser -psspus3r -h sunet-ssp-mdb saml -e "CREATE TABLE users (\
username varchar(255), \
password varbinary(255), \
display_name varchar(255), \
mfa_verified boolean \
)"
docker exec -it sunet-ssp-mdb mysql -u sspuser -psspus3r -h sunet-ssp-mdb saml -e "INSERT INTO users \
(username, password, display_name, mfa_verified) VALUES \
(\"usr1\", AES_ENCRYPT(\"pwd1\", \"SECRET\"), \"user 1\", true), \
(\"usr2\", AES_ENCRYPT(\"pwd2\", \"SECRET\"), \"user 2\", false)"
