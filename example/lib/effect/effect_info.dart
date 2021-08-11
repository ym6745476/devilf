/// 特效类
class EffectInfo {
  /// 纹理
  String? texture;

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
}

/// 特效类型
enum EffectType {
  /// 无
  NONE,

  /// 攻击 5方向
  ATTACK,

  /// 弹道 右方向 爆炸 上方向
  TRACK,

  /// 环绕 上方向
  SURROUND,
}
