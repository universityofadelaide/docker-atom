# Pour le cours ARV3054, idéalement vous devrions utiliser la fonctionnalité de liaison entre les contenants.

FROM ubuntu:latest

MAINTAINER Dominic Boisvert <dominic.boisvert@hbarchivistes.qc.ca>

# Variables pour notre dockerfile.
ENV ATOM_URL https://storage.accesstomemory.org/releases/atom-2.1.2.tar.gz
ENV ATOM_VERSION 2.2.0
ENV ATOM_DB_NAME atom
ENV ATOM_DB_USER root
# ENV ATOM_DB_PASS //Ne fonctionne pas car le mot de passe est vide.
ENV DEBIAN_FRONTEND noninteractive

# Pour mettre à jour les dépôts et installer les paquets nécessaires et faire le ménage.
RUN apt-get update && \
  apt-get -y install \
  apache2 \
  ghostscript \
  imagemagick \
  mysql-server \
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
  echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/*

# Pour télécharger, placer atom au bon endroit et donner les droits pour le serveur Web.
RUN mkdir /var/www/html/atom \
    && wget https://storage.accesstomemory.org/releases/atom-2.1.2.tar.gz && \
    tar xzf atom-2.1.2.tar.gz -C /var/www/html/atom --strip 1 && \
    chown -R www-data:www-data /var/www/html/atom

# Divers scripts et configurations.
ADD scripts/start-apache2.sh /start-apache2.sh
ADD scripts/start-mysqld.sh /start-mysqld.sh
ADD scripts/create-db.sh /create-db.sh
ADD scripts/run.sh /run.sh
RUN chmod 777 /*.sh
ADD conf/my.cnf /etc/mysql/conf.d/my.cnf
ADD conf/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD conf/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Pour que notre installation de atom soit accessible à 0.0.0.0:80/atom
EXPOSE 80 3306

CMD ["/run.sh"]
