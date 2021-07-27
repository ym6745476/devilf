/// 怪物类
class Monster {
  /// 生命值
  double hp = 100;

  /// 魔法值
  double mp = 100;

  /// 最大生命值
  double maxHp = 100;

  /// 最大魔法值
  double maxMp = 100;

  /// 最小攻击力
  double minAt = 10;

  /// 最大攻击力
  double maxAt = 100;

  /// 移动速度
  double moveSpeed = 0.4;

  /// 视野范围
  double vision = 512;

  /// 是否死亡
  bool isDead = false;

  /// 动作间隔
  double actionStepTime = 1000;

  /// 复活间隔
  double rebornTime = 3000;
}
