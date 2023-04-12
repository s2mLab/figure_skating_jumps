import 'package:figure_skating_jumps/constants/lang_fr.dart';

enum HelperSubject {
  connectDot(connectDotTitle, connectDotDescription, "/ManageDevices"),
  addSkater(addSkaterTitle, addSkaterDescription, "/CreateSkater"),
  skaterInfo(skaterInfoTitle, skaterDescription, "/ProfileView"),
  modificationInfo(
      modificationInfoTitle, modificationDescription, "/ProfileView"),
  newAcquisition(newAcquisitionTitle, newAcquisitionDescription, null);

  const HelperSubject(this.title, this.description, this.direction);

  final String title;
  final String description;
  final String? direction;
}
