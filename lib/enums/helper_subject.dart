import 'package:figure_skating_jumps/constants/lang_fr.dart';

/// This enum represents the different subject and description in the helper page.
enum HelperSubject {
  connectDot(connectDotTitle, connectDotDescription, "/ManageDevices"),
  addSkater(addSkaterTitle, addSkaterDescription, "/CreateSkater"),
  skaterInfo(skaterInfoTitle, skaterDescription, "/Profile"),
  modificationInfo(modificationInfoTitle, modificationDescription, "/Profile"),
  newAcquisition(newAcquisitionTitle, newAcquisitionDescription, null);

  const HelperSubject(this.title, this.description, this.direction);

  final String title;
  final String description;
  final String? direction;
}
