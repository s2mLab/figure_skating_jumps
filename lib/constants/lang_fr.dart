// global
const String searching = "Recherche en cours";
const String cancel = "Annuler";
const String continueTo = "Poursuivre";
const String goBack = "Retour";
const String pleaseWait = "Veuillez patienter";

// widgets/button/x_sens_dot_connection_button
const String connectionStateMessageConnected = "XSens DOT connecté";
const String connectionStateMessageReconnecting = "Tentative de reconnexion";
const String connectionStateMessageDisconnected = "XSens DOT déconnecté";

// widgets/layout/dot_connected
const String myDevices = "Mes appareils";
const String knownDevicesNear = "Appareils connus à proximité";
const String connectedDevice = "Appareil connecté";

// widgets/layout/no_dot_connected
const String noConnectionMessage =
    "Zut! il semblerait que vous n'ayez pas encore associé un appareil XSens DOT. Tapoter le bouton ci-dessous pour commencer.";

// widgets/layout/ice_drawer_menu
const String rawDataDrawerTile = "Données brutes";
const String addSkaterDrawerTile = "Ajouter un patineur";
const String manageDevicesDrawerTile = "Gérer les XSens DOT";

// widgets/dialogs/connection_new_xsens_dot_dialog
const String bluetoothAuthorizationPrompt =
    'Veuillez donner l\'autorisation à l\'application d\'accéder au Bluetooth. L\'option se trouve généralement dans les paramètres de votre appareil.';
const String newXSensConnectionDialogTitle = 'Connecter un nouvel XSens DOT';
const String completePairing = "Compléter le jumelage";
const String verifyConnectivity = "Vérifier la réception du capteur";
const String configureFrequency = "Configurer la fréquence de réception";
const String configureFrequencyDropMenu = "Sélectionner la fréquence : ";

// widgets/layout/configure_x_sens_dot_dialog
const String forgetDevice = "Oublier";
const String disconnectDevice = "Déconnecter";

// widgets/screens/connection_dot_view
const String managingXSensDotTitle = "Gestion des XSens DOT";
const String connectNewXSensDot = "Connecter un appareil XSens DOT";

// widgets/screens/raw_data_view
const String rawDataTitle = "Données brutes XSens DOT";
const String warnRawDataPrompt =
    "Cette page n'a pas pour but de fournir des données compréhensibles. Avant tout, elle vise à permettre de constater les données en temps réel de l'appareil connecté à des fins de recherche ou de débogage.";

// widgets/screens/login_view
const String loginTitle = "Connexion";
const String connectionButton = "Connexion";
const String connectingButton = "Connexion...";
const String connectionImpossible = "Connexion impossible";
const String createAccount = "Créer un compte";

// widgets/screens/capture_view
const String savingToMemory = "Sauvegarde en mémoire";

// widgets/screens/coach_account_creation_view
const String coachCreateAccountTitle = "Créer un compte";
const String ifNotAnAthletePrompt =
    "Si vous êtes un athlète, vous devez demander à votre entraîneur de vous créer un compte.";
const String pleaseFillField = "Veuillez remplir ce champ.";
const String reduceCharacter = "Réduire le nombre de caractères (max 255).";
const String surname = "Prénom";
const String name = "Nom";
const String password = "Mot de passe";
const String passConfirmSame = "Confirmation mot de passe";
const String email = "Adresse courriel";
const String invalidEmailFormat =
    'L\'adresse courriel n\'est pas de format valide.';
const String alreadyHaveAccount = "J'ai déjà un compte";
const String addCharacters =
    "Le mot de passe doit comporter au moins 10 caractères.";
const String passwordMismatch = "Les mots de passe sont différents.";
const String confirmCreateCoachAccount = "Créer le compte";
const String accountCreationError = "Erreur de création de compte";
const String tryLater = 'Veuillez réessayer plus tard.';

// widgets/screens/skater_creation_view
const String createAthleteExplainPrompt = "L'athlète devra lui-même confirmer son courriel puis pourra choisir son mot de passe à la première connexion. Il sera ensuite disponible dans votre liste d'athlètes.";
const String addASkaterTitle = "Ajouter un patineur";

// exceptions
const String conflictException = "La ressource existe déjà.";
const String weakPasswordException =
    "Le mot de passe ne respecte pas les critères minimaux.";
const String invalidEmailException =
    "L'email n'est pas valide. Veuillez le changer.";
const String nullUserException = "L'utilisateur n'a pas été trouvé.";
const String userNotFoundException = "L'adresse courriel est invalide.";
const String wrongPasswordException = "Mot de passe invalide";
const String emptyFieldException = "Champ(s) vide(s)";
const String tooManyAttemptsException =
    "Trop de tentatives. Veuillez réessayer plus tard.";

