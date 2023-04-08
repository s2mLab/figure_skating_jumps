import 'abstract_local_db_object.dart';

class ActiveSession extends AbstractLocalDbObject {
  final String _email;
  final String _password;

  ActiveSession({id, required String email, required String password})
      : _email = email,
        _password = password {
    this.id = id;
  }

  get email {
    return _email;
  }

  get password {
    return _password;
  }

  @override
  Map<String, dynamic> toMap() {
    return {'email': _email, 'password': _password};
  }

  @override
  String toString() {
    return 'ActiveSession{id: $id, email: $_email}';
  }
}
