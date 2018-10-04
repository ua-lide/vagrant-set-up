# Mise en place de l'environnement de developpement avec Vagrant

LIDE est composé de deux application : une application PHP basé sur le framework Symfony gére les utilisateurs, l'authentification et les pages du sites. Une seconde application Python basé sur le framework Flask assure la gestion de fichiers et l'éxecutions du code des utilisateurs. Ces deux applications pouvant être deployées sur des serveurs séparés, nous simuleront ce fonctionnement sur nos ordinateurs graĉe à des machines virtuelles.

## Pré requis :

* [Vagrant](https://www.vagrantup.com/) : Télécharger la dernière version. Vagrant est un outils permettant la gestion de machine virtuelle pour le développement. La mise à disposition de "box", des machine virtuelles déjà configuré, permet de rapidement mettre en place un environnement de développement. **Ne pas l'installer via le gestionnaire de paquet, vous n'aurez pas la bonne version**
* VirtualBox s'il n'est pas déjà installé. Voir la [documentation ubuntu](https://doc.ubuntu-fr.org/virtualbox)

## Mise en place (Distribution local sous Linux)

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



Clonez le repogit des sources pour le déploiement où vous le faites habituellement :
```
git clone git@gitlab.com:ua-lide/vagrant-set-up.git
```

Placez vous dans votre repo git local des sources pour le déploiement :
```
cd vagrant-set-up
```

Placez vous sur la branche ``feature/setup-auto`` :
```
git checkout feature/setup-auto
```

Modifiez `server-config.yml` situé dans le dossier `configuration` pour y mettre le chemin des sources du projet que vous venez de cloner :
```yaml
- hostname: "web-front"
  ip: "192.168.50.4"
  box: "ubuntu/trusty64"
  apache: "lide.test.conf"
  synced_folders:
    - src: "/path/to/folder" # CHEMIN A CHANGER
      dest: "/home/vagrant/LIDE"
      type: "symfony" # Permet d'activer la creation automatique des schemas en base avec symfony
      options:
        :create: true
        :owner: www-data
        :group: www-data
        :mount_options: ['dmode=0755', 'fmode=0644']
  provision:
    - "provision/common/common.sh"
    - "provision/apache/apache2.sh"
    - "provision/mariadb/mariadb.sh"
    - "provision/php/php7.2.sh"
    - "provision/misc/misc-web.sh"

- hostname: "web-back"
  ip: "192.168.50.5"
  box: "ubuntu/trusty64"
  docker:
    - "gpp" # Le nom du dockerfile sera le nom de l'image sur le guest
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

Une fois la création des VMs terminée vous pouvez accéder à l'application à l'URL suivante :
```
http://192.168.50.4/
OU
http://192.168.50.4/app_dev.php (pour la version en mode développeur)
```

Si vous souhaitez accéder aux VMs :
```
vagrant ssh <nom_vm>
```
Par défaut les noms des deux VMs crées sont `web-front` et `web-back`
