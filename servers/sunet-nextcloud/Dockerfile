FROM pondersource/dev-stock-nextcloud-sunet
WORKDIR /var/www/html/apps
RUN apt update && apt install -y git build-essential curl vim
# RUN git clone --depth=1 https://github.com/nextcloud/globalsiteselector.git
# RUN apt install -yq composer
# RUN cd globalsiteselector && composer install
RUN git clone --depth=1 https://github.com/pondersource/nextcloud-mfa-awareness.git
ARG CACHEBUST=1
RUN cd nextcloud-mfa-awareness && git config pull.rebase true && git pull
RUN ln -s nextcloud-mfa-awareness/mfachecker
RUN git clone --depth=1 https://github.com/pondersource/mfazones.git
RUN cd mfazones && git config pull.rebase true && git pull
RUN apt install -yq wget
RUN wget https://github.com/SUNET/nextcloud-stepupauth/releases/download/v0.2.0/stepupauth-0.2.0.tar.gz
RUN tar xzf stepupauth-0.2.0.tar.gz
WORKDIR /var/www/html
# pass on the requires-mfa DAV property into a data- attribute through the client JS code that does the PROPFIND:
# including some console.log statements for debugging that patch:
RUN wget https://github.com/pondersource/server/commit/216a7f3fade1117b67a21e977a6c1628f9aa5ab5.diff
RUN patch -p 1 < 216a7f3fade1117b67a21e977a6c1628f9aa5ab5.diff
RUN wget https://github.com/pondersource/server/commit/b3d907498c8c1fb17012161a59514d338b0127e9.diff
RUN patch -p 1 < b3d907498c8c1fb17012161a59514d338b0127e9.diff

# FIXME: Should be adding this in pondersource/dev-stock-nextcloud-sunet:1.0 instead!
# # See https://github.com/pondersource/nextcloud-mfa-awareness/issues/107#issuecomment-1881166499
# RUN wget https://github.com/pondersource/server/commit/168036570f4.diff
# RUN patch -p 1 < 168036570f4.diff

ADD ./init-*.sh ./
RUN chmod u+x init-*.sh
ENV PHP_MEMORY_LIMIT="512M"
RUN cd apps/mfachecker && make
USER root
