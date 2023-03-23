abstract class AbstractLocalDbObject {
  int? _id;

  int? get id => _id;

  set id(int? value) {
    _id = id;
  }

  Map<String, dynamic> toMap();
}
