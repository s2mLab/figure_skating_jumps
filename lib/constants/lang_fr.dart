// global
const String searchingLabel = "Recherche en cours";
const String cancelLabel = "Annuler";
const String confirmLabel = "Confirmer";
const String continueToLabel = "Poursuivre";
const String goBackLabel = "Retour";
const String pleaseWaitLabel = "Veuillez patienter";
const String saveLabel = "Enregistrer";
const String allLabel = "Toutes";
const String minuteLabel = "minutes";
const String secondsLabel = "secondes";
const String calculatingLabel = "Calcul en cours...";
const String remainingTimeLabel = "Temps restant: ";

// enums/season
const String preparationSeasonLabel = "Préparation";
const String competitionSeasonLabel = "Compétition";
const String transitionSeasonLabel = "Transition";
const String sharpeningSeasonLabel = "Affûtage";

// enums/helper_subject
const String connectDotTitle = "Connecter un senseur";
const String connectDotDescription =
    "Pour connecter un XSens Dot, assurez-vous que la batterie soit pleine, cliquez sur la barre de statut du senseur ou le bouton suivant.\n\nVous pourrez ainsi connecter un XSens Dot déjà enregistré ou un nouvel appareil avec le bouton au bas de la page.";
const String addSkaterTitle = "Ajouter un patineur";
const String addSkaterDescription =
    "Vous pouvez ajouter un athlète à votre liste avec le courriel du compte athlète.\n\nDans le cas où un athlète n'a pas de compte, l'entraineur doit créer un compte pour celui-ci. Lors de la première connexion de l'athlète, celui-ci pourra réinitialiser son mot de passe.";
const String skaterInfoTitle = "Qui a accès à mes informations";
const String skaterDescription =
    "Vous pouvez voir la liste des entraineurs en consultant votre profil avec le bouton suivant.\n\nCes entraineurs peuvent consulter les captures et les rétroactions de chaque acquisition faite. Cependant, les vidéos ne sont accessibles que sur l'appareil utilisé.";
const String modificationInfoTitle = "Modifier mes informations";
const String modificationDescription =
    "En cliquant sur le bouton suivant, vous accèderez à votre profil. Vous pourrez ainsi modifier votre nom, prénom et mot de passe.";
const String newAcquisitionTitle = "Prendre une nouvelle capture";
const String newAcquisitionDescription =
    "Afin de prendre une nouvelle capture, il suffit de cliquer sur le bouton \"Capturer\" de la liste des captures. Si le support vidéo n'est pas activé, il est possible de l'activer dans les paramètres du téléphone dans les permissions d'application.";

// widgets/dialogs/modify_full_name
const String modificationTitle = "Modification";
const String firstNameField = "Prénom: ";
const String lastNameField = "Nom: ";
const String modifyButton = "Modifier";

// widgets/dialogs/modify_password
const String helperTitle = "Page d'aide";
const String redirectButton = "Me diriger sur la page";

// widgets/dialog/capture/start_recording_dialog
const String connectXSensDotButton = "Connecter un appareil XSens DOT";
const String noDeviceErrorInfo =
    "Il semblerait qu'il n'y ait pas de XSens Dot connecté ou que celui-ci ne soit pas encore prêt à être utilisé. Si vous n'avez pas connecté d'appareil, veuillez vous diriger vers la page de connexion afin de connecter un capteur. Sinon, veuillez attendre que l'indicateur en haut de l'écran montre que le capteur est prêt et réessayez.";

// widgets/dialog/capture/no_camera_recording_dialog
const String recordingLabel = "Collecte de donnée en cours...";

// widgets/dialogs/connection_new_xsens_dot_dialog
const String bluetoothAuthorizationPromptInfo =
    'Veuillez donner l\'autorisation à l\'application d\'accéder au Bluetooth. L\'option se trouve généralement dans les paramètres de votre appareil.';
const String newXSensConnectionDialogTitle = 'Connecter un nouvel XSens DOT';
const String completePairingButton = "Compléter le jumelage";
const String verifyConnectivityLabel = "Vérifier la réception du capteur";
const String connectionErrorLabel =
    "Erreur lors de la connexion à l'appareil: ";

