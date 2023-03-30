import 'package:collection/collection.dart';

import '../enums/jump_type.dart';
import '../models/capture.dart';
import '../models/jump.dart';

class GraphicDataHelper {

  static List<String> getAllDates(Map<String, List<Capture>> captures) {
    return captures.keys.toList();
  }

  static double getAverageJumpScorePerTypeOnDate(Map<String, List<Capture>> captures, String day, JumpType type) {
    if(captures[day] == null) {
      throw ArgumentError('captures at date was null');
    }
    List<Capture> capturesOnDate = captures[day]!;
    List<Jump> jumpsOfType = [];
    List<int> scoresOfJumps = [];
    for (Capture c in capturesOnDate) {
      jumpsOfType.addAll(c.jumps.where((jump) => jump.type==type));
    }
    for(Jump j in jumpsOfType) {
      scoresOfJumps.add(j.score);
    }
    return scoresOfJumps.average;
  }
}