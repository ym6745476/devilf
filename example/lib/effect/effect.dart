/// 特效类
class Effect {

  /// 纹理
  String texture = "";

  /// 特效名字
  String name = "";

  /// 物理攻击力百分比
  double at = 1.2;

  /// 魔法攻击力百分比
  double mt = 1.2;

  /// 移动速度
  double moveSpeed = 10;

  /// 可见范围
  double vision = 300;

  /// 伤害范围
  double damageRange = 100;

  /// 释放延迟
  int delayTime = 100;

  /// 特效类型
  EffectType type = EffectType.NONE;

  /// 是否死亡
  bool isDead = false;

}

/// 特效类型
enum EffectType {
  NONE,      /// 无
  ATTACK,    /// 攻击 5方向
  TRACK,     /// 弹道 右方向 爆炸 上方向
  SURROUND,  /// 环绕 上方向

}
