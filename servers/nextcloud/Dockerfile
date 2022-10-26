FROM apache-php
RUN apt update
RUN rm -rf /var/www/html

WORKDIR /var/www
# it should be changed to version 19 --> https://download.nextcloud.com/server/releases/latest-19.zip
RUN wget https://download.nextcloud.com/server/releases/latest-24.zip
RUN unzip latest-24.zip -d . && rm latest-24.zip
RUN cp -rf ./nextcloud ./html
RUN rm -rf nextcloud
RUN chown -R www-data:www-data ./html
WORKDIR /var/www/html/apps
RUN git clone --depth=1 --branch=php-version-8 https://github.com/pondersource/nextcloud-mfa-awareness.git
ARG CACHEBUST=1
RUN cd nextcloud-mfa-awareness && git pull
RUN ln -s nextcloud-mfa-awareness/mfachecker
WORKDIR /var/www/html
ADD ./init-master.sh ./init-master.sh
ADD ./init-slave.sh ./init-slave.sh
RUN chmod u+x init-master.sh
RUN chmod u+x init-slave.sh
ENV PHP_MEMORY_LIMIT="512M"
RUN cd apps/mfachecker && make
WORKDIR /var/www/html
USER root
