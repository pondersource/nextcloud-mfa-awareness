#!/bin/bash
set -e
git submodule update --init
cd server
git submodule update --init
composer install
