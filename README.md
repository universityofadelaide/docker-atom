# docker-atom
Dockerfile pour atom (accesstomemory)

## Utiliser ce projet

Ce projet est développé et maintenu pour faciliter la prise en main de logiciels dans le cadre du cours ARV3054 - Gestion des archives numériques offert par l'[École de bibliothéconomie et des sciences de l'information] (http://www.ebsi.umontreal.ca/accueil/) de l'[Université de Montrêal] (http://www.umontreal.ca).

Pour utiliser ce projet vous devez installer [Docker] (https://docs.docker.com/engine/installation/) (anglais) pour Windows, Mac OS X ou Linux.

## Instructions

Les instructions ont été développées et testées sous Linux. Les instructions Windows et Mac OS X suivront.

### Installation Linux

Les instructions suivantes permettent d'installer et de faire la configuration initile.

1. Télécharger le zip de ce projet : https://github.com/ARV3054/docker-atom/archive/master.zip
2. Pour lancer l'installation : `$ sudo docker build -t arv3054/atom .`
3. Pour lancer le contenant : `$ sudo docker run -i -t -d -p 80:80 --name atom arv3054/atom`
4. Puis pour créer la base de données faire : `$ sudo docker exec -i -t atom /create-db.sh`

Vous pouvez maintenant visiter votre site à l'URL : `0.0.0.0/atom`

Vous pouvez arrêter votre contenant avec la commande suivante : `$ sudo docker stop atom`

### Démarrer le contenant existant

Si vous souhaitez démarrer votre contenant (que vous avez arrêté avec la commande `stop`) : `$ sudo docker start atom`

### Configuration au premier démarrage de atom

Lors du premier démarrage de ICA-AtoM, et à toutes les fois que vous aurez effacé le contenant (avec la commande `$ sudo docker rm atom`) vous devrez procéder à la configuration initiale de atom[1].

1. Dans votre navigateur, visiter l'URL `0.0.0.0/atom`
2. À venir...

[1] La configuration est nécessaire, mais vous pouvez inscrire les informations de votre choix.
