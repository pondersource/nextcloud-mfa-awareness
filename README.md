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
cp -r apache-php/tls .
./setup.sh totp
```

Instead of 'totp' you can also run 'saml', 'webauthn' or 'gss'.

If you're running this on a Windows host system, you can try `setup.bat` instead.

If you run this on localhost, depending on the host system, you may be able to access the Nextcloud GUI on https://sunet-nc2/ or https://localhost:8081/.
If you run this on mesh.pondersource.org, try http://mesh.pondersource.org:8081 (Admin / !QAZ1qaz).

Login may not work on http://mesh.pondersource.org:8081 (keeps showing the login page), when this happens, try
 http://mesh.pondersource.org:5800 and then visit http://sunet-nc2 using the browser-inside-a-browser.

In the case of `./setup.sh gss`, the gss master will be accessable on  https://sunet-nc2/ / https://<host>:8080/

NB 1: the gss slave is hard-coded to redirect you to http://localhost:8080 when you're not logged in, even if that
may not be the correct URL of your gss master.
To test the gss setup, make sure to log in to the gss master instead.

NB 2: For the webauthn flow you will need to run this on a DNS-addressable server, and copy the true TLS cert/key files into ./tls:
```
cp /etc/letsencrypt/live/mesh.pondersource.org/fullchain.pem tls/server.cert
cp /etc/letsencrypt/live/mesh.pondersource.org/privkey.pem tls/server.key
```
Then you can run: `./setup-with-tls.sh webauthn`
Note that on mesh.pondersource.org you'll have to flush iptables to get this to work, and after that,
restart the server if you want to go back to using the regular `./setup.sh` script.
