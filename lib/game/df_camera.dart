import 'package:devilf/game/df_math_rect.dart';
import 'package:devilf/sprite/df_sprite.dart';

/// 摄像机
class DFCamera {
  /// 跟踪目标
  DFSprite? sprite;

  /// 视窗区域
  final DFRect rect;

  /// 缩放比例
  final double zoom;

  /// 创建矩形
  DFCamera({this.zoom = 1, this.rect = const DFRect(0, 0, 100, 100)});

  void lookAt(DFSprite sprite) {
    this.sprite = sprite;
  }
}
