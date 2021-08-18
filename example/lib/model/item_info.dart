/// 一件物品类
class ItemInfo {
  /// 物品ID
  int id;

  /// 物品名字
  String name;

  /// 图标
  String? icon;

  /// 创建特效
  ItemInfo(this.id, this.name, {this.icon});
}
