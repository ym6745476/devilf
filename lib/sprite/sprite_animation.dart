import 'dart:ui';
import 'package:devilf/base/cache.dart';
import 'package:devilf/base/position.dart';
import 'package:devilf/sprite/image_sprite.dart';
import 'package:devilf/sprite/sprite.dart';

/// 精灵动画
class SpriteAnimation {

  /// 这个动画的全部帧
  List<SpriteAnimationFrame> frames = [];

  /// 当前是的Index
  int currentIndex = 0;

  /// 是否循环
  bool loop = true;

  /// 完成事件
  Function? onComplete;

  /// 用动画帧创建精灵动画
  SpriteAnimation(this.frames, {this.loop = true});

  Future<void> fromJsonData(Image image,String json) async {

    Map<String, dynamic> jsonMap = await Cache.readJson(json);

    final jsonFrames = jsonMap['frames'] as Map<String, dynamic>;

    final frames = jsonFrames.values.map((dynamic value) {
        final map = value as Map;
        final frameData = map['frame'] as Map<String, dynamic>;
        final x = frameData['x'] as double;
        final y = frameData['y'] as double;
        final width = frameData['w'] as double;
        final height = frameData['h'] as double;
        final stepTime = (map['duration'] as int) / 1000;

        ImageSprite sprite = ImageSprite(
            image,
            position: Position(x, y),
            size: Size(width, height),
        );

        return SpriteAnimationFrame(sprite, stepTime);
    });

    this.frames = frames.toList();
    loop = true;
  }

}

/// 动画中的一帧
class SpriteAnimationFrame {
  Sprite sprite;
  double stepTime;
  SpriteAnimationFrame(this.sprite, this.stepTime);
}

