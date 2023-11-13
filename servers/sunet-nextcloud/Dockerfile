FROM pondersource/dev-stock-nextcloud-sunet:1.0
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
WORKDIR /var/www/html
ADD ./init-*.sh ./
RUN chmod u+x init-*.sh
ENV PHP_MEMORY_LIMIT="512M"
RUN cd apps/mfachecker && make
USER root
