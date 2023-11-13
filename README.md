# nextcloud-mfa-awareness
Make Nextcloud aware of whether the current user is logged in with Multi-Factor Authentication

Production parts (pending security audit in milestone 6):
* the 'mfazones' app in the Nextcloud app store: https://apps.nextcloud.com/apps/mfazones
* the 'mfazones' app source code: https://github.com/pondersource/mfazones
* our contribution to NC user_saml: https://github.com/nextcloud/user_saml/pull/668 (merged)
* our contribution to NC GSS: https://github.com/nextcloud/globalsiteselector/pull/80 (merged)
* our contribution to NC MFA: https://github.com/nextcloud/server/pull/39411 (pending)
* our contribution to NC workflow engine: https://github.com/nextcloud/server/pull/40235 (pending)

Research parts:
* this documentation repo: https://github.com/pondersource/nextcloud-mfa-awareness#nextcloud-mfa-awareness
* the 'mfachecker' app inside there (demonstration and research purposes only): https://github.com/pondersource/nextcloud-mfa-awareness/tree/main/mfachecker

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
Be aware of https://github.com/pondersource/nextcloud-mfa-awareness/issues/93

### `./setup-gss.sh mesh.pondersource.org`
Using Docker-exposed ports over the internet, similar to using localhost, but with URLs like htttp://mesh.pondersource.org:8080 and http://mesh.pondersource.org:8082
This will probably not work though, depending on your browser, the SSP server may say you have cookies disabled and not
show the login screen.
