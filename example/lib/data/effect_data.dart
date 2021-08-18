import 'package:example/effect/effect_info.dart';

/// 特效数据
class EffectData {
  static String iconPath = "assets/images/icon/effect/";
  static String texturePath = "assets/images/effect/";

  /// 默认前缀 assets/audio/
  static String audioPath = "effect/";

  static Map<String, EffectInfo> items = {
    "1001": EffectInfo(1001, "普通攻击", EffectType.ATTACK,
        icon: getIcon(1001), audio: getAudio(1001), frameSpeed: 10, vision: 40, damageRange: 60, delayTime: 10),
    "1002": EffectInfo(1002, "初级剑法", EffectType.ATTACK,
        texture: getTexture(1002),
        icon: getIcon(1002),
        audio: getAudio(1002),
        at: 1.2,
        mt: 1.2,
        frameSpeed: 10,
        vision: 40,
        damageRange: 60,
        delayTime: 10),
    "2001": EffectInfo(
      2001,
      "火球术",
      EffectType.TRACK,
      texture: getTexture(2001),
      icon: getIcon(2001),
      audio: getAudio(2001),
      at: 1.2,
      mt: 1.2,
      frameSpeed: 10,
      moveSpeed: 6,
      vision: 120,
      damageRange: 50,
      delayTime: 400,
      destroyTime: 400,
    ),
    "3001": EffectInfo(
      3001,
      "火符术",
      EffectType.TRACK,
      texture: getTexture(3001),
      icon: getIcon(3001),
      audio: getAudio(3001),
      at: 1.2,
      mt: 1.2,
      frameSpeed: 10,
      moveSpeed: 6,
      vision: 120,
      damageRange: 50,
      delayTime: 400,
      destroyTime: 400,
    ),
    "3002": EffectInfo(
      3002,
      "施毒术",
      EffectType.CASTING,
      texture: getTexture(3002),
      icon: getIcon(3002),
      audio: getAudio(3002),
      at: 1.2,
      mt: 1.2,
      frameSpeed: 10,
      moveSpeed: 6,
      vision: 120,
      damageRange: 50,
      delayTime: 400,
      destroyTime: 400,
    ),
    "4001": EffectInfo(4001, "怪物攻击", EffectType.ATTACK,
        audio: getAudio(4001), frameSpeed: 10, vision: 40, damageRange: 80, delayTime: 10),
  };

  static String getIcon(int id) {
    return iconPath + id.toString() + ".png";
  }

  static String getTexture(int id) {
    return texturePath + id.toString() + ".json";
  }

  static String getAudio(int id) {
    return audioPath + id.toString() + ".mp3";
  }
}
