
enum SkillType {
  attack,
  heal,
  buff,
  debuff,
}

class Skill {
  final String id;
  final String name;
  final String description;
  final SkillType type;
  final double damage;
  final double healing;
  final double range;
  final double manaCost;
  final double cooldown;
  double _lastUsedTime = 0;

  Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.damage = 0,
    this.healing = 0,
    required this.range,
    required this.manaCost,
    required this.cooldown,
  });

  bool get isReady => _lastUsedTime <= 0;

  void use() {
    _lastUsedTime = cooldown;
  }

  void update(double dt) {
    if (_lastUsedTime > 0) {
      _lastUsedTime = (_lastUsedTime - dt).clamp(0, cooldown);
    }
  }

  double get remainingCooldown => _lastUsedTime;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString(),
      'damage': damage,
      'healing': healing,
      'range': range,
      'manaCost': manaCost,
      'cooldown': cooldown,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: SkillType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => SkillType.attack,
      ),
      damage: (json['damage'] ?? 0).toDouble(),
      healing: (json['healing'] ?? 0).toDouble(),
      range: (json['range'] ?? 1).toDouble(),
      manaCost: (json['manaCost'] ?? 0).toDouble(),
      cooldown: (json['cooldown'] ?? 1).toDouble(),
    );
  }

  // Predefined skills
  static Skill basicAttack() {
    return Skill(
      id: 'basic_attack',
      name: 'Basic Attack',
      description: 'A basic melee attack',
      type: SkillType.attack,
      damage: 10,
      range: 1.5,
      manaCost: 0,
      cooldown: 1,
    );
  }

  static Skill fireball() {
    return Skill(
      id: 'fireball',
      name: 'Fireball',
      description: 'Launches a ball of fire at the target',
      type: SkillType.attack,
      damage: 25,
      range: 5,
      manaCost: 15,
      cooldown: 3,
    );
  }

  static Skill heal() {
    return Skill(
      id: 'heal',
      name: 'Heal',
      description: 'Restores health to the target',
      type: SkillType.heal,
      healing: 20,
      range: 3,
      manaCost: 20,
      cooldown: 5,
    );
  }

  static Skill speedBuff() {
    return Skill(
      id: 'speed_buff',
      name: 'Speed Boost',
      description: 'Increases movement speed',
      type: SkillType.buff,
      range: 0,
      manaCost: 10,
      cooldown: 10,
    );
  }
}
