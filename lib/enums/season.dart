import 'package:figure_skating_jumps/constants/lang_fr.dart';

enum Season {
  preparation(preparationSeason),
  competition(competitionSeason),
  transition(transitionSeason),
  sharpening(sharpeningSeason);

  final String displayedString;
  const Season(this.displayedString);
}
