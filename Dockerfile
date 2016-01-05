# Pour le cours ARV3054, idéalement vous devrions utiliser la fonctionnalité de liaison entre les contenants.

# Les instructions d'installation originales proviennent de : https://www.accesstomemory.org/en/docs/2.2/admin-manual/installation/linux/#installation-linux

FROM ubuntu:latest

MAINTAINER Dominic Boisvert <dominic.boisvert.1@umontreal.ca>

# Variables pour notre dockerfile.
ENV ATOM_URL=https://storage.accesstomemory.org/releases/atom-2.1.2.tar.gz
ENV ATOM_VERSION=2.1.2
ENV DEBIAN_FRONTEND=noninteractive

# Pour mettre à jour les dépôts et installer les paquets nécessaires et faire le ménage.
ADD conf/elasticsearch.list /etc/apt/sources.list.d/
RUN apt-get update && \
  apt-get -y --no-install-recommends --force-yes install \
  apache2 \
  elasticsearch \
  ghostscript \
  imagemagick \
  libapache2-mod-php5 \
  libapache2-mod-xsendfile \
  mysql-server \
  openjdk-7-jre-headless \
  php-apc \
  php5-cli \
  php5-curl \
  php5-fpm \
  php5-gd \
  php5-json \
  php5-ldap \
  php5-mcrypt \
  php5-mysql \
  php5-readline \
  php5-xsl \
  poppler-utils \
  supervisor \
  tar \
  wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/*

RUN a2enmod rewrite xsendfile

# Pour télécharger, placer atom au bon endroit et donner les droits pour le serveur Web.
RUN mkdir /var/www/html/atom && \
    wget $ATOM_URL && \
    tar xzf atom-$ATOM_VERSION.tar.gz && \
    mv atom-$ATOM_VERSION/* var/www/html/atom/ && \
    chown -R www-data:www-data /var/www/html/atom

# Divers scripts et configurations.
ADD scripts/start-apache2.sh /start-apache2.sh
ADD scripts/start-mysqld.sh /start-mysqld.sh
ADD scripts/create-db.sh /create-db.sh
ADD scripts/run.sh /run.sh
RUN chmod 777 /*.sh
ADD conf/atom.conf /etc/php5/fpm/pool.d/
ADD conf/my.cnf /etc/mysql/conf.d/my.cnf
ADD conf/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD conf/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD conf/supervisord-elasticsearch.conf /etc/supervisor/conf.d/supervisord-elasticsearch.conf

# Pour que notre installation de atom, mysql et elasticsearch soient accessible à 0.0.0.0:80/atom
EXPOSE 80 3306 9200 9300

# Volume pour partager des fichiers entre le host et le conteneur Docker.
RUN mkdir /partage
VOLUME ["/partage"]

CMD ["/run.sh"]