// widgets/dialogs/modification_info_dialog
const String modificationInfoDialogTitle =
    "Journal de modification pour cette capture";

// widgets/dialog/capture/start_recording_dialog
const String captureStartingLabel = "Démarrage...";
const String erasingDataLabel = "Suppression des données en cours...";
const String errorCaptureStartingLabel = "Erreur lors du démarrage";
const String memoryErrorInfo =
    "Il semblerait que votre capteur est saturé. Afin de réaliser la capture, veuillez vider la mémoire du capteur et réessayer.";
const String emptyMemoryButton = "Vider la mémoire";

// widgets/dialog/capture/capture_error_dialog
const String errorCaptureLabel = "Erreur lors de la capture";
const String errorCaptureInfo =
    "Une erreur est survenue lors de la capture de données. Veuillez redémarrer le XSens DOT et réessayer.";

// widgets/dialogs/modify_password
const String modificationPasswordTitle = "Modification mot de passe";
const String passwordField = "Mot de passe: ";
const String passwordConfirmationField = "Confirmation mot de passe: ";

// widgets/button/x_sens_dot_connection_button
const String connectionStateMessageConnectedLabel = "XSens DOT connecté";
const String connectionStateMessageInitializedLabel = "XSens DOT prêt";
const String connectionStateMessageConnectingLabel = "Tentative de connexion";
const String connectionStateMessageReconnectingLabel =
    "Tentative de reconnexion";
const String connectionStateMessageDisconnectedLabel = "XSens DOT déconnecté";

// widgets/layout/athlete_view/capture_tab
const String noCaptureInfo = "Aucune capture n'a été faite sur ce profil.";

// widgets/layout/athlete_view/progression_tab/progression_tab
const String succeededJumpsGraphicTitle = "Score moyen par saut dans le temps";
const String percentageJumpsSucceededGraphicTitle =
    "Pourcentage de sauts réussis dans le temps";
const String percentageJumpsSucceededLegend = "% Sauts réussis";
const String averageJumpDurationGraphicTitle =
    "Durée moyenne de vol dans le temps";
const String averageFlyTimeLegend = "Temps de vol moyen (ms)";
const String notBeforeInfo = "Ne peut pas être avant la date de début.";
const String notAfterInfo = "Ne peut pas être après la date de fin.";
const String filterByDateDialogTitle = "Filtrer par date";

// widgets/layout/athlete_view/progression_tab/metrics_tooltip
const String averageTooltip = "Moyenne";
const String minTooltip = "Min";
const String maxTooltip = "Max";
const String stdDevTooltip = "Écart-type";

// widgets/layout/athlete_view/progression_tab/date_filter_dialog_content
const String beginDateButton = "Date de début";
const String endDateButton = "Date de fin";

// widgets/layout/options_tab/options_tab
const String confirmAthleteRemovalButton = "Confirmer le retrait";
const String removeThisAthleteButton = "Enlever cet athlète";
const String noOptionsAvailableInfo =
    "Aucune option disponible pour le moment.";

// widgets/layout/dot_connected
const String myDevicesTitle = "Mes appareils";
const String knownDevicesNearTitle = "Appareils connus à proximité";
const String connectedDeviceTitle = "Appareil connecté";

// widgets/layout/no_dot_connected
const String noConnectionInfo =
    "Zut! il semblerait que vous n'ayez pas encore associé un appareil XSens DOT. Tapoter le bouton ci-dessous pour commencer.";

// widgets/layout/ice_drawer_menu
const String rawDataDrawerTile = "Données brutes";
const String addSkaterDrawerTile = "Ajouter un patineur";
const String manageDevicesDrawerTile = "Gérer les XSens DOT";
const String myAcquisitionsTitle = "Mes acquisitions";
const String disconnectLabel = "Voulez-vous vraiment vous déconnecter?";
const String myAthletesTitle = "Mes athlètes";

// widgets/layout/configure_x_sens_dot_dialog
const String forgetDeviceButton = "Oublier";
const String disconnectDeviceButton = "Déconnecter";
const String connectDeviceButton = "Connecter";

