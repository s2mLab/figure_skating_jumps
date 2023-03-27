const int maxScore = 5;
const int minScore = -5;
List<int> jumpScores = List.generate(1 + maxScore - minScore, (index) => maxScore - index);