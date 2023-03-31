enum HelperSubject {
  connectDot(
      "Connecter un senseur",
      "Pour connecter un XSens Dot, assurez-vous que la batterie est pleine, cliquez sur la barre de statu du senseur ou le bouton suivant.\n\nVous Pourrez ainsi connecter un XSens Dot déjà enregistrer ou un nouveau avec le bouton au bas de la page.",
      "/ManageDevices"),
  addSkater(
      "Ajouter un patineur",
      "Vous pouvez ajouter un athlète à votre liste avec le courriel du compte athlète.\n\nDans le cas où un athlète n'a pas de compte, l'entraineur doit créer un compte pour celui-ci. Lors de la première connexion de l'athlète, celui-ci pourra réinitialiser son mot de passe.",
      "/CreateSkater"),
  skaterInfo(
      "Qui a accès à mes informations",
      "Vous pouvez voir la liste des entraineurs en consultant votre profil avec le bouton suivant.\n\nCes entraineurs peuvent consulter les captures et les rétroactions de chaque acquisition faite. Cependant, les vidéos ne sont accessible que sur l'appareil utilisé.",
      "/ProfileView"),
  modificationInfo(
      "Modifier mes informations",
      "En cliquant sur le bouton suivant, vous accèderez à votre profil. Vous pourrez ainsi modifier votre nom, prénom et mot de passe.",
      "/ProfileView"),
  newAcquisition(
      "Prendre une nouvelle capture",
      "Afin de prendre une nouvelle capture, il suffit de cliquer sur le bouton \"Capturer\" de la liste des captures. Si le support vidéo n'est pas activé, il est possible de l'activer dans les paramètres du téléphone dans les permissions d'application.",
      null);

  const HelperSubject(this.title, this.description, this.direction);

  final String title;
  final String description;
  final String? direction;
}
