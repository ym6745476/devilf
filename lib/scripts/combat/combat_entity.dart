import 'package:flame/components.dart';
import 'skill.dart';

class CombatEntity extends Component {
  double maxHealth;
  double currentHealth;
  double maxMana;
  double currentMana;
  double attackPower;
  double defense;
  List<Skill> skills;
  Vector2 position;
  bool isAlive = true;

  CombatEntity({
    required this.maxHealth,
    required this.maxMana,
    required this.attackPower,
    required this.defense,
    required this.position,
    List<Skill>? skills,
  }) : 
    currentHealth = maxHealth,
    currentMana = maxMana,
    skills = skills ?? [];

  double get health => currentHealth;
  double get mana => currentMana;

  void takeDamage(double amount) {
    double actualDamage = (amount - defense).clamp(1, double.infinity);
    currentHealth = (currentHealth - actualDamage).clamp(0, maxHealth);
    if (currentHealth <= 0) {
      isAlive = false;
    }
  }

  void heal(double amount) {
    currentHealth = (currentHealth + amount).clamp(0, maxHealth);
  }

  void useMana(double amount) {
    currentMana = (currentMana - amount).clamp(0, maxMana);
  }

  void restoreMana(double amount) {
    currentMana = (currentMana + amount).clamp(0, maxMana);
  }

  bool canUseSkill(Skill skill) {
    return currentMana >= skill.manaCost && skill.isReady;
  }
}
