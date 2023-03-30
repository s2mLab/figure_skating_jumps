enum HelperSubject {
  connectDot("Comment connecter un senseur", "Description 1", "/ManageDevices"),
  addSkater("Comment ajouter un patineur", "Description 2", "/CreateSkater"),
  random("Comment vivre", "Description", null);

  const HelperSubject(this.title, this.description, this.direction);

  final String title;
  final String description;
  final String? direction;
}
