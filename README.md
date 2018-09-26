# Mise en place de l'environnement de developpement avec Vagrant

LIDE est composé de deux application : une application PHP basé sur le framework Symfony gére les utilisateurs, l'authentification et les pages du sites. Une seconde application Python basé sur le framework Flask assure la gestion de fichiers et l'éxecutions du code des utilisateurs. Ces deux applications pouvant être deployées sur des serveurs séparés, nous simuleront ce fonctionnement sur nos ordinateurs graĉe à des machines virtuelles.

## Pré requis :

* [Vagrant](https://www.vagrantup.com/) : Télécharger la dernière version. Vagrant est un outils permettant la gestion de machine virtuelle pour le développement. La mise à disposition de "box", des machine virtuelles déjà configuré, permet de rapidement mettre en place un environnement de développement. **Ne pas l'installer le gestionnaire de paquet, vous n'aurez pas la bonne version**
* VirtualBox s'il n'est pas déjà installé. Voir la [documentation ubuntu](https://doc.ubuntu-fr.org/virtualbox)

## Mise en place d'Homestead pour l'application symfony

Homestead est une box Vagrant, à l'origine développé pour le framework PHP Laravel, mais qui supporte aussi Symfony. Vous pouvez trouver la documentation sur [le site Laravel](https://laravel.com/docs/5.6/homestead#first-steps)

### Installation d'Homestead

Cet partie est extrait de la documentation officelle.

* Cloner le repo Homestead
```
git clone https://github.com/laravel/homestead.git /path/to/install/folder
```

* Deplacer vous dans le repertoire
```
cd /path/to/install/folder
```

* Lancer le script d'initialisation (pensez à changer les droits sur le fichier, si nécessaire)
```
./init.sh
```

## Installation du projet Symfony

* Cloner le repertoire git
```
git clone git@gitlab.com:ua-lide/lide.git /path/to/project/folder
```

Puis placer vous sur la branche develop
```
cd /path/to/project/folder && git checkout develop 
```

* Ensuite, dans le dossier d'installation de Homestead, ouvrer le fichier ``Homestead.yaml`` puis ajouter (si les categories folder et sites existe déjà, ajouter à la suite. Regarder la docs d'Homestead pour comprendre ce qui est fait)
```
folders:
    - map: /path/to/project/folder
      to: /home/vagrant/LIDE
sites:
    - map: lide.test
      to: /home/vagrant/LIDE/web
      type: symfony2
```

Vous pouvez maintenant modifier votre fichier `/etc/hosts` pour faire pointer l'adresse lide.test vers l'ip de votre box (c'est la ligne ip: "XXXXXX" de votre Homestead.yaml, par défaut 192.168.10.10.). Ajouter la ligne suivante à votre fichier /etc/hosts :
```
192.168.10.10 lide.test
```

Ensuite, deplacer vous dans le dossier où vous avez installer homestead, puis lancer la box avec ``vagrant up``.

Vous pouvez ensuite vous connectez à votre machine virtuelle avec la commande ``vagrant ssh``. 

Une fois connecter à la machine virtuel, déplacer vous dans le repertoire du projet (`cd ~/LIDE`), puis lancer les commandes suivantes
* `composer install`
  * Cette commande va vous demander de renseigner les paramètres suivants :
  ```
  database_host: localhost
  database_port: 3306
  database_name: lide_db
  database_user: homestead
  database_password: secret
  mailer_transport: smtp
  mailer_host: smtp.gmail.com
  mailer_user: null
  mailer_password: null
  mailer_auth_mode: login
  mailer_encryption: ssl
  secret: ThisTokenIsNotSoSecretChangeIt
  ssh_host: 192.168.10.1
  ssh_login: etudiant
  ssh_password: [votre mot de passe]
  ssh_port: 22
  wget_adr: 'http://lide.test'
  docker_stop_timeout: 120
  docker_memory: 10M
  docker_cpu: 1
  add_hosts: 'lide.test:192.168.10.10'
  docker_name_prefix: lide_
  mails_suffixe:
      - etud.univ-angers.fr
      - univ-angers.fr
  ```
* `npm install` (Installation des paquets javascript)
* `npm install gulp -g` (Installation global de gulp)
* `gulp all` (Deployement des assets fontend)
* `php app/console doctrine:database:create` (création de la base de données)
* `php app/console doctrine:schema:create` (création des tables)
* `php app/console doctrine:fixtures:load` (chargement des fixtures, cad des données dans la base)

Vous pouvez maintenant accèder au site depuis votre navigateur à l'adresse `lide.test`. Vous pouvez vous connectez en administrateur avec le nom d'utilisateur `admin` et le mot de passe `admin`

# Installation de la box pour l'autre appli

* Cloner le repertoire [Lide Project Manager App](https://gitlab.com/ua-lide/lide-project-manager-app) :
    * `git clone git@gitlab.com:ua-lide/lide-project-manager-app.git
* Deplacer vous dans le repertoire du projet, puis installer les dépendances composer : 
    * `composer install --ignore-platform-reqs` 
* Initialiser la box : `php vendor/bin/homestead make`
* Copier le Homestead-example.yaml vers Homestead.yaml : `cp Homestead-example.yaml Homestead.yaml`
* Adapter le contenu du fichier : verifier le mapping des dossiers
* Demarer la box : `vagrant up`
* Connecter vous à la box : `vagrant ssh`
* Deplacer vous dans le repertoire du projet sur la box (normalement `~/code`), puis lancer `composer install` pour verifier que toutes les dépendances systèmes sont bien installer.

# Faire communiquer les deux machines virtuelles

Afin de faire communiquer les deux machines virtuelles, ajouter les lignes suivantes dans le `Homestead.yaml` de chaque machine :
```
networks:
    - type: "private_network"
      ip: "[ip de la box]"
```

Lancer ensuite la commande `vagrant reload --provision` dans chacun des dossiers contenant les machines virtuelles afin de mettre à jour la configuration.

Ensuite, nous allons configurer l'application web afin qu'elle utilise la box de Lide Project Manager pour lancer les conteneurs. Dans le dossier du projet Lide, ouvrez le fichier `app/config/parameter.yml`, et modifier les valeurs des paramètres suivants :
```
    ssh_host: 192.168.10.11 #Ip de la box du Lide Project Manager
    ssh_login: vagrant
    ssh_password: vagrant
    ssh_port: 22
```

## Monter l'image docker du c++ dans la box du Lide Project Manager

Connecter vous en ssh à la box du Lide Manager Project
```
cd /path/to/lide/manager/project && vagrant ssh
```

Créer un dossier docker et déplacer vous dedans
```
mkdir docker && cd docker
```

Créer un fichier Dockerfile en l'ouvrant avec nano ou vim
```
nano Dockerfile
```

Copier coller le contenu du fichier suivant : https://gitlab.com/ua-lide/lide/blob/develop/docker/Dockerfile

Construire ensuite l'image docker
```
docker build -t gpp .
```

Vérifier qu'il n'y a pas d'erreur.

Executer ensuite la commande
```
docker images 
``` 

Vous aurez normalement une sortie similaire à celle ci :
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
gpp                 latest              53378015f1e8        28 hours ago        375MB
```