import 'dart:collection';
import 'dart:ui';
import 'package:devilf/base/animation_name.dart';
import 'package:devilf/base/assets_loader.dart';
import 'package:devilf/base/position.dart';
import 'package:devilf/sprite/image_sprite.dart';
import 'package:devilf/sprite/sprite.dart';
import 'dart:ui' as ui;

/// 精灵动画
class SpriteAnimation extends Sprite{

  /// 这个动画的全部帧
  Map<AnimationName,List<ImageSprite>> frames = HashMap<AnimationName,List<ImageSprite>>();

  /// 当前是的Index
  int currentIndex = 0;

  /// 是否循环
  bool loop = true;

  /// 帧速率
  int stepTime;

  /// 当前动画类型
  AnimationName currentAnimation = AnimationName.none;

  /// 帧绘制时钟
  int clock = 0;

  /// 完成事件
  Function? onComplete;

  /// 用动画帧创建精灵动画
  SpriteAnimation(
      {
        this.stepTime = 200,
        this.loop = true,
        Position position = const Position(0, 0),
        Size size = const Size(128, 128),
      }) :super(position: position, size: size);

  /// 从Json里读取图片
  /// {
  /// 	"frames": {
  /// 		"attack_00000.png": {
  /// 			"frame": "{{119,523},{84,112}}",
  /// 			"offset": "{-4,18}",
  /// 			"rotated": true,
  ///  			"sourceColorRect": "{{210,182},{84,112}}",
  /// 			"sourceSize": "{512,512}"
  /// 		}
  /// }
  static Future<SpriteAnimation> load(String src,String json) async {

    SpriteAnimation spriteAnimation = SpriteAnimation(stepTime:300,loop: true);

    ui.Image image = await AssetsLoader.loadImage(src);
    Map<String, dynamic> jsonMap = await AssetsLoader.loadJson(json);

    final jsonFrames = jsonMap['frames'] as Map<String, dynamic>;

    jsonFrames.forEach((key, value) {

      final map = value as Map;
      final frame = map['frame'] as String;
      final offset = map['offset'] as String;
      final rotated = map['rotated'] as bool;

      //List<String> offsetRect = offset.replaceAll("{", "").replaceAll("}", "").split(",");
      List<String> frameRect = frame.replaceAll("{{", "").replaceAll("},{", ",").replaceAll("}}", "").split(",");

      Size frameSize = Size(double.parse(frameRect[2]), double.parse(frameRect[3]));
      Offset frameOffset = Offset(double.parse(frameRect[0]),double.parse(frameRect[1]));

      //print("frameSize:" + frameSize.toString());
      //print("frameOffset:" + frameOffset.toString());

      ImageSprite sprite = ImageSprite(
        image,
        position: Position(0, 0),
        size: frameSize,
        offset: frameOffset,
        rotated:rotated,
        scale: 0.7,
      );

      if(key.startsWith("idle")){
        if(spriteAnimation.frames[AnimationName.idleDown] == null){
          spriteAnimation.frames[AnimationName.idleDown] = [];
        }
        spriteAnimation.frames[AnimationName.idleDown]?.add(sprite);
      }

      sprite.parent = spriteAnimation;

    });

    return spriteAnimation;

  }


  /// 播放动画
  void play(AnimationName animation) {

      if(this.currentAnimation != animation){
        this.currentIndex = 0;
        this.currentAnimation = animation;
        print("Play:" + animation.toString());
      }
  }

  @override
  void update(double dt) {

    if(this.frames[this.currentAnimation]!=null){

      List<ImageSprite> sprites = this.frames[this.currentAnimation]!;

      /// 控制动画帧按照stepTime进行更新
      if(DateTime.now().millisecondsSinceEpoch - this.clock > this.stepTime){

        if(sprites.length > this.currentIndex + 1){

          sprites[this.currentIndex].update(dt);

          this.clock = DateTime.now().millisecondsSinceEpoch;
          this.currentIndex = this.currentIndex + 1;

        }else{
          /// 如果循环就从0再次开始
          if(this.loop){
            this.currentIndex = 0;
          }
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    /// 精灵矩形边界
    var paint = new Paint()..color =  Color(0x208552A1);
    //canvas.drawRect(Rect.fromLTWH(- size.width/2,- size.height/2, size.width, size.height), paint);

    if(this.frames[this.currentAnimation]!=null) {
      List<ImageSprite> sprites = this.frames[this.currentAnimation]!;
      sprites[this.currentIndex].render(canvas);
    }

    canvas.restore();
  }

}


