# Mise en place de l'environnement de developpement avec Vagrant

LIDE est composé de deux application : une application PHP basé sur le framework Symfony gére les utilisateurs, l'authentification et les pages du sites. Une seconde application Python basé sur le framework Flask assure la gestion de fichiers et l'éxecutions du code des utilisateurs. Ces deux applications pouvant être deployées sur des serveurs séparés, nous simuleront ce fonctionnement sur nos ordinateurs graĉe à des machines virtuelles.

## Pré requis :

* [Vagrant](https://www.vagrantup.com/) : Télécharger la dernière version. Vagrant est un outils permettant la gestion de machine virtuelle pour le développement. La mise à disposition de "box", des machine virtuelles déjà configuré, permet de rapidement mettre en place un environnement de développement. **Ne pas l'installer via le gestionnaire de paquet, vous n'aurez pas la bonne version**
* VirtualBox s'il n'est pas déjà installé. Voir la [documentation ubuntu](https://doc.ubuntu-fr.org/virtualbox)

## Mise en place (Distribution local sous Linux)

### Sources de la partie applicative

Clonez le repogit des sources du projet où vous le faites habituellement :
```
git clone git@gitlab.com:ua-lide/lide.git
```

Placez vous dans le repertoire `lide` :
```
cd lide
```

Placez vous sur la branche ``develop`` :
```
git checkout develop
```

### Sources de la partie métier

Clonez le repogit des sources du projet où vous le faites habituellement :
```
git clone git@gitlab.com:ua-lide/lide-project-manager-app.git
```

Placez vous dans le repertoire `lide` :
```
cd lide-project-manager-app
```

Placez vous sur la branche ``develop`` :
```
git checkout develop
```

### Mise en place du JWT

Placez vous dans les sources de la partie applicative :
```
cd lide
```

Générer les clefs pour le JWT (mettez la même passphrase partout) :
```
mkdir -p config/jwt
openssl genrsa -out config/jwt/private.pem -aes256 4096
openssl rsa -pubout -in config/jwt/private.pem -out config/jwt/public.pem
openssl rsa -in config/jwt/private.pem -out config/jwt/private2.pem
mv config/jwt/private.pem config/jwt/private.pem-back
mv config/jwt/private2.pem config/jwt/private.pem
```

**/!\ Lancez les commandes de openssl une a une sinon la génération des clefs va échouer**

Copier `config/jwt/public.pem` dans les sources de lide-project-manager-app :
```
mkdir -p ../lide-project-manager-app/config/jwt
cp config/jwt/public.pem ../lide-project-manager-app/config/jwt/
```

### Sources pour le déploiement

Clonez le repogit des sources pour le déploiement où vous le faites habituellement :
```
git clone git@gitlab.com:ua-lide/vagrant-set-up.git
```

Placez vous dans votre repo git local des sources pour le déploiement :
```
cd vagrant-set-up
```

Modifiez `server-config.yml` situé dans le dossier `configuration` pour y mettre le chemin des sources du projet que vous venez de cloner :
```yaml
- hostname: "web-front"
  ip: "192.168.50.4"
  box: "ubuntu/trusty64"
  apache: "lide.test.conf"
  synced_folders:
    - src: "/path/to/folder" # CHEMIN A CHANGER VERS LES SOURCES DE LA PARTIE APPLICATIVE : LIDE
      dest: "/home/vagrant/LIDE"
      type: "symfony_app" # Permet d'activer la creation automatique des schemas en base avec symfony
      options:
        :create: true
        :owner: www-data
        :group: vagrant
        :mount_options: ['dmode=0775', 'fmode=0664']
  provision:
    - "provision/common/common.sh"
    - "provision/apache/apache2.sh"
    - "provision/mariadb/mariadb.sh"
    - "provision/php/php7.2.sh"
    - "provision/misc/misc-web.sh"

- hostname: "web-back"
  ip: "192.168.50.5"
  box: "ubuntu/trusty64"
  apache: "lide-pma.conf"
  docker:
    - "gpp" # Le nom du dockerfile sera le nom de l'image sur le guest
  synced_folders:
    - src: "/path/to/folder" # CHEMIN A CHANGER VERS LES SOURCES DE LA PARTIE METIER : LIDE PROJECT MANAGER APP
      dest: "/home/vagrant/lide-pma"
      type: "symfony_metier"
      options:
        :create: true
        :owner: www-data
        :group: vagrant
        :mount_options: ['dmode=0775', 'fmode=0664']
  provision:
    - "provision/common/common.sh"
    - "provision/docker/docker.sh"
    - "provision/apache/apache2.sh"
    - "provision/php/php7.2.sh"
```

Lancez la création des VMs :
```
vagrant up
```

Si vous souhaitez accéder aux VMs :
```
vagrant ssh <nom_vm>
```
Par défaut les noms des deux VMs crées sont `web-front` et `web-back`

## Lancer le server Web Socket

Connectez-vous à la VM `web-back`:
```
vagrant ssh web-back
```

Lancez le server Web Socket avec la commande suivante :
```
cd lide-pma
php bin/console lide:start-server
```

Vous pouvez accéder à l'application à l'URL suivante :
```
http://www.lide.test/
OU
http://www.lide.test/app_dev.php (pour la version en mode développeur)
```
