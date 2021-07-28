import 'package:example/base/living.dart';

/// 玩家类
class Player extends Living {
  /// 魔法值
  double mp = 100;

  /// 最大魔法值
  double maxMp = 100;

  /// 最小攻击力
  double minAt = 10;

  /// 最大攻击力
  double maxAt = 100;

  /// 视野范围
  double vision = 512;
}
