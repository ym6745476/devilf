import 'package:example/item/item_info.dart';

/// 物品数据
class ItemData {
  static String showPath = "assets/images/show/";
  static String clothesPath = "assets/images/clothes/";
  static String weaponPath = "assets/images/weapon/";
  static String iconPath = "assets/images/icon/item/";
  static int uniqueId = 0;

  /// 数据
  static List<ItemInfo> items = [
    ItemInfo(0, template: "1000", name: "木剑", type: ItemType.WEAPON),
    ItemInfo(0, template: "1001", name: "修罗战斧", type: ItemType.WEAPON),
    ItemInfo(0, template: "2001", name: "偃月刀", type: ItemType.WEAPON),
    ItemInfo(0, template: "3001", name: "降魔剑", type: ItemType.WEAPON),
    ItemInfo(0, template: "1100", name: "布衣", type: ItemType.CLOTHES),
    ItemInfo(0, template: "1101", name: "轻盔", type: ItemType.CLOTHES),
    ItemInfo(0, template: "1102", name: "中盔", type: ItemType.CLOTHES),
    ItemInfo(0, template: "1103", name: "金鹏宝甲", type: ItemType.CLOTHES),
    ItemInfo(0, template: "1104", name: "重盔", type: ItemType.CLOTHES),
    ItemInfo(0, template: "2104", name: "魔袍", type: ItemType.CLOTHES),
    ItemInfo(0, template: "3104", name: "灵魂战甲", type: ItemType.CLOTHES),
    ItemInfo(0, template: "1200", name: "布衣", type: ItemType.CLOTHES),
    ItemInfo(0, template: "1201", name: "轻盔", type: ItemType.CLOTHES),
    ItemInfo(0, template: "1202", name: "中盔", type: ItemType.CLOTHES),
    ItemInfo(0, template: "1203", name: "金鹏宝甲", type: ItemType.CLOTHES),
    ItemInfo(0, template: "1204", name: "重盔", type: ItemType.CLOTHES),
    ItemInfo(0, template: "2204", name: "魔袍", type: ItemType.CLOTHES),
    ItemInfo(0, template: "3204", name: "灵魂战甲", type: ItemType.CLOTHES),

    ItemInfo(0, template: "100", name: "金币（小）", type: ItemType.COIN),
    ItemInfo(0, template: "101", name: "金币（中）", type: ItemType.COIN),
    ItemInfo(0, template: "102", name: "金币（大）", type: ItemType.COIN),
    ItemInfo(0, template: "103", name: "金创药（小）", type: ItemType.POTION),
    ItemInfo(0, template: "104", name: "金创药（中）", type: ItemType.POTION),
    ItemInfo(0, template: "105", name: "金创药（大）", type: ItemType.POTION),
    ItemInfo(0, template: "106", name: "魔法药（小）", type: ItemType.POTION),
    ItemInfo(0, template: "107", name: "魔法药（中）", type: ItemType.POTION),
    ItemInfo(0, template: "108", name: "魔法药（大）", type: ItemType.POTION),
    ItemInfo(0, template: "109", name: "太阳水（小）", type: ItemType.POTION),
    ItemInfo(0, template: "110", name: "太阳水（大）", type: ItemType.POTION),
  ];

  /// 创建物品
  static ItemInfo newItemInfo(int id, {required String template}) {
    ItemInfo? itemInfo;
    for (ItemInfo item in items) {
      if (item.template == template) {
        String icon = ItemData.getIcon(template);
        String texture = "";
        String show = "";
        if (item.type == ItemType.CLOTHES) {
          texture = ItemData.getClothes(template);
          show = ItemData.getClothesShow(template);
        } else if (item.type == ItemType.WEAPON) {
          texture = ItemData.getWeapon(template);
          show = ItemData.getWeaponShow(template);
        }
        itemInfo = ItemInfo(
          id,
          name: item.name,
          icon: icon,
          texture: texture,
          show: show,
          type: item.type,
          template: item.template,
        );
        break;
      }
    }
    if (itemInfo == null) {
      print("获取物品错误，检查模板ID是否正确: " + template.toString());
    }
    return itemInfo!;
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

  static String getClothesShow(String name) {
    return showPath + "clothes/" + name + ".png";
  }

  static String getWeaponShow(String name) {
    return showPath + "weapon/" + name + ".png";
  }

  static int generateItemId() {
    uniqueId += 1;
    return uniqueId;
  }
}
