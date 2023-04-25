import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/local_db/active_session.dart';
import 'package:figure_skating_jumps/services/local_db/local_db_service.dart';

class ActiveSessionManager implements ILocalDbManager<ActiveSession> {
  static ActiveSession? _activeSession;
  static final ActiveSessionManager _activeSessionManager =
      ActiveSessionManager._internal();

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory ActiveSessionManager() {
    return _activeSessionManager;
  }

  ActiveSessionManager._internal();

  @override
  List<ActiveSession> constructObject(List<Map<String, dynamic>> objMaps) {
    return List.generate(objMaps.length, (i) {
      return ActiveSession(
          id: objMaps[i]['id'],
          email: objMaps[i]['email'],
          password: objMaps[i]['password']);
    });
  }

  ActiveSession? get activeSession {
    return _activeSession;
  }

  /// Saves the active session to the local database, unless there is already an active session with the same email.
  ///
  /// Parameters:
  /// - [email] : the email of the user associated with the active session.
  /// - [password] : the password of the user associated with the active session.
  ///
  /// Returns void.
  Future<void> saveActiveSession(String email, String password) async {
    if (ActiveSessionManager().activeSession != null &&
        ActiveSessionManager().activeSession!.email == email) return;
    _activeSession = ActiveSession(id: 1, email: email, password: password);
    bool alreadyExists = await LocalDbService()
        .updateOne(_activeSession!, LocalDbService.activeSessionTableName);
    if (!alreadyExists) {
      await LocalDbService()
          .insertOne(_activeSession!, LocalDbService.activeSessionTableName);
    }
  }

  /// Loads the active session into the singleton.
  ///
  /// Returns void.
  Future<void> loadActiveSession() async {
    List<ActiveSession> sessions = constructObject(await LocalDbService()
        .readWhere(LocalDbService.activeSessionTableName, 'id', '1'));
    if (sessions.isNotEmpty) _activeSession = sessions[0];
  }

  /// Clears the active session from the local database and from the singleton.
  ///
  /// Returns void.
  Future<void> clearActiveSession() async {
    if (_activeSession == null) return;
    _activeSession!.id = 1;
    await LocalDbService()
        .deleteOne(_activeSession!, LocalDbService.activeSessionTableName);
    _activeSession = null;
  }

  /// Changes the active session password.
  ///
  /// Parameters:
  /// - [password] : the new password.
  ///
  /// Returns void.
  Future<void> changeSessionPassword(String password) async {
    if (_activeSession == null) return;
    _activeSession =
        ActiveSession(id: 1, email: _activeSession!.email, password: password);
    await LocalDbService()
        .updateOne(_activeSession!, LocalDbService.activeSessionTableName);
  }
}
