/// 一件物品类
class ItemInfo {
  /// 物品ID
  int id;

  /// 物品名字
  String name;

  /// 纹理
  String? texture;

  /// 图标
  String? icon;

  /// 预览
  String? show;

  /// 物品类型
  ItemType type;

  /// 创建物品
  ItemInfo(this.id, this.name, {this.icon,this.show,this.texture,this.type = ItemType.NONE});
}

/// 物品类型
enum ItemType{
  NONE,
  WEAPON,
  CLOTHES,
  HELMET,
  NECKLACE,
  BRACELET,
  RING,
  BELT,
  BOOTS,
  MEDAL,
  GEMSTONE,
  SKILL,
  PET,
}
