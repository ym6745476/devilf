/// 特效类
class EffectInfo {
  /// 特效ID
  int id;

  /// 特效名字
  String name;

  /// 图标
  String? icon;

  /// 纹理
  String? texture;

  /// 音效
  String? audio;

  /// 物理攻击力百分比
  double at;

  /// 魔法攻击力百分比
  double mt;

  /// 移动速度
  double moveSpeed;

  /// 帧速度 每秒5帧
  double frameSpeed;

  /// 可见范围
  double vision;

  /// 伤害范围
  double damageRange;

  /// 销毁时间
  int destroyTime;

  /// 释放延迟
  int delayTime;

  /// 特效类型
  EffectType type;

  /// 模板
  String template;

  /// 创建特效
  EffectInfo(
    this.id, {
    this.template = "",
    this.name = "",
    this.icon,
    this.texture,
    this.audio,
    this.at = 1,
    this.mt = 1,
    this.moveSpeed = 0,
    this.frameSpeed = 5,
    this.vision = 0,
    this.delayTime = 0,
    this.destroyTime = 400,
    this.damageRange = 0,
    this.type = EffectType.NONE,
  });
}

/// 特效类型
enum EffectType {
  /// 无
  NONE,

  /// 攻击 (五方向)
  ATTACK,

  /// 弹道->爆炸 (弹道 右方向,爆炸 上方向)
  TRACK,

  /// 施法->爆炸 (施法 上方向,爆炸 上方向)
  CASTING,
}
