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

La majorité des dossiers ont des noms significatifs qui décrit leur utilisation (`constants`,`enums`,`exceptions`,`interfaces`).

Le dossier `models` regroupe les structures de données qui sont utilisées dans le reste du code. Les deux sous-dossiers `firebase` et `local_db` contiennent respectivement les classes représentants les tables dans firebase et les tables dans la base de données locale.

Le dossier `utils` contient des classes statiques qui permettent de regrouper le code réutilisé plusieurs fois ou le code qui est utile au fonctionnement d'une autre classe sans que ce soit la responsabilité de la classe.

`widgets`



### Python

measuring for livestream (preview, raw data view)
recording 120Hz