# nextcloud-mfa-awareness
Make Nextcloud aware of whether the current user is logged in with Multi-Factor Authentication

Requirements:
* [Docker](https://docs.docker.com/engine/install/)
* Possibly also [Docker Compose Plugin](https://github.com/pondersource/nextcloud-mfa-awareness/issues/5)

Usage:
```
git clone https://github.com/pondersource/nextcloud-mfa-awareness
cd nextcloud-mfa-awareness
git submodule update --init
cd servers
./setup-gss.sh testnet
```
* go to http://localhost:5800
* log in to https://sunet-nc2/index.php/login?direct=1 as `Admin` / `!QAZ1qaz`
* Optionally, check the workflow exists in administrative settings -> Flow
* In a private browsing tab, log in to http://sunet-nc2 as usr1 / pwd1
* if you get an endless SAML redirect, see https://github.com/pondersource/nextcloud-mfa-awareness/issues/102
* create a folder 'asdf'
* make it an MFA zone
