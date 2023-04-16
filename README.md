# Patinage Québec

## Lancer l'application localement

## Firebase

## Structure des fichiers

```bash
.
├── android/app/src/main
│   ├── kotlin/com/example/figure_skating_jumps
│   │   ├── channels
│   │   ├── permissions
│   │   └── x_sens_dot
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
│   │   └── x_sens
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
├── python_analysis
│   ├── app
│   └── 
└── pubspec.yaml
```
### Kotlin
La partie kotlin gère la communication entre le XSens Dot et l'application. Le code source se trouve dans `android/.../figure_skating_jumps`. 

Le premier dossier, `channels`, contient le code qui définit les méthodes de communication (event_channels et method_channels). Le deuxième dossier, `permissions`, est où on s'assure que les permissions requises sont données pour pouvoir continuer. Le dernier dossier, `x_sens_dot`, est où la communication entre le XSens Dot et le code est établie.

Le dossier `res` contient les images de l'application (dans les dossiers `mipmap`) ainsi que des messages utiles (dans le dossier `values/strings.xml`).

Le fichier `AndroidManifest.xml` contient toutes les informations sur l'application, par exemple les permissions déclarées, les services utilisés, etc.

### Dart
La partie `Dart` est celle qui gère le reste de l'application. Le code source est dans le dossier `lib` tandis que les images et les autres ressources graphiques sont dans le dossier `assets`.

La majorité des dossiers ont des noms significatifs qui décrit leur utilisation (`constants`,`enums`,`exceptions`,`interfaces`). Une spécification est que le sous-dossier `enums/x_sens/measuring` est relié à la capture en temps réél du XSens Dot alors que `enums/x_sens/recording` est pour la capture à haute fréquence.

Le dossier `models` regroupe les structures de données qui sont utilisées dans le reste du code. Les deux sous-dossiers `firebase` et `local_db` contiennent respectivement les classes représentants les tables dans firebase et les tables dans la base de données locale.

Le dossier `utils` contient des classes statiques qui permettent de regrouper le code réutilisé plusieurs fois ou le code qui est utile au fonctionnement d'une autre classe sans que ce soit la responsabilité de la classe.

Le dossier `widgets` contient plusieurs sous-dossiers contenant tous les widgets de l'interface graphique de l'application. La majorité des sous-dossiers ont des noms représentatifs comme `buttons` pour les boutons, `dialogs` pour les dialogues, `icons` pour les icones, `titles` pour les titres, `utils` et `views` pour les pages principales de l'application.
Le sous-dossier `layout` est utilisé pour les widgets qu'on voulait regrouper pour alléger le reste du code ou parce qu'il étaient réutilisés ailleurs.

### Python
Dans le dossier `python_analysis`, on retrouve le code pour l'analyse python ainsi que le code pour le serveur. Le fichier `app.py` définit les routes du serveur ainsi que leur logique à l'aide de `Flask`. Les autres fichiers python contiennent le code qui fait fonctionner l'analyse, ils supportent aussi l'utilisation locale à travers un terminal.

Le fichier `requirements.txt` contient les dépendances du projet python et permet de les installer grâce à la ligne de commande suivante:
```bash
pip install -r requirements.txt
```

Pour voir comment exécuter un des fichiers python à travers la ligne de commande il suffit d'éxécuter la commande suivante:
```bash
python <fileName.py> --help
```

