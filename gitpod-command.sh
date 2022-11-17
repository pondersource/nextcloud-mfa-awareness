#!/bin/bash
set -e

cd servers
docker compose -f docker-compose-saml.yaml build base-app
docker compose -f docker-compose-saml.yaml build
docker compose -f docker-compose-saml.yaml pull
./setup-saml.sh
make watch-js