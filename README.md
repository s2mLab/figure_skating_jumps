<!-- omit in toc -->
# Figure Skating Jumps

## Table des matières
- [Table des matières](#table-des-matières)
- [Répertoire du code source](#répertoire-du-code-source)
- [Architecture](#architecture)
- [Structure des fichiers](#structure-des-fichiers)
  - [Arbre des fichiers importants](#arbre-des-fichiers-importants)
  - [Kotlin](#kotlin)
  - [Dart](#dart)
  - [Python](#Python)
- [Lancer l'application localement](#lancer-lapplication-localement)
  - [Dart-Kotlin](#dart-kotlin)
  - [Serveur Python](#serveur-Python)
- [Communication entre Kotlin et Dart](#communication-entre-kotlin-et-dart)
- [Communication avec le serveur Python](#communication-avec-le-serveur-Python)
- [Communication avec Firebase](#communication-avec-firebase)
- [Communication avec BD locale](#communication-avec-bd-locale)
- [Équipe de développement](#équipe-de-développement)

## Répertoire du code source
Le code source de cette application se retrouve sur GitHub et est accessible à partir du lien suivant: https://github.com/LOG8970-Team14/figure_skating_jumps.

## Architecture
Le projet actuel nécessite un appareil mobile avec l'OS Android 11 ou un émulateur équivalent. À l'instant, le projet ne fonctionne pas sur iOS et il faudrait mettre en place l'intégration avec le SDK du XSens Dot pour iOS.

Le projet se base sur une architecture de micro services. Le service pour communiquer avec le XSens Dot est écrit en `Kotlin`. L'application et sa logique sont en `Dart` et `Flutter`. L'analyse et le serveur d'analyse sont écrit en `python`. L'application communique avec `Firebase` pour gérer l'authentication et le stockage. Lors du développement du projet, le stockage était limité à 1 GB et, pour éviter de surcharger le serveur, le stockage en nuage des vidéos n'a pas été fait.

## Structure des fichiers

### Arbre des fichiers importants
<a id=tree></a>

```bash
.
├── android/app/src/main
│   ├── kotlin/com/example/figure_skating_jumps
│   │   ├── channels
│   │   ├── permissions
│   │   ├── x_sens_dot
│   │   └── MainActivity.kt
│   ├── res
│   └── AndroidManifest.xml
├── assets
├── lib
│   ├── constants
│   ├── enums
│   ├── exceptions
│   ├── interfaces
│   ├── models
│   │   ├── firebase
│   │   └── local_db
│   ├── services
│   │   ├── firebase
│   │   ├── local_db
│   │   ├── x_sens
│   │   └── http_client.dart
│   ├── utils
│   ├── widgets
│   │   ├── buttons
│   │   ├── dialogs
│   │   ├── icons
│   │   ├── layout
│   │   ├── prompts
│   │   ├── titles
│   │   ├── utils
│   │   └── views
│   ├── firebase_options.dart
│   └── main.dart
├── Python_analysis
│   ├── analysis.py
│   ├── analysis_utils.py
│   ├── app.py
│   ├── format.py
│   ├── graph.py
│   ├── ice_exceptions.py
│   └── requirements.txt
└── pubspec.yaml
```

### Kotlin
La partie kotlin gère la communication entre le XSens Dot et l'application. Le code source se trouve dans `android/.../figure_skating_jumps`. 

Le premier dossier, `channels`, contient le code qui définit les méthodes de communication (event_channels et method_channels). Le deuxième dossier, `permissions`, est où on s'assure que les permissions requises sont données pour pouvoir continuer. Le dernier dossier, `x_sens_dot`, est où la communication entre le XSens Dot et le code est établie.

Le dossier `res` contient les images de l'application (dans les dossiers `mipmap`) ainsi que des messages utiles (dans le dossier `values/strings.xml`).

Le fichier `AndroidManifest.xml` contient toutes les informations sur l'application, par exemple les permissions déclarées, les services utilisés, etc.

### Dart
La partie `Dart` est celle qui gère le reste de l'application. Le code source est dans le dossier `lib` tandis que les images et les autres ressources graphiques sont dans le dossier `assets`.

La majorité des dossiers ont des noms significatifs qui décrivent leur utilisation (`constants`,`enums`,`exceptions`,`interfaces`). Une spécification est que le sous-dossier `enums/x_sens/measuring` est relié à la capture en temps réél du XSens Dot alors que `enums/x_sens/recording` est pour la capture à haute fréquence.

Le dossier `models` regroupe les structures de données qui sont utilisées dans le reste du code. Les deux sous-dossiers `firebase` et `local_db` contiennent respectivement les classes représentants les tables dans firebase et les tables dans la base de données locale.

Le dossier `utils` contient des classes statiques qui permettent de regrouper le code réutilisé plusieurs fois ou le code qui est utile au fonctionnement d'une autre classe sans que ce soit la responsabilité de la classe.

Le dossier `widgets` contient plusieurs sous-dossiers contenant tous les widgets de l'interface graphique de l'application. La majorité des sous-dossiers ont des noms représentatifs comme `buttons` pour les boutons, `dialogs` pour les dialogues, `icons` pour les icones, `titles` pour les titres, `utils` et `views` pour les pages principales de l'application.
Le sous-dossier `layout` est utilisé pour les widgets qu'on voulait regrouper pour alléger le reste du code ou parce qu'il étaient réutilisés ailleurs.

### Python
Dans le dossier `python_analysis`, on retrouve le code pour l'analyse Python ainsi que le code pour le serveur. Le fichier `app.py` définit les routes du serveur ainsi que leur logique à l'aide de `Flask`. Les autres fichiers Python contiennent le code qui fait fonctionner l'analyse, ils supportent aussi l'utilisation locale à travers un terminal. Le fichier `requirements.txt` contient les dépendances du projet Python.

## Lancer l'application localement

### Dart-Kotlin
Pour commencer, il faut installer Android Studio (https://developer.android.com/studio). Il faudra installer un SDK android à partir du SDK Manager d'Android Studio pour le futur (Android 11+).

Il faut ensuite installer Dart (https://dart.dev/get-dart) et Flutter (https://docs.flutter.dev/get-started/install). Pour vous assurer que votre installation s'est bien faite, rouler la commande `flutter doctor` dans votre terminal et apportez les corrections nécessaires.

Il faudra ensuite connecter un appareil Android à votre ordinateur ou créer un émulateur dans Android Studio. **Attention**, les émulateurs ne peuvent pas faire de connections Bluetooth, il vous faudra un appareil physique pour le faire.

Une fois que vous avez un appareil pour exécuter le code, il ne reste qu'à le lancer en utilisant l'interface graphique d'Android Studio.

### Serveur Python
Pour mettre en place le serveur Python, il faut commencer par installer les dépendances. Pour éviter d'avoir des problèmes de versions de paquets avec Python, on recommande de faire l'installation dans un environnement virtuel, un conteneur Docker ou de le gérer avec Conda ou un autre outil de gestion de paquets. La commande est: `pip install -r requirements.txt`.

L'application peut ensuite être partie avec la commande `python app.py`.

## Communication entre Kotlin et Dart
Pour communiquer l'information entre `Kotlin` et `Dart`, on utilise des `method channels` et des `events channels`. Les deux permettent une communication bidirectionnelle pour gérer les trois machines à état qui sont utilisées pour interagir avec le XSens Dot.

Les `method channels` ont un nom qui est associé à un `handler` qui gèrera les appels. Avec les `method channels`, ont permet d'exposer des fonctions `Kotlin` au code `Dart`. Dans le fichier `MainActivity.kt` ([voir le tableau](#tree)), on retrouve les `handlers` ainsi que la fonction qui fait le lien entre le nom d'un `method channel` et de son `handler` respectif. En utilisant les `method channels`, on peut communiquer du `Dart` vers le `Kotlin`.

Dans le cas ou on désire ajouter le support pour des appareils `iOS`, il faudrait créer toutes les fonctions qui sont définies dans les `handlers` dans `MainActivity.kt`, mais pour `iOS`. Cela nécessitera probablement une recherche significative, mais l'implémentation Android devrait pouvoir servir d'exemple ou d'inspiration dans le cas où des mécanismes similaires seraient disponibles sur iOS, bien que nous n'en soyons pas certains.

Les handlers sont les suivants:

`handleBluetoothPermissionsCalls` qui gère les permissions bluetooth. Il n'y a qu'une seule fonction: `managePermissions`.

`handleRecordingCalls` qui gère la capture à haute fréquence. Il y a plusieurs fonctions: `enableRecordingNotification`, `startRecording`, `stopRecording`, `setRate`, `getFlashInfo`, `getFileInfo`, `extractFile`, `prepareExtract`, `prepareRecording` et `eraseMemory`.

`handleMeasuringCalls` qui gère la capture en temps réel. Il y a les fonctions: `startMeasuring`, `stopMeasuring` et `setRate`.

`handleConnectionCalls` qui gère la connection du XSens Dot. Il y a les fonctions: `connectXSensDot` et `disconnectXSensDot`.

`handleScanCalls` qui gère le balayage pour des signaux Bluetooth. Il y a les fonctions: `startScan` et `stopScan`.

## Communication avec le serveur Python
Pour communiquer avec le serveur d'analyse, on utilise le fichier `http_client.dart`. Celui-ci contient l'adresse ip du serveur (qu'il faudrait éventuellement bouger dans un fichier d'environnement ou un équivalent - nous n'avons pas trouvé comment avec Dart).
Il y a aussi les deux fonctions nécessaires pour faire une analyse.

La première route `/file`, permet de téléverser un fichier sur le serveur avec la méthode `HTTP` `PUT`.
Pour ce faire, il faut passer le contenu du fichier csv en texte dans le `body` de la requête. Il faut aussi passer un nom au fichier avec le paramètre `fileName` en `query`. Il faut aussi indiquer que le contenu est en texte avec le `header` `Content-Type = text/plain`.
La route retourne une réponse `200 OK` sans `body` dans le cas d'un succès. Dans le cas où il y a une erreur, le serveur retournera une erreur `500 INTERNAL SERVER ERROR`.

La seconde route `/analyse`, permet de faire une analyse sur un fichier `csv` existant sur le serveur avec la méthode `HTTP` `POST`.
Pour se faire, il faut passer le nom du fichier à analyser dans le `body` en format `json` avec la clé `fileName`. Il faut aussi spécifier que le contenu est en format `json` avec le `header` `Content-Type = application/json`.
La route retourne une réponse `200 OK` avec des sauts encodés en format `json` lors d'un succès. Dans le cas où le fichier n'est pas trouvé où qu'il est vide, on retourne une erreur `404 NOT FOUND` avec un message approprié en `body`. Si le fichier n'a pas le bon format lors de la lecture, le serveur répondera une erreur `400 BAD REQUEST` avec un message approprié en `body`. Finalement, dans le cas d'une autre erreur, le serveur répondera une erreur `500 INTERNAL SERVER ERROR` avec aucun `body`.

## Communication avec Firebase
Toutes les méthodes pour communiquer avec le serveur Firebase sont dans le fichier `services/firebase`.
Chaque collection a son propre client qui permet de gérer les cas d'utilisation différents. Il y a aussi un fichier dans `models/firebase` qui représente une entité dans la collection.
La collection `jumps` est gérée dans `capture_client.dart` puisque leur utilisation est très liée.

## Communication avec BD locale
Toutes les méthodes pour gérer la base de données locale se trouvent dans le fichier `services/local_db`. C'est une base de données `sqlite` qui utilise le paquet `sqflite`.
Le fichier `local_db_service` s'occupe de la création de la base de données. Il y a un code initial qui créé la base de données et après une liste de modifications sous le format de migrations. Ceci permet de faire une mise à jour dynamique de la base de données lors de changements (bien qu'il peut y avoir des problèmes dépendemment du type du changement).
Chaque table dans la base de données a un fichier `manager` équivalent pour gérer les cas d'utilisation dans le code. Il y a aussi un fichier dans `models/local_db` qui à chaque table de la base de données.

## Équipe de développement
Cette application a été développée par Christophe St-Georges, David Saikali, Jimmy Bell et Thomas Beauchamp en Hiver 2023 dans le cadre d'un projet intégrateur de fin de baccaulauréat en génie logiciel à Polytechnique Montréal en collaboration avec Patinage Québec, le laboratoire de simulation et
modélisation du mouvement (Université de Montréal) et l’Institut National du Sport du Québec.

[Christophe St-Georges](https://www.linkedin.com/in/christophe-st-georges-log/)

[David Saikali](https://www.linkedin.com/in/david-saikali/)

[Jimmy Bell](https://www.linkedin.com/in/jimmybell-log/)

[Thomas Beauchamp](https://www.linkedin.com/in/thomas-beauchamp-9051891a1/)
