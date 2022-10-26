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
# USER www-data
#RUN git clone --depth=1 --branch stable24 https://github.com/pondersource/server --recursive --shallow-submodules
# See https://github.com/moby/moby/issues/1996#issuecomment-185872769 for explanation of cachebust.
# If the dynamic-shareproviders of nextcloud is stable, but mfachecker not.
# you can also move the CACHEBUST line down to that step.
RUN git clone --depth=1 https://github.com/pondersource/nextcloud-mfa-awareness.git mfachecker
ARG CACHEBUST=1
RUN cd mfachecker && git pull && git checkout php-version-8
RUN cd mfachecker && mv mfachecker ../html/apps && rm -rf mfachecker
WORKDIR /var/www/html
ADD ./init-master.sh ./init-master.sh
ADD ./init-slave.sh ./init-slave.sh
RUN chmod u+x init-master.sh
RUN chmod u+x init-slave.sh
ENV PHP_MEMORY_LIMIT="512M"
RUN cd apps/mfachecker && make
WORKDIR /var/www/html
USER root
