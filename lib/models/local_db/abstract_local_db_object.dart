abstract class AbstractLocalDbObject {
  int? id;

  /// Converts the object to a map that will be used to insert it into the database
  Map<String, dynamic> toMap();
}
