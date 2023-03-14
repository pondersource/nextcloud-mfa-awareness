#!/bin/bash
set -e
git submodule update --init
cd server
npm install
make build-js
cp ../servers/sunet-nextcloud/init-* .
cd ../servers
docker compose -f docker-compose-saml.yaml build base-app
docker compose -f docker-compose-saml.yaml build sunet-nc2
docker compose -f docker-compose-saml.yaml build sunet-ssp
docker compose -f docker-compose-saml.yaml build
docker compose -f docker-compose-saml.yaml pull
