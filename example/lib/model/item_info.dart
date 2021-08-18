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

  /// 物品类型
  ItemType type;

  /// 创建特效
  ItemInfo(this.id, this.name, {this.icon,this.texture,this.type = ItemType.NONE});
}

/// 物品类型
enum ItemType{
  NONE,
  CLOTHES,
  WEAPON,
}
