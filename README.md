# nextcloud-mfa-awareness
Make Nextcloud aware of whether the current user is logged in with Multi-Factor Authentication

Production parts (pending security audit in milestone 6):
* the 'mfazones' app in the Nextcloud app store: https://apps.nextcloud.com/apps/mfazones
* the 'mfazones' app source code: https://github.com/pondersource/mfazones
* our contribution to NC user_saml: https://github.com/nextcloud/user_saml/pull/668 (merged)
* our contribution to NC GSS: https://github.com/nextcloud/globalsiteselector/pull/80 (merged)
* our contribution to NC MFA: https://github.com/nextcloud/server/pull/39411 (pending)
* our contribution to NC workflow engine: https://github.com/nextcloud/server/pull/39471 (pending)

Research parts:
* this documentation repo: https://github.com/pondersource/nextcloud-mfa-awareness#nextcloud-mfa-awareness
* the 'mfachecker' app inside there (demonstration and research purposes only): https://github.com/pondersource/nextcloud-mfa-awareness/tree/main/mfachecker


# Try it out using this dev environment
## Step ONE
Open this repo on GitPod or any other Docker-capable development environment and:

```
git submodule update --init
cd server
git submodule update --init
composer install
```
If you're using GitPod then these steps will already have been executed by
`gitpod-init.sh` but it doesn't hurt to run them again.

If you get an error about the ext-zip library, just run that last command as:
```
composer install --ignore-platform-req=ext-zip

```

## Step TWO
```
cd ../servers
./setup-saml.sh
```

This will build the Docker images, set up the Docker compose, and run a few initialization
scripts against the Nextcloud and database containers.

### Notice
***for cleaning created docker containers use:***
```
./clean.sh
```

Now you should be able to visit:

http://127.0.0.1:8080/index.php/login?direct=1

Or use http://127.0.0.1:5800 (firefox) and inside the opened browser
go to http://sunet-nc2/index.php/login?direct=1 (make sure to use http and not https here)


Sign in with admin / !QAZ1qaz
Visit http://127.0.0.1:8080/index.php/settings/admin/workflow
You should see a flow there that prohibits access to files tagged with 'mfazone'
Unless the current user is MFA verified.

For testing other users use http://127.0.0.1:5800 (firefox)
Inside the opened browser go to http://sunet-nc2 (make sure to use http and not https here,
and this time leave off the /index.php/login?direct=1 path).

We have two users with this creadentials:
User1:
* Username: usr1
* Password: pwd1
* MFA Verified

User2:
* Username: usr2
* Password: pwd2
* Not MFA Verified

Only **file owner** or **admin** users can toggle the MFA Zone button.

Not that this tests the app on a server with local SAML login.
The setups with gss and Nextcloud-native MFA which we researched in milestone
3 are separate (see below).

## Other dev setups:
There are three other options instead of 'setup-saml.sh'
- 'setup-gss.sh'
- 'setup-totp.sh'
- 'setup-with-tls.sh'

When using `setup-gss.sh` you should specify the how you are going to address the SimpleSamlPhp server:

When you want to test the GSS environment in FireFox tester (Docker) you can use this config (**testnet** is name of docker network. you can change it by your preference). then gss leader (htttp://sunet-nc1) will redirect you to (http://sunet-ssp).
```./setup-gss.sh testnet```


when you are using the Docker but you want to test it by your browser directly. in this case the gss leader which exposes `http://localhost:8080` will redirect you to
`http://localhost:8082` which is exposed by the SimpleSAMLPhp server. This is also the default (when you just run `./setup-gss.sh`):
```./setup-gss.sh localhost```



Using Docker-exposed ports over the internet, similar to using localhost, but with URLs like htttp://mesh.pondersource.org:8080 and http://mesh.pondersource.org:8082
This will probably not work though, depending on your browser, the SSP server may say you have cookies disabled and not
show the login screen.
`./setup-gss.sh mesh.pondersource.org`


If you're running this on a Windows host system, you can try `setup.bat` instead.

If you run this on localhost, depending on the host system, you may be able to access the Nextcloud GUI on https://sunet-nc2/ or https://localhost:8081/.
If you run this on mesh.pondersource.org, try http://mesh.pondersource.org:8081 (Admin / !QAZ1qaz).

Login may not work on http://mesh.pondersource.org:8081 (keeps showing the login page), when this happens, try
 http://mesh.pondersource.org:5800 and then visit http://sunet-nc2 using the browser-inside-a-browser.

In the case of `./setup-gss.sh`, the gss leader will be accessable on  **https://sunet-nc1/** or  **https://\<host\>:8080/**

NB 1: For the webauthn flow you will need to run this on a DNS-addressable server, and copy the true TLS cert/key files into ./tls:
```
cp /etc/letsencrypt/live/mesh.pondersource.org/fullchain.pem tls/server.cert
cp /etc/letsencrypt/live/mesh.pondersource.org/privkey.pem tls/server.key
```
Then you can run: `./setup-with-tls.sh webauthn`
Note that on mesh.pondersource.org you'll have to flush iptables to get this to work, and after that,
restart the server if you want to go back to using the regular `./setup.sh` script.

NB 2: If you run two setup scripts in a row, the docker containers from the previous run will still be around.
If you want to kill and remove *all* Docker containers on the host (including possibly unrelated ones that were started by
other processes or users), run `./clean.sh`. Use at your own risk. :)
