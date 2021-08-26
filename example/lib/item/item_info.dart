import 'package:example/data/item_data.dart';

/// 一件物品类
class ItemInfo {
  /// 物品ID
  int id;

  /// 物品名字
  String name;

  /// 图标
  String? icon;

  /// 纹理
  String? texture;

  /// 预览
  String? show;

  /// 物品类型
  String type;

  /// 生命值
  int hp;

  /// 魔法值
  int mp;

  /// 最小攻击力
  int minAt;

  /// 最大攻击力
  int maxAt;

  /// 最小魔法攻击力
  int minMt;

  /// 最大魔法攻击力
  int maxMt;

  /// 最小物理防御
  int minDf;

  /// 最大物理防御
  int maxDf;

  /// 最小魔法防御
  int minMf;

  /// 最大魔法防御
  int maxMf;

  /// 是否穿戴
  bool isDressed;

  /// 模板
  String template;

  /// 创建物品
  ItemInfo(
    this.id, {
    this.template = "",
    this.name = "",
    this.type = ItemType.NONE,
    this.icon,
    this.texture,
    this.show,
    this.hp = 100,
    this.mp = 100,
    this.minAt = 0,
    this.maxAt = 5,
    this.minMt = 0,
    this.maxMt = 5,
    this.minDf = 0,
    this.maxDf = 5,
    this.minMf = 0,
    this.maxMf = 5,
    this.isDressed = false,
  });
}

/// 物品类型
class ItemType {
  static const String NONE = "NONE";
  static const String WEAPON = "WEAPON";
  static const String CLOTHES = "CLOTHES";
  static const String HELMET = "HELMET";
  static const String NECKLACE = "NECKLACE";
  static const String BRACELET = "BRACELET";
  static const String RING = "RING";
  static const String BELT = "BELT";
  static const String BOOTS = "BOOTS";
  static const String MEDAL = "MEDAL";
  static const String GEMSTONE = "GEMSTONE";
  static const String SKILL = "SKILL";
  static const String PET = "PET";

  static const Map<String, String> NAMES = {
    ItemType.NONE: "无",
    ItemType.WEAPON: "武器",
    ItemType.CLOTHES: "衣服",
    ItemType.HELMET: "头盔",
    ItemType.NECKLACE: "项链",
    ItemType.BRACELET: "手镯",
    ItemType.RING: "戒子",
    ItemType.BELT: "腰带",
    ItemType.BOOTS: "靴子",
    ItemType.MEDAL: "勋章",
    ItemType.GEMSTONE: "宝石",
    ItemType.SKILL: "特技",
    ItemType.PET: "宠物",
  };

  /// 物品类型名称
  static String getName(String type) {
    return NAMES[type]!;
  }
}
