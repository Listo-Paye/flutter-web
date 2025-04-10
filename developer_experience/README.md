# Comparaison de l'expérience développeur entre Flutter et ReactJS

Cette fois-ci, nous allons réutiliser toutes les astuces et les bonnes pratiques des autres catégories pour créer un projet de démonstration qui mettra en avant les différences entre Flutter et ReactJS. Nous allons nous concentrer sur la gestion de l'état, la navigation, le routage, les tests et l'architecture.

L'objectif ici est de comparér l'expérience développeur entre Flutter et ReactJS, en mettant en avant les avantages et les inconvénients de chaque technologie. Nous allons également aborder la question de la performance, de la maintenabilité et de la scalabilité des deux solutions.

## Starter kits et entrée en matière

Nous commencerons par jouer les rôles de développeurs débutants en utilisant les Starter kits de chaque technologie. Nous avons déjà des starter kits React et Flutter qui sont prêts à l'emploi avec une clean architecture opérationnelle, une documentation détaillée et une gestion de l'authentification OAuth2 ainsi qu'un retrofit pour les appels API.

### Serveur et API

Nous allons utiliser un serveur Node.js avec Express pour gérer les appels API. Le serveur sera configuré pour répondre aux requêtes des deux applications (Flutter et ReactJS) et servira de point d'entrée pour les données.

Il validera également l'authentification mais ne fournira que des données de test. L'objectif ici n'est pas de fournir une application sur étagère mais de démontrer les différences entre les deux technologies.

### Authentification

Nous allons utiliser Keycloak pour gérer l'authentification OAuth2. Keycloak est un serveur d'identité open source qui permet de gérer les utilisateurs, les rôles et les permissions. Il est facile à configurer et offre une interface utilisateur conviviale pour la gestion des utilisateurs.

## Mode expert

Une fois que nous aurons terminé la phase de démarrage, nous passerons en mode expert. Nous reprendrons les tests et une partie du code pour les adapter à une architecture plus complèxe avec des exigences de performance et de maintenabilité. Nous allons également aborder la question de la scalabilité et de la gestion des états complexes.

L'objectif ici est de démontrer ce qu'il est possible de faire lorsque l'on pousse les deux technologies à des niveaux très avancés.

Pourquoi ne pas le faire directement depuis les starter kits ? L'objectif de nos starter kits est de fournir une porte d'entrée au software craftmanship. Le principe est d'avoir quelque chose d'abordable pour les développeurs débutants. Il est à noter que la lisibilité est aussi affaire d'expérience et de maturité. Il est donc fort probable qu'un développeur qui débute puisse avoir plus de difficultés à comprendre et se représenter les intéractions de ce "mode expert".

# Projet de démonstration: TransFleet Manager

TransFleet Manager est une solution intégrée destinée à révolutionner la gestion opérationnelle des agences de transport. Conçue pour optimiser l'ordonnancement des lancements de camions, assurer un suivi administratif précis et orchestrer intelligemment les affectations de livraisons aux conducteurs selon leur disponibilité, cette application se positionne comme un outil stratégique pour les décideurs souhaitant maximiser l'efficacité et la performance de leur flotte.

## Contexte et Objectifs

Dans un secteur en constante évolution, où la réactivité et la conformité réglementaire sont primordiales, TransFleet Manager se propose de répondre aux défis spécifiques des agences de transport modernes. L'application intègre :
- Un système d’ordonnancement des lancements de camions,
- Une gestion dynamique des affectations des livraisons et des ressources humaines,
- Un reporting avancé avec génération de KPI,
- Des alertes et notifications en temps réel,
- Une messagerie sécurisée pour faciliter la communication entre les équipes administratives et les conducteurs,
- Un module de gestion prédictive des entretiens,
- Et un ensemble de mécanismes de gamification visant à stimuler la motivation et l’engagement des équipes.

L'objectif principal est de fournir une interface intuitive et performante, capable de centraliser l’ensemble des opérations quotidiennes et d’offrir une visibilité stratégique aux cadres, tout en respectant les impératifs de sécurité, notamment grâce à l'intégration de Keycloak pour une authentification robuste via OAuth2.

## Choix Technologiques et Approche Comparée

Pour établir un comparatif complet de l'expérience développeur et de la robustesse fonctionnelle, TransFleet Manager sera développé parallèlement en **Flutter** et en **ReactJS**.
- **Flutter** : La solution tirera parti d’un environnement de développement multi-plateforme, garantissant une expérience homogène sur Android, iOS, le web et le desktop. La rapidité du hot reload, la compilation en code natif et l’architecture modulaire basée sur des patterns comme BLoC ou Riverpod offriront une base de code hautement lisible, maintenable et évolutive.
- **ReactJS** : En parallèle, une implémentation en ReactJS (associée à Vite, InversifyJS et pilotée par Jest-Cucumber pour le testing de comportement) permettra d’établir une comparaison fine en matière de rapidité de développement, de productivité et de maintenabilité.

Cette dualité de développement vise à démontrer que, quel que soit l’outil choisi, il est possible de réaliser une solution performante et conforme aux attentes strictes des cadres en gestion de flotte, tout en tirant parti des spécificités de chaque écosystème.

## Pilotage par des Tests de Comportement

Afin de garantir l'exactitude, la robustesse et la qualité des fonctionnalités, le projet sera piloté par une approche basée sur le testing de comportement (BDD - Behavior Driven Development).
- L'ensemble des fonctionnalités – depuis l'ordonnancement jusqu'à la gestion prédictive des entretiens – sera défini via des scénarios de tests clairs et exhaustifs.
- Ces scénarios permettront d'assurer une cohérence dans les interactions entre les différents modules de l'application, et garantiront que chaque évolution de code respecte les exigences métier définies.
- Le recours à des outils tels que Jest-Cucumber (pour ReactJS) et bdd_widget_test (pour Flutter) facilitera l’automatisation des tests et contribuera à maintenir une qualité de code irréprochable tout au long du cycle de développement.

## Aperçu des Fonctionnalités

TransFleet Manager se caractérise par :
- **Une interface d’ordonnancement** : qui permet une planification rigoureuse des lancements de camions en fonction de la disponibilité et des priorités opérationnelles.
- **Une gestion des affectations** : optimisée pour répartir intelligemment les livraisons entre les conducteurs et les véhicules disponibles.
- **Des outils de suivi administratif et de reporting** : offrant une visibilité stratégique à travers des dashboards interactifs et des rapports détaillés.
- **Une messagerie intégrée** : assurant la communication en temps réel entre les équipes centrales et les conducteurs.
- **Un module de gestion prédictive des entretiens** : qui anticipe les besoins de maintenance afin de prévenir toute interruption non planifiée.
- **Des éléments de gamification** : destinés à renforcer l’engagement et la motivation, tout en favorisant une communication efficace et centralisée.
