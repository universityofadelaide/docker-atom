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
ADD conf/elasticsearch.list /etc/apt/sources.list.d/
RUN apt-get update && \
  apt-get -y install \
  apache2 \
  ghostscript \
  imagemagick \
  libapache2-mod-php5 \
  libapache2-mod-xsendfile \
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
  python-software-properties \
  supervisor \
  tar \
  wget && \
  echo "ServerName localhost" > /etc/apache2/apache2.conf && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/*

RUN a2enmod rewrite xsendfile

# Installer elasticsearch et ses édpendances.
RUN wget -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -

RUN add-apt-repository ppa:webupd8team/java -y && \
  apt-get update && \
  apt-get install oracle-java8-installer elasticsearch

# Pour lancer le service au démarrage. Si ça ne fonctionne pas on mettra cela dans supervisor.
RUN update-rc.d elasticsearch defaults 95 10
RUN /etc/init.d/elasticsearch start

# Pour télécharger, placer atom au bon endroit et donner les droits pour le serveur Web.
RUN mkdir /var/www/html/atom \
    wget https://storage.accesstomemory.org/releases/atom-2.1.2.tar.gz && \
    tar xzf atom-2.1.2.tar.gz && \
    mv atom-2.1.2/* var/www/html/atom/ && \
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

# Pour que notre installation de atom soit accessible à 0.0.0.0:80/atom
EXPOSE 80 3306

CMD ["/run.sh"]
