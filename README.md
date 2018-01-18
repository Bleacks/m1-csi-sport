# Plateforme de gestion d'une salle de sport

## Sommaire

#### Présentation
- Prérequis
- Technologies utilisées

#### Installation de l'environnement
- Récupération du dépôt
- Installation de composer
- Installation des dépendances
- Préparation de Xamp
- Préparation d'Atom

#### Informations supplémentaires
- Philosophie générale
- Normalisation
- Contributeurs

## Présentation

Projet inscrit dans le cadre du module de CSI (Conception de Système d'Information) du Master MIAGE Nancy.
Nous devons développer une application capable de gérer une salle de sport (inscrits, abonnements, planning des séances, etc). Ce projet à pour principal but d'être fonctionnel, sécurisé et optimisé.

### Prérequis

* **Git** - *Gestionnaire de Version* - [git-scm.com/downloads](https://git-scm.com/downloads)
* **PhP** - *Interprêter les scripts* - [php.net/downloads](http://php.net/downloads.php)
* **Composer** - *Pour installer les dépendances* - [getcomposer.org/download](https://getcomposer.org/download/)
* **Apache** - *Fonctionnalité de réecriture d'URL* - [httpd.apache.org/download](https://httpd.apache.org/download.cgi)
* **PostgreSQL** - *Gestion de la BDD* - [https://www.postgresql.org](https://www.postgresql.org)

### Technologies utilisées

* [Php](http://php.net/) - Utilisé pour les tâches back-end
* [Slim](https://www.slimframework.com/) - Utilisé pour gérer la redirection des requêtes HTTP
* [Idorm](https://github.com/j4mie/idiorm) - L'utilitaire de connexion à la base de données
* [Materialize](http://materializecss.com/) - Framework front-end

## Installation de l'environnement

#### Récupération du dépôt
```
git clone https://github.com/Bleacks/m1-csi-sport.git
```

#### Installation de composer

Sur Windows : [https://getcomposer.org/download/](https://getcomposer.org/download/)

Sur Linux / Mac OS :
```
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/
vim ~/.bash_profile
alias composer="php /usr/local/bin/composer.phar"
```

#### Installation des dépendances

A la racine du projet
```
composer install
```

#### Préparation de Xamp

- Télécharger Xamp : [https://www.apachefriends.org/fr/index.html](https://www.apachefriends.org/fr/index.html)
- Installer PostgreSQL : [https://www.postgresql.org](https://www.postgresql.org)
- Autoriser le nouveau site dans Apache
- Activer le module Url Rewrite d'Apache


#### Préparation d'Atom

- Télécharger Atom : [https://atom.io](https://atom.io)
- Changer l'encodage du texte pour `UTF-8`
- Changer la taille d'indentation à 4 (2 par défaut)
- Installation des packages Atom :
```
api install atom-autocomplete-php
busy-signal
docblockr
file-header
intentions
linter
linter-php
linter-ui-default
php-cs-fixer
php-hyperclick
platformio-ide-terminal
```

#### Installation de la base de donnée

- Pour utiliser la base de donnée en local:
- Executer dans l'ordre les fichiers script.sql, script fonctions.sql, script triggers.sql, script droits.sql
- Ceci créera les rôles suivant dans la base à partir du quel il est possible de se connecter:
```
inscrit_adherent
inscrit__non_adherent
coach_1
admin_1
personnel_accueil_1
```
Tous ces rôles ont pour mot de passe 'a'

## Informations supplémentaires
### Philosophie générale
- Faire des commits réguliers
- Lire la documentation en ligne en cas de soucis
- Produire du code lisible et facile à maintenir (lisibilité > optimisation)
- Chaque version sur le dépôt doit être testée avant envoi. De sorte que la version en ligne soit toujours fonctionnelle. Utilisez les branches si besoin.

### Normalisation
- Les classes suivent les normes PSR (ex: une classe à pour nom son nom de fichier)
- La documentation doit toujours être à jour sur le dépôt. Des commentaires peuvent être ajoutés dans les parties nécessitant des explications, mais ceux-ci ne doivent en aucun cas remplacer la documentation, mais la compéter.

### Contributeurs

* **Maxime Dolet** - *Conception, développement et documentation* - [Bleacks](https://github.com/Bleacks)
* **Nicolas Calley** - *Analyse et développement*
* **Benoît Cante** - *Analyse et BDD*
* **Abdoulaye Dialo** - *Analyse*