// widgets/layout/edit_analysis_view/jump_panel_header
const String jumpTypeLabel = "Type";
const String savedModificationsSnackInfo = "Modification enregistrée!";

// widgets/layout/edit_analysis_view/jump_panel_content
const String deleteAJumpButton = "Supprimer le saut";
const String confirmDeleteInfo =
    "Cette action est irréversible, voulez-vous continuer?";
const String deleteJumpDialogTitle = "Suppression d'un saut";
const String commentDialogTitle = "Voir ou modifier un commentaire";
const String howToCommentInfo =
    "Vous pouvez ici inscrire un commentaire personnalisé sur le saut.";
const String editTemporalValuesButton = "Métriques avancées";
const String rotationDegreesField = "Degrés ";
const String metricsDialogTitle = "Voir ou modifier les métriques avancées";
const String advancedMetricsPromptInfo =
    "La modification de ces données ne devrait être faite que si vous êtes certains de ce que vous faites.";
const String irreversibleDataModificationInfo =
    "Les données précédentes seront perdues lors de l'enregistrement.";
const String turnsField = "Nombre de tours: ";
const String scoreField = "Score";
const String durationField = "Durée";
const String startTimeField = "Début";
const String maxSpeedLabel = "Vitesse atteinte";
const String timeToMaxSpeedLabel = "Temps avant vitesse max.";
const String reorderJumpListButton = "Réordonner la liste";
const String fallComment = "Chute";
const String notEnoughRotationComment = "Manque de rotation";
const String goodJobComment = "Bien fait";
const String stepOutComment = "Step out";
const String chooseBelowCommentsLabel =
    "Ou choisir parmi les commentaires suivants:";
const String continueModifOfAllJumpsInfo =
    "Cette action changera le type de tous les sauts.";

// widgets/screens/connection_dot_view
const String managingXSensDotTitle = "Gestion des XSens DOT";
const String connectNewXSensDotButton = "Connecter un nouvel appareil XSens DOT";
const String noDataLabel = "Aucune donnée n'a été collectée";
const String dataChartTitle = "Accélération";
const String firstFastLineName = "X";
const String secondFastLineName = "Y";
const String lastFastLineName = "Z";

// widgets/screens/profile_view
const String profileTitle = "Compte";
const String modifyPasswordButton = "Modifier le mot de passe";
const String listCoachesTitle = "Liste de mes entraineurs";
const String noCoachesInfo = "Aucun entraineur ne peut voir votre profil.";

// widgets/screens/raw_data_view
const String rawDataTitle = "Données brutes XSens DOT";
const String warnRawDataPromptInfo =
    "Cette page n'a pas pour but de fournir des données compréhensibles. Avant tout, elle vise à permettre de constater les données en temps réel de l'appareil connecté à des fins de recherche ou de débogage.";

// widgets/screens/login_view
const String loginTitle = "Connexion";
const String connectionButton = "Connexion";
const String connectingButton = "Connexion...";
const String connectionImpossibleLabel = "Connexion impossible";
const String createAccountButton = "Créer un compte";
const String forgotPasswordButton = "Mot de passe oublié?";
const String dataMessageInfo =
    "L'utilisation de cette application est destinée aux athlètes de Patinage Québec et aux personnes autorisées par Patinage Québec. En utilisant cette application, vous consentez aux différentes politiques de Patinage Québec, notamment concernant la rétention des informations reliées à votre compte. Les détails peuvent être obtenus auprès de Patinage Québec et sont inhérents à votre affiliation avec Patinage Québec.";

// widgets/screens/forgot_password_view
const String forgotPasswordTitle = "Mot de passe oublié";
const String forgotPasswordInfo =
    "Si ce courriel existe, vous recevrez un email dans un court délai.";
const String sendEmailButton = "Envoyer un courriel";

// widgets/screens/acquisitions_view
const String capturesTab = "Captures";
const String progressionTab = "Progression";
const String optionsTab = "Options";

// widgets/screens/list_athletes_view
const String listAthletesTitle = "Mes athlètes";
const String noAthletesInfo =
    "Vous n'avez pas d'athlètes dans votre liste.\n\nAppuyer sur le bouton en bas pour ajouter un athlète.";

