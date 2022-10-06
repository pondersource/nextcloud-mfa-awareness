FROM apache-php
RUN apt update
RUN rm -rf /var/www/html

WORKDIR /var/www
# it should be changed to version 19 --> https://download.nextcloud.com/server/releases/latest-19.zip
RUN wget https://download.nextcloud.com/server/releases/latest.zip 
RUN unzip latest.zip -d . && rm latest.zip
RUN cp -rf ./nextcloud ./html
RUN rm -rf nextcloud
RUN chown -R www-data:www-data ./html
# USER www-data
#RUN git clone --depth=1 --branch stable24 https://github.com/pondersource/server --recursive --shallow-submodules
# See https://github.com/moby/moby/issues/1996#issuecomment-185872769 for explanation of cachebust.
# If the dynamic-shareproviders of nextcloud is stable, but mfachecker not.
# you can also move the CACHEBUST line down to that step.
RUN git clone --depth=1 https://github.com/pondersource/nextcloud-mfa-awareness.git mfachecker
RUN cd mfachecker && mv mfachecker ../html/apps && rm -rf mfachecker
ARG CACHEBUST=1
WORKDIR /var/www/html
ADD ./init.sh ./init.sh
RUN chmod u+x init.sh
ENV PHP_MEMORY_LIMIT="512M"
RUN cd apps/mfachecker && make
WORKDIR /var/www/html
USER root