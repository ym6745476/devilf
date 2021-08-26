/// 怪物刷新类
class MonsterUpdate {
  /// 位置x
  double x;

  /// 位置y
  double y;

  /// 数量
  int count;

  /// 半径
  int radius;

  /// 怪物模板
  String template;

  /// 掉落列表
  List<int> dropIds;

  /// 创建怪物刷新
  MonsterUpdate({
    required this.template,
    required this.x,
    required this.y,
    this.count = 1,
    this.radius = 100,
    this.dropIds = const [],
  });
}
