FROM apache-php
RUN apt update
RUN rm -rf /var/www/html

WORKDIR /var/www
# See https://github.com/pondersource/nextcloud-mfa-awareness/issues/2#issuecomment-1291971029
RUN wget https://download.nextcloud.com/server/releases/latest-26.zip
RUN unzip latest-26.zip -d . && rm latest-26.zip 
RUN mv nextcloud html
RUN chown -R www-data:www-data ./html
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
