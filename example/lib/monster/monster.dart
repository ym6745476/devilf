import 'package:example/base/living.dart';

/// 怪物类
class Monster extends Living {

  /// 名字
  String name = "";

  /// 魔法值
  double mp = 100;

  /// 最大魔法值
  double maxMp = 100;

  /// 最小攻击力
  double minAt = 10;

  /// 最大攻击力
  double maxAt = 100;

  /// 视野范围
  double vision = 256;

  /// 动作间隔
  double actionStepTime = 1000;

  /// 复活间隔
  double rebornTime = 3000;

  Monster(this.name);
}
