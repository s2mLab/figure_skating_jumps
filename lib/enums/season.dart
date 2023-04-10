import '../constants/lang_fr.dart';

enum Season {
  preparation(preparationSeasonLabel),
  competition(competitionSeason),
  transition(transitionSeason),
  sharpening(sharpeningSeason);

  final String displayedString;
  const Season(this.displayedString);
}
