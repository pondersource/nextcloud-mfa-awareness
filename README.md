# nextcloud-mfa-awareness
Make Nextcloud aware of whether the current user is logged in with Multi-Factor Authentication


The [mfachecker Nextcloud app](./mfachecker) in this repo demonstrates how it is possible to check if the current user is logged in with
multi-factor authentication (MFA) or not.

Requirements:
* [Docker](https://docs.docker.com/engine/install/)
* Possibly also [Docker Compose Plugin](https://github.com/pondersource/nextcloud-mfa-awareness/issues/5)

Usage:
```
git clone https://github.com/pondersource/nextcloud-mfa-awareness
cd nextcloud-mfa-awareness
cd servers
./setup.sh totp
```

Instead of 'totp' you can also run 'saml', 'webauthn' or 'gss'.

If you're running this on a Windows host system, you can try `setup.bat` instead.

If you run this on localhost, depending on the host system, you may be able to access the Nextcloud GUI on https://sunet-nc2/ or https://localhost:8081/.
If you run this on mesh.pondersource.org, try https://mesh.pondersource.org:8081 or https://mesh.pondersource.org:5800 and then visit https://sunet-nc2 using the browser-inside-a-browser.

In the case of `./setup.sh gss`, the gss master will be accessable on  https://sunet-nc2/ / https://<host>:8080/