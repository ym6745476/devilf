import 'package:example/effect/effect_info.dart';

/// 特效数据
class EffectData {
  static String iconPath = "assets/images/icon/effect/";
  static String texturePath = "assets/images/effect/";

  /// 默认前缀 assets/audio/
  static String audioPath = "effect/";

  /// 数据
  static List<EffectInfo> items = [
    EffectInfo(1001,
        template: "1001",
        name: "普通攻击",
        type: EffectType.ATTACK,
        frameSpeed: 10,
        vision: 40,
        damageRange: 60,
        delayTime: 10),
    EffectInfo(1002,
        template: "1002",
        name: "初级剑法",
        type: EffectType.ATTACK,
        at: 1.2,
        mt: 1.2,
        frameSpeed: 10,
        vision: 40,
        damageRange: 60,
        delayTime: 10),
    EffectInfo(
      2001,
      template: "2001",
      name: "火球术",
      type: EffectType.TRACK,
      at: 1.2,
      mt: 1.2,
      frameSpeed: 10,
      moveSpeed: 6,
      vision: 120,
      damageRange: 50,
      delayTime: 400,
      destroyTime: 400,
    ),
    EffectInfo(
      3001,
      template: "3001",
      name: "火符术",
      type: EffectType.TRACK,
      at: 1.2,
      mt: 1.2,
      frameSpeed: 10,
      moveSpeed: 6,
      vision: 120,
      damageRange: 50,
      delayTime: 400,
      destroyTime: 400,
    ),
    EffectInfo(
      3002,
      template: "3001",
      name: "施毒术",
      type: EffectType.CASTING,
      at: 1.2,
      mt: 1.2,
      frameSpeed: 10,
      moveSpeed: 6,
      vision: 120,
      damageRange: 50,
      delayTime: 400,
      destroyTime: 400,
    ),
    EffectInfo(4001,
        template: "4001",
        name: "怪物攻击",
        type: EffectType.ATTACK,
        frameSpeed: 10,
        vision: 40,
        damageRange: 80,
        delayTime: 10),
  ];

  /// 创建特效
  static EffectInfo newEffectInfo({required String template}) {
    EffectInfo? effectInfo;
    for (EffectInfo item in items) {
      if (item.template == template) {
        String? texture;
        if (template != "1001" && template != "4001") {
          texture = getTexture(template);
        }
        effectInfo = EffectInfo(
          item.id,
          name: item.name,
          icon: getIcon(template),
          audio: getAudio(template),
          texture: texture,
          type: item.type,
          template: item.template,
          frameSpeed: item.frameSpeed,
          moveSpeed: item.moveSpeed,
          vision: item.vision,
          damageRange: item.damageRange,
          delayTime: item.delayTime,
        );
        break;
      }
    }
    if(effectInfo == null){
      print("获取特效错误，检查模板ID是否正确: " + template.toString());
    }
    return effectInfo!;
  }

  static String getIcon(String name) {
    return iconPath + name + ".png";
  }

  static String getTexture(String name) {
    return texturePath + name + ".json";
  }

  static String getAudio(String name) {
    return audioPath + name + ".mp3";
  }
}
