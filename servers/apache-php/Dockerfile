FROM ubuntu:20.04
RUN apt update
RUN DEBIAN_FRONTEND="noninteractive" apt install -yq \
  apache2 \
  build-essential \
  curl \
  git \
  libxml2 \
  libxml2-dev \
  php7.4 \
  php-curl \
  php-gd \
  php-intl \
  php-json \
  php-mbstring \
  php-mysql \
  php-opcache \
  php-sqlite3 \
  php-xml \
  php-xdebug \
  php-zip \
  vim \
  wget \ 
  unzip
# Trust all the certificates:
COPY gencerts.sh /gencerts.sh
RUN chmod +x /gencerts.sh
RUN ./gencerts.sh
#ADD tls /tls
RUN cp /tls/*.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates