#!/bin/bash
set -e

cd servers
docker compose -f docker-compose-saml.yaml up
