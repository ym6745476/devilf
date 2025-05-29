class VIPRank {
  final int level;
  final String name;
  final Map<String, dynamic> perks;

  VIPRank({
    required this.level,
    required this.name,
    required this.perks,
  });
}

class VIPSystem {
  final List<VIPRank> ranks = [
    VIPRank(level: 1, name: 'Bronze', perks: {'expMultiplier': 1.1, 'speedBonus': 0.05}),
    VIPRank(level: 2, name: 'Silver', perks: {'expMultiplier': 1.2, 'speedBonus': 0.1}),
    VIPRank(level: 3, name: 'Gold', perks: {'expMultiplier': 1.3, 'speedBonus': 0.15}),
    VIPRank(level: 4, name: 'Platinum', perks: {'expMultiplier': 1.5, 'speedBonus': 0.2}),
  ];

  int currentLevel = 0;

  VIPRank? get currentRank {
    if (currentLevel <= 0 || currentLevel > ranks.length) return null;
    return ranks[currentLevel - 1];
  }

  void upgradeVIP() {
    if (currentLevel < ranks.length) {
      currentLevel++;
    }
  }

  double get expMultiplier => currentRank?.perks['expMultiplier'] ?? 1.0;
  double get speedBonus => currentRank?.perks['speedBonus'] ?? 0.0;
}
