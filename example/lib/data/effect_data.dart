import 'package:example/effect/effect_info.dart';

/// 特效数据
class EffectData {
  static String iconPath = "assets/images/icon/effect/";
  static String texturePath = "assets/images/effect/";
  static String audioPath = "assets/audio/effect/";

  static Map<String, EffectInfo> items = {
    "1001": EffectInfo(1001, "普通攻击", EffectType.ATTACK,
        icon: icon(1001), frameSpeed: 10, vision: 40, damageRange: 80, delayTime: 10),
    "1002": EffectInfo(1002, "初级剑法", EffectType.ATTACK,
        texture: texture(1002),
        icon: icon(1002),
        at: 1.2,
        mt: 1.2,
        frameSpeed: 10,
        vision: 40,
        damageRange: 80,
        delayTime: 10),
    "2001": EffectInfo(2001, "火球术", EffectType.TRACK,
        texture: texture(2001),
        icon: icon(2001),
        at: 1.2,
        mt: 1.2,
        frameSpeed: 10,
        moveSpeed: 10,
        vision: 120,
        damageRange: 50,
        delayTime: 400),

    "3001": EffectInfo(3001, "火符术", EffectType.TRACK,
        texture: texture(3001),
        icon: icon(3001),
        at: 1.2,
        mt: 1.2,
        frameSpeed: 10,
        moveSpeed: 10,
        vision: 120,
        damageRange: 50,
        delayTime: 400),

    "3002": EffectInfo(3002, "施毒术", EffectType.CASTING,
        texture: texture(3002),
        icon: icon(3002),
        at: 1.2,
        mt: 1.2,
        frameSpeed: 10,
        moveSpeed: 10,
        vision: 120,
        damageRange: 50,
        delayTime: 400),
  };

  static String icon(int id) {
    return iconPath + id.toString() + ".png";
  }

  static String texture(int id) {
    return texturePath + id.toString() + ".json";
  }

  static String audio(int id) {
    return audioPath + id.toString() + ".mp3";
  }
}
