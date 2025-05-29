class PvPMatch {
  final String id;
  final List<String> playerIds;
  final Map<String, int> scores;
  bool isActive;

  PvPMatch({
    required this.id,
    required this.playerIds,
    Map<String, int>? scores,
    this.isActive = true,
  }) : scores = scores ?? {for (var id in playerIds) id: 0};

  void updateScore(String playerId, int score) {
    if (scores.containsKey(playerId)) {
      scores[playerId] = score;
    }
  }

  void endMatch() {
    isActive = false;
  }
}

class PvPSystem {
  final Map<String, PvPMatch> _matches = {};

  void createMatch(String matchId, List<String> playerIds) {
    if (_matches.containsKey(matchId)) return;
    _matches[matchId] = PvPMatch(id: matchId, playerIds: playerIds);
  }

  void endMatch(String matchId) {
    final match = _matches[matchId];
    if (match != null) {
      match.endMatch();
    }
  }

  PvPMatch? getMatch(String matchId) {
    return _matches[matchId];
  }

  List<PvPMatch> getActiveMatches() {
    return _matches.values.where((m) => m.isActive).toList();
  }
}
