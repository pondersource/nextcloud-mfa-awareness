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


# Try it out using this dev environment
## Under maintenance

We're moving the test environment into [dev-stock](https://github.com/pondersource/dev-stock) - clone that repo, `cd` into it, and run:
```
./scripts/init-sunet.sh
./scripts/testing-sunet.sh
```

Then visit http://localhost:5800 and inside that browser visit https://nc1.docker

## Known issue
https://github.com/pondersource/nextcloud-mfa-awareness/issues/86