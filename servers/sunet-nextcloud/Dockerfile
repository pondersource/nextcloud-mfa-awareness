FROM pondersource/dev-stock-nextcloud-sunet#7bde8444dc95
WORKDIR /var/www/html/apps
RUN git clone --depth=1 https://github.com/nextcloud/globalsiteselector.git
RUN apt install -yq composer
RUN cd globalsiteselector && composer install
RUN git clone --depth=1 https://github.com/pondersource/nextcloud-mfa-awareness.git
ARG CACHEBUST=1
RUN cd nextcloud-mfa-awareness && git pull
RUN ln -s nextcloud-mfa-awareness/mfachecker
WORKDIR /var/www/html
ADD ./init-*.sh ./
RUN chmod u+x init-*.sh
ENV PHP_MEMORY_LIMIT="512M"
RUN cd apps/mfachecker && make
USER root
