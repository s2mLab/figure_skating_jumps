import '../constants/lang_fr.dart';

enum Season {
  preparation(preparationSeasonLabel),
  competition(competitionSeasonLabel),
  transition(transitionSeasonLabel),
  sharpening(sharpeningSeasonLabel);

  final String displayedString;
  const Season(this.displayedString);
}
