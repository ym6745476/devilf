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

  /// 绑定动画
  List<SpriteAnimation> bindSprites = [];

  /// 当前是的Index
  int currentIndex = 0;

  /// 是否循环
  bool loop = true;

  /// 帧速率
  int stepTime;

  /// 当前动画类型
  AnimationName currentAnimation = AnimationName.NONE;

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
  /// 		"idle_00000.png":
  ///     {
  /// 	       "frame": {"x":163,"y":2,"w":96,"h":78},
  /// 	       "offset": {"x":0,"y":0},
  ///          "rotated": true,
  /// 	       "sourceSize": {"w":78,"h":96}
  ///      }
  ///   }
  /// }
  static Future<SpriteAnimation> load(String src,String json) async {

    SpriteAnimation spriteAnimation = SpriteAnimation(stepTime:200,loop: true);

    spriteAnimation.frames[AnimationName.IDLE_LEFT] = [];
    spriteAnimation.frames[AnimationName.IDLE_UP_LEFT] = [];
    spriteAnimation.frames[AnimationName.IDLE_UP] = [];
    spriteAnimation.frames[AnimationName.IDLE_UP_RIGHT] = [];
    spriteAnimation.frames[AnimationName.IDLE_RIGHT] = [];
    spriteAnimation.frames[AnimationName.IDLE_DOWN_RIGHT] = [];
    spriteAnimation.frames[AnimationName.IDLE_DOWN] = [];
    spriteAnimation.frames[AnimationName.IDLE_DOWN_LEFT] = [];

    spriteAnimation.frames[AnimationName.RUN_LEFT] = [];
    spriteAnimation.frames[AnimationName.RUN_UP_LEFT] = [];
    spriteAnimation.frames[AnimationName.RUN_UP] = [];
    spriteAnimation.frames[AnimationName.RUN_UP_RIGHT] = [];
    spriteAnimation.frames[AnimationName.RUN_RIGHT] = [];
    spriteAnimation.frames[AnimationName.RUN_DOWN_RIGHT] = [];
    spriteAnimation.frames[AnimationName.RUN_DOWN] = [];
    spriteAnimation.frames[AnimationName.RUN_DOWN_LEFT] = [];

    ui.Image image = await AssetsLoader.loadImage(src);
    Map<String, dynamic> jsonMap = await AssetsLoader.loadJson(json);
    //Map<String, dynamic> offsetMap = await AssetsLoader.loadJson(json.replaceAll(".json", ".txt"));

    final jsonFrames = jsonMap['frames'] as Map<String, dynamic>;
    //final jsonOffset = offsetMap['frames'] as Map<String, dynamic>;

    jsonFrames.forEach((key, value) {

      final map = value as Map;
      //final offsetMap = jsonOffset[key];

      final frame = map['frame'] as Map<String, dynamic>;
      //final offset = offsetMap['offset'] as Map<String, dynamic>;

      int w = frame['w'];
      int h = frame['h'];
      int x = frame['x'];
      int y = frame['y'];

      //int offsetX = offset['x'];
      //int offsetY = offset['y'];

      bool rotated = false;
      if(map['rotated']!=null){
        rotated = map['rotated'] as bool;
      }

      Rect frameRect = Rect.fromLTWH(x.toDouble(), y.toDouble(),w.toDouble(),h.toDouble());
      //Offset frameOffset = Offset(offsetX.toDouble(),offsetY.toDouble());

      //print("frameSize:" + frameRect.toString());
      //print("frameOffset:" + frameOffset.toString());

      ImageSprite sprite = ImageSprite(
        image,
        //offset:frameOffset,
        rect: frameRect,
        rotated:rotated,
        scale: 0.6,
      );

      //idle_00000.png
      String action = "idle_";
      if(key.contains("idle_")){
        action = "idle_";
      }else if(key.contains("run_")){
        action = "run_";
      }
      double keyNumber = double.parse(key.replaceAll(action, "").replaceAll(".png", ""));
      if(keyNumber < 8){
        spriteAnimation.frames[AnimationName.IDLE_UP]?.add(sprite);
      }
      if(keyNumber >= 8 && keyNumber < 16){
        spriteAnimation.frames[AnimationName.IDLE_UP_RIGHT]?.add(sprite);
      }
      if(keyNumber >= 16 && keyNumber < 24){
        spriteAnimation.frames[AnimationName.IDLE_RIGHT]?.add(sprite);
      }
      if(keyNumber >= 24 && keyNumber < 32){
        spriteAnimation.frames[AnimationName.IDLE_DOWN_RIGHT]?.add(sprite);
      }
      if(keyNumber >= 32 && keyNumber < 40){
        spriteAnimation.frames[AnimationName.IDLE_DOWN]?.add(sprite);
      }
      if(keyNumber >= 40 && keyNumber < 48){
        spriteAnimation.frames[AnimationName.IDLE_DOWN_LEFT]?.add(sprite);
      }
      if(keyNumber >= 48 && keyNumber < 56){
        spriteAnimation.frames[AnimationName.IDLE_LEFT]?.add(sprite);
      }
      if(keyNumber >= 56 && keyNumber < 64){
        spriteAnimation.frames[AnimationName.IDLE_UP_LEFT]?.add(sprite);
      }

      if(keyNumber >= 128 && keyNumber < 136){
        spriteAnimation.frames[AnimationName.RUN_UP]?.add(sprite);
      }
      if(keyNumber >= 136 && keyNumber < 144){
        spriteAnimation.frames[AnimationName.RUN_UP_RIGHT]?.add(sprite);
      }
      if(keyNumber >= 144 && keyNumber < 152){
        spriteAnimation.frames[AnimationName.RUN_RIGHT]?.add(sprite);
      }
      if(keyNumber >= 152 && keyNumber < 160){
        spriteAnimation.frames[AnimationName.RUN_DOWN_RIGHT]?.add(sprite);
      }
      if(keyNumber >= 160 && keyNumber < 168){
        spriteAnimation.frames[AnimationName.RUN_DOWN]?.add(sprite);
      }
      if(keyNumber >= 168 && keyNumber < 176){
        spriteAnimation.frames[AnimationName.RUN_DOWN_LEFT]?.add(sprite);
      }
      if(keyNumber >= 176 && keyNumber < 184){
        spriteAnimation.frames[AnimationName.RUN_LEFT]?.add(sprite);
      }
      if(keyNumber >= 184 && keyNumber < 189){
        spriteAnimation.frames[AnimationName.RUN_UP_LEFT]?.add(sprite);
      }

      sprite.parent = spriteAnimation;

    });

    return spriteAnimation;

  }

  /// 绑定动画同步子精灵
  void bindChild(SpriteAnimation sprite){
    sprite.isBind = true;
    this.bindSprites.add(sprite);
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

    if(this.frames[this.currentAnimation]!=null && this.frames[this.currentAnimation]!.length > 0){

      List<ImageSprite> sprites = this.frames[this.currentAnimation]!;

      /// 控制动画帧按照stepTime进行更新
      if(DateTime.now().millisecondsSinceEpoch - this.clock > this.stepTime){

        if(sprites.length > this.currentIndex + 1){

          this.clock = DateTime.now().millisecondsSinceEpoch;
          this.currentIndex = this.currentIndex + 1;

        }else{
          /// 如果循环就从0再次开始
          if(this.loop){
            this.clock = DateTime.now().millisecondsSinceEpoch;
            this.currentIndex = 0;
          }
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {

    canvas.save();

    if(!isBind){
      /// 子类调用super可以自动移动画布到相对坐标
      if(parent!=null){
        Position parentPosition = Position(parent!.position.x - parent!.size.width/2,parent!.position.y - parent!.size.height/2);
        canvas.translate(parentPosition.x + position.x, parentPosition.y + position.y);
      }else{
        canvas.translate(position.x, position.y);
      }
    }

    /// 精灵矩形边界
    var paint = new Paint()..color =  Color(0x50006c54);
    //canvas.drawRect(Rect.fromLTWH(- size.width/2,- size.height/2, size.width, size.height), paint);

    if(this.frames[this.currentAnimation]!=null && this.frames[this.currentAnimation]!.length > 0) {
      List<ImageSprite> sprites = this.frames[this.currentAnimation]!;
      sprites[this.currentIndex].render(canvas);
    }

    /// 绘制子精灵
    if(children.length > 0){
      children.forEach((element) {
        element.render(canvas);
      });
    }

    /// 绘制绑定精灵
    bindSprites.forEach((element) {
      element.currentIndex = this.currentIndex;
      element.currentAnimation = this.currentAnimation;
      element.render(canvas);
    });

    canvas.restore();
  }

}


