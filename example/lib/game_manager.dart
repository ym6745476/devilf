import 'package:devilf/game/df_game_widget.dart';
import 'package:example/player/player_sprite.dart';

import 'game_scene.dart';
import 'monster/monster_sprite.dart';

/// 游戏管理器
class GameManager {
  static double visibleWidth = 600;
  static double visibleHeight = 400;
  static DFGameWidget? gameWidget;
  static PlayerSprite? playerSprite;
  static List<MonsterSprite>? monsterSprites;
}