import 'package:figure_skating_jumps/constants/lang_fr.dart';

/// This enum represents the different season types in figure skating.
enum Season {
  preparation(preparationSeasonLabel),
  competition(competitionSeasonLabel),
  transition(transitionSeasonLabel),
  sharpening(sharpeningSeasonLabel);

  final String displayedString;
  const Season(this.displayedString);
}
