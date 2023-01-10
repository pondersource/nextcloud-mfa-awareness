#!/bin/bash
set -e

cd servers
./setup-saml.sh
make watch-js