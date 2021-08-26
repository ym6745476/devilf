/// 掉落物品类
class DropItemInfo {
  /// 掉落ID
  int id;

  /// 物品模板
  String template;

  /// 数量
  int count;

  /// 概率
  double probability;

  /// 创建掉落物品
  DropItemInfo(
    this.id, {
    required this.template,
    this.count = 1,
    this.probability = 0,
  });
}
