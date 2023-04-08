import 'package:figure_skating_jumps/interfaces/i_local_db_manager.dart';
import 'package:figure_skating_jumps/models/db_models/active_session.dart';
import 'package:figure_skating_jumps/services/local_db_service.dart';
import 'package:flutter/cupertino.dart';

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

  Future<void> saveActiveSession(String email, String password) async {
    if (ActiveSessionManager().activeSession != null && ActiveSessionManager().activeSession!.email == email) return;
    _activeSession = ActiveSession(id: 1, email: email, password: password);
    bool alreadyExists = await LocalDbService()
        .updateOne(_activeSession!, LocalDbService.activeSessionTableName);
    if (!alreadyExists) {
      await LocalDbService()
          .insertOne(_activeSession!, LocalDbService.activeSessionTableName);
    }
  }

  Future<void> loadActiveSession() async {
    List<ActiveSession> sessions = constructObject(await LocalDbService()
        .readWhere(LocalDbService.activeSessionTableName, 'id', '1'));
    if (sessions.isNotEmpty) _activeSession = sessions[0];
  }

  Future<void> clearActiveSession() async {
    if (_activeSession == null) return;
    _activeSession?.id = 1;
    await LocalDbService().deleteOne(_activeSession!, LocalDbService.activeSessionTableName);
  }

  Future<void> changeSessionPassword(String password) async {
    if (_activeSession == null) return;
    _activeSession = ActiveSession(id: 1, email: _activeSession!.email, password: password);
    await LocalDbService().updateOne(_activeSession!, LocalDbService.activeSessionTableName);
  }
}
