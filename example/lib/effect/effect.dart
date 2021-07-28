/// 特效类
class Effect {

  /// 特效名字
  String name = "";

  /// 最小攻击力
  double minAt = 10;

  /// 最大攻击力
  double maxAt = 100;

  /// 移动速度
  double moveSpeed = 3;

  /// 可见范围
  double vision = 300;

  /// 伤害范围
  double damageRange = 100;

  /// 特效类型
  EffectType type = EffectType.NONE;

  /// 是否死亡
  bool isDead = false;

}

/// 特效类型
enum EffectType {
  NONE,      /// 无
  ATTACK,    /// 前方攻击
  TRACK,     /// 弹道爆炸
  SURROUND,  /// 环绕自己
  AROUND,    /// 目标周围

}
