# nextcloud-mfa-awareness
Make Nextcloud aware of whether the current user is logged in with Multi-Factor Authentication


The [mfachecker Nextcloud app](./mfachecker) in this repo demonstrates how it is possible to check if the current user is logged in with
multi-factor authentication (MFA) or not.

Requirements:
* [Docker](https://docs.docker.com/engine/install/)
* Possibly also [Docker Compose Plugin](https://github.com/pondersource/nextcloud-mfa-awareness/issues/5)
* Have the attribute-forwarding branch of https://github.com/pondersource/globalsiteselector/ checked out to /root/globalsiteselector

Usage:
```
git clone https://github.com/pondersource/nextcloud-mfa-awareness
cd nextcloud-mfa-awareness
git submodule update --init
cd servers
cp -r apache-php/tls .
./setup-totp.sh 
```

Instead of 'setup-totp.sh' you can also run 'setup-saml.sh', or 'setup-gss.sh'. If you want to test webauthn then you'll have to use 'setup-with-tls.sh' (see below).

When using `setup-gss.sh` you should specify the how you are going to address the SimpleSamlPhp server:
### `./setup-gss.sh testnet`
Using the Firefox tester in the testnet, the gss leader htttp://sunet-nc1 will redirect you to http://sunet-ssp within
the testnet.
### `./setup-gss.sh localhost`
Using Docker on your laptop, the gss leader which exposes htttp://localhost:8080 will redirect you to
http://localhost:8082 which is exposed by the SimpleSamlPhp server.
This is also the default (when you just run `./setup-gss.sh`).

### `./setup-gss.sh mesh.pondersource.org`
Using Docker-exposed ports over the internet, similar to using localhost, but with URLs like htttp://mesh.pondersource.org:8080 and http://mesh.pondersource.org:8082
This will probably not work though, depending on your browser, the SSP server may say you have cookies disabled and not
show the login screen.

If you're running this on a Windows host system, you can try `setup.bat` instead.

If you run this on localhost, depending on the host system, you may be able to access the Nextcloud GUI on https://sunet-nc2/ or https://localhost:8081/.
If you run this on mesh.pondersource.org, try http://mesh.pondersource.org:8081 (Admin / !QAZ1qaz).

Login may not work on http://mesh.pondersource.org:8081 (keeps showing the login page), when this happens, try
 http://mesh.pondersource.org:5800 and then visit http://sunet-nc2 using the browser-inside-a-browser.

In the case of `./setup-gss.sh`, the gss leader will be accessable on  https://sunet-nc1/ / https://\<host\>:8080/

NB 2: For the webauthn flow you will need to run this on a DNS-addressable server, and copy the true TLS cert/key files into ./tls:
```
cp /etc/letsencrypt/live/mesh.pondersource.org/fullchain.pem tls/server.cert
cp /etc/letsencrypt/live/mesh.pondersource.org/privkey.pem tls/server.key
```
Then you can run: `./setup-with-tls.sh webauthn`
Note that on mesh.pondersource.org you'll have to flush iptables to get this to work, and after that,
restart the server if you want to go back to using the regular `./setup.sh` script.

NB 3: If you run two setup scripts in a row, the docker containers from the previous run will still be around.
If you want to kill and remove *all* Docker containers on the host (including possibly unrelated ones that were started by
other processes or users), run `./clean.sh`). Use at your own risk. :)
