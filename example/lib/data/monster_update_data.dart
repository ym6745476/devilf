import 'package:example/monster/monster_update.dart';

/// 怪物刷新数据
class MonsterUpdateData {
  /// 数据
  static List<MonsterUpdate> items = [
    MonsterUpdate(template: "spider", x: 700, y: 1500, count: 5, radius: 200, dropIds: [10,13,16,100,101,104,105]),
    MonsterUpdate(template: "snake", x: 1000, y: 1400, count: 5, radius: 200, dropIds: [10,13,16,100,101,104,105]),
    MonsterUpdate(template: "1200", x: 1000, y: 1400, count: 1, radius: 200, dropIds: [10,13,16,100,101,104,105]),
  ];
}
