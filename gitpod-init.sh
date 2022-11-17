#!/bin/bash
set -e
git submodule update --init
cd server
npm install
make build-js
cd servers
docker compose -f docker-compose-saml.yaml build base-app
docker compose -f docker-compose-saml.yaml build
docker compose -f docker-compose-saml.yaml pull
