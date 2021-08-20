import 'package:example/monster/monster_update.dart';

/// 怪物刷新数据
class MonsterUpdateData {
  /// 数据
  static List<MonsterUpdate> items = [
    MonsterUpdate(x: 700, y: 1500, count: 5, radius: 200, template: "1001"),
    MonsterUpdate(x: 1000, y: 1400, count: 5, radius: 200, template: "1002"),
    MonsterUpdate(x: 1000, y: 1400, count: 1, radius: 200, template: "2001"),
  ];
}