// widgets/screens/athletes_view
const String captureButton = "Capturer";

// widgets/screens/edit_analysis_view
const String seeVideoAgainButton = "Revoir la vidéo";
const String detectedJumpsTitle = "Sauts enregistrés";
const String editAnalysisPageTitle = "Analyse";
const String analysisDoneInfo =
    "L'analyse est terminée. Vous pouvez catégoriser les sauts et donner des rétroactions au besoin.";
const String addAJumpButton = "Ajouter un saut";
const String noJumpInfo = "Aucun saut n'a été détecté dans cette capture.";

// widgets/screens/capture_view
const String savingToMemoryLabel = "Sauvegarde en mémoire";
const String captureViewStartLabel = "Commencer une capture";
const String selectSeasonLabel = "Choisir la saison";
const String captureViewInfo =
    "Cette page permet de commencer une capture pour l’athlète sélectionné.";
const String captureViewCameraInfo =
    "Une capture sans caméra se contente de communiquer avec le XSens Dot sans prise vidéo.";
const String captureViewCameraSwitchLabel = "Caméra activée ?";
const String stopCaptureButton = "Arrêter la capture";
const String exportingDataLabel = "Enregistrement des données...";
const String analyzingDataLabel = "Analyse des données...";
const String missingPermsCameraInfo =
    "Les permissions de la caméra sont désactivées";

// widgets/screens/coach_account_creation_view
const String coachCreateAccountTitle = "Créer un compte";
const String ifNotAnAthleteInfo =
    "Si vous êtes un athlète, vous devez demander à votre entraîneur de vous créer un compte.";
const String pleaseFillField = "Veuillez remplir ce champ.";
const String reduceCharacterLabel =
    "Réduire le nombre de caractères (max 255).";
const String surnameField = "Prénom";
const String nameField = "Nom";
const String passwordLabel = "Mot de passe";
const String passConfirmSameLabel = "Confirmation mot de passe";
const String emailField = "Adresse courriel";
const String invalidDigitFormatLabel = "Format de nombre incorrect.";
const String invalidEmailFormatLabel =
    'L\'adresse courriel n\'est pas de format valide.';
const String alreadyHaveAccountButton = "J'ai déjà un compte";
const String addCharactersLabel =
    "Le mot de passe doit comporter au moins 10 caractères.";
const String passwordMismatchLabel = "Les mots de passe sont différents.";
const String confirmCreateCoachAccountButton = "Créer le compte";
const String accountCreationErrorLabel = "Erreur de création de compte";
const String tryLaterLabel = 'Veuillez réessayer plus tard.';

// widgets/screens/missing_permissions_view
const String pleaseActivatePermissionsInfo =
    "Veuillez activer les permissions dans vos paramètres, puis redémarrer l'application. Si cela ne fonctionne pas, veuillez réinstaller l'application.";
const String architectureNotPermittedInfo =
    "L'architecture de votre appareil n'est pas compatible avec les requis du XSens Dot et l'application ne pourra pas fonctionner.";
const String architectureUntrusted =
    "L'architecture de votre appareil pourrait ne pas être compatible avec les requis du XSens Dot et des plantages imprévus pourraient survenir.";
const String bypassButton = "Continuer malgré le risque.";
const String pleaseActivateNetworkInfo =
    "Veuillez activer les données mobiles ou le Wi-Fi dans vos paramètres, puis redémarrer l'application.";

// widgets/screens/skater_creation_view
const String createAthleteExplainInfo =
    "L'athlète devra lui-même confirmer son courriel puis pourra choisir son mot de passe à la première connexion. Il sera ensuite disponible dans votre liste d'athlètes.";
const String addASkaterTitle = "Ajouter un patineur";
const String warnAccountTypeChangeInfo =
    "Ajouter un patineur convertira votre compte en compte entraîneur.";
const String athleteAlreadyExistsInfo =
    "Cet athlète existe déjà; il a été ajouté à votre liste d'athlètes!";
const String athleteAlreadyInListInfo = "Cet athète est déjà dans votre liste.";

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
