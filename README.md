# nextcloud-mfa-awareness
Make Nextcloud aware of whether the current user is logged in with Multi-Factor Authentication


The [mfachecker Nextcloud app](./mfachecker) in this repo demonstrates how it is possible to access `user_saml.samlUserData` from the Nextcloud session and read out the `mfa_verified` attribute from SAML metadata there, if the IDP provides this.

You will need an IDP server and a Nextcloud server.
* To set up an IDP server with support for the `mfa_verified` attribute, follow the [SimpleSAMLPHP.md](./SimpleSAMLPHP.md) instructions. As you can see there, it is faking this by hard-coding this attribute per user in the database.

* To set up the Nextcloud server, follow the [Nextcloud install instructions](https://nextcloud.com/install/). We tested this with Nextcloud versions 21 and 23, (although https://apps.nextcloud.com/apps/user_saml states that the SSO & SAML authentication app for Nextcloud has itself only been tested up to version 22).


# Using the MFA Checker app
* Copy the 'mfachecker' folder from this repo into the /var/www/html/apps/ folder on the nextcloud server
* In there, run `make build`
* Enable the app through the GUI (you need to click 'enable untested app' and then click 'enable app' a second time before it's enabled)

# Demo
See https://vimeo.com/698115807 for a screencast (no audio) that demonstrates how the MFA Checker Nextcloud app works.

* Log in to your Nextcloud server.
* You will be redirected to the IDP.
* On there, log in as `user1` / `123`.
* Notice you don't really have to go through MFA because `user1` has a hard-coded `mfa_verified = 1` value in the user database of the IDP.
* Once logged in, click on the Cog icon in the top bar to go to the MFA Checker app
* You should see `mfa_checked` true
* Use a private browsing tab to start a new session
* This time, log in as `user2` / `123`.
* Remember from the IDP install instructions that `user2` has a hard-coded `mfa_verified = 0` value in the user database of the IDP.
* You should see `mfa_checked` false.
