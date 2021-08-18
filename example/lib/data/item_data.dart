import 'package:example/model/item_info.dart';

/// 物品数据
class ItemData {
  static String clothesPath = "assets/images/clothes/";
  static String weaponPath = "assets/images/weapon/";
  static String iconPath = "assets/images/icon/item/";

  /// 基本配置
  static Map<String, ItemInfo> items = {
    "1000": ItemInfo(1000, "木剑", icon:getIcon("1000"),texture: getWeapon("1000"),type: ItemType.WEAPON),
    "1001": ItemInfo(1001, "修罗战斧", icon: getIcon("1001"),texture: getWeapon("1001"),type: ItemType.WEAPON),
    "2001": ItemInfo(1001, "偃月刀", icon: getIcon("2001"),texture: getWeapon("2001"),type: ItemType.WEAPON),
    "3001": ItemInfo(1001, "降魔剑", icon: getIcon("3001"),texture: getWeapon("3001"),type: ItemType.WEAPON),

    "1100": ItemInfo(10000, "布衣", icon: getIcon("1100"),texture: getClothes("1100"),type: ItemType.CLOTHES),
    "1101": ItemInfo(10001, "轻盔", icon: getIcon("1101"),texture: getClothes("1101"),type: ItemType.CLOTHES),
    "1102": ItemInfo(10002, "中盔", icon: getIcon("1102"),texture: getClothes("1102"),type: ItemType.CLOTHES),
    "1103": ItemInfo(10003, "金鹏宝甲", icon: getIcon("1103"),texture: getClothes("1103"),type: ItemType.CLOTHES),
    "1104": ItemInfo(11004, "重盔", icon: getIcon("1104"),texture: getClothes("1104"),type: ItemType.CLOTHES),
    "2104": ItemInfo(21005, "魔袍", icon: getIcon("2104"),texture: getClothes("2104"),type: ItemType.CLOTHES),
    "3104": ItemInfo(31006, "灵魂战甲", icon: getIcon("3104"),texture: getClothes("3104"),type: ItemType.CLOTHES),

    "1200": ItemInfo(10000, "布衣", icon: getIcon("1200"),texture: getClothes("1200"),type: ItemType.CLOTHES),
    "1201": ItemInfo(10001, "轻盔", icon: getIcon("1201"),texture: getClothes("1201"),type: ItemType.CLOTHES),
    "1202": ItemInfo(10002, "中盔", icon: getIcon("1202"),texture: getClothes("1202"),type: ItemType.CLOTHES),
    "1203": ItemInfo(10003, "金鹏宝甲", icon: getIcon("1203"),texture: getClothes("1203"),type: ItemType.CLOTHES),
    "1204": ItemInfo(11004, "重盔", icon: getIcon("1204"),texture: getClothes("1204"),type: ItemType.CLOTHES),
    "2204": ItemInfo(21005, "魔袍", icon: getIcon("2204"),texture: getClothes("2204"),type: ItemType.CLOTHES),
    "3204": ItemInfo(31006, "灵魂战甲", icon: getIcon("3204"),texture: getClothes("3204"),type: ItemType.CLOTHES),
  };

  /// 创建怪物
  static ItemInfo newItemInfo(String id) {
    ItemInfo template = items[id]!;
    return ItemInfo(
      template.id,
      template.name,
      icon:template.icon,
      texture:template.texture,
      type:template.type,
    );
  }

  static String getIcon(String name) {
    return iconPath + name + ".png";
  }

  static String getClothes(String name) {
    return clothesPath + name + ".json";
  }

  static String getWeapon(String name) {
    return weaponPath + name + ".json";
  }
}
