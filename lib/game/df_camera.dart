import 'package:devilf/core/df_rect.dart';
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
  DFCamera({this.zoom = 1, required this.rect});

  /// 设置跟随目标
  void lookAt(DFSprite sprite) {
    this.sprite = sprite;
  }
}
