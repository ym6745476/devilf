import 'dart:collection';
import 'dart:ui';
import 'package:devilf/game/df_assets_loader.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_sprite_image.dart';
import 'package:devilf/game/df_sprite.dart';
import 'dart:ui' as ui;

import 'df_math_offset.dart';
import 'df_math_rect.dart';
import 'df_math_size.dart';
import 'df_animation.dart';

/// 动画精灵
class DFSpriteAnimation extends DFSprite{

  /// 这个动画的全部帧
  Map<String,List<DFImageSprite>> frames = HashMap<String,List<DFImageSprite>>();

  /// 绑定动画
  List<DFSpriteAnimation> bindSprites = [];

  /// 当前是的Index
  int currentIndex = 0;

  /// 是否循环动画
  bool loop = true;

  /// 帧速率
  int stepTime;

  /// 当前动画类型
  String currentAnimation = DFAnimation.NONE;

  /// x轴镜像
  bool currentAnimationFlippedX = false;

  /// 被绑定状态
  bool isBind = false;

  /// 帧绘制时钟
  int clock = 0;

  /// 完成事件
  Function? onComplete;

  /// 创建动画精灵
  DFSpriteAnimation(
      {
        this.stepTime = 200,
        this.loop = true,
        DFPosition position = const DFPosition(0, 0),
        DFSize size = const DFSize(128, 128),
      }) :super(position: position, size: size);

  /// 从plist转换Json里读取图片
  /// {
  /// 	"frames": {
  /// 		"idle_00000.png":
  ///     {
  /// 	       "frame": "{{929,291},{76,110}}",
  /// 	       "offset": "{-19,24}",
  ///          "rotated": true
  ///      }
  ///   }
  /// }
  static Future<DFSpriteAnimation> load(String src,String plist) async {

    DFSpriteAnimation spriteAnimation = DFSpriteAnimation(stepTime:200,loop: true);

    DFAnimation.sequence.forEach((element) {
      spriteAnimation.frames[element] = [];
    });

    ui.Image image = await DFAssetsLoader.loadImage(src);
    Map<String, dynamic> jsonMap = await DFAssetsLoader.loadJson(plist);

    final jsonFrames = jsonMap['frames'] as Map<String, dynamic>;

    jsonFrames.forEach((key, value) {

      final map = value as Map;

      bool rotated = false;
      if(map['rotated']!=null){
        rotated = map['rotated'] as bool;
      }


      final frame = map['frame'] as String;
      final offset = map['offset'] as String;
      List<String> frameText = frame.replaceAll("{{", "").replaceAll("},{", ",").replaceAll("}}", "").split(",");
      List<String> offsetText = offset.replaceAll("{", "").replaceAll("}", "").split(",");


      DFRect frameRect = DFRect(double.parse(frameText[0]),double.parse(frameText[1]),double.parse(frameText[2]), double.parse(frameText[3]));
      DFOffset frameOffset = DFOffset(double.parse(offsetText[0]),double.parse(offsetText[1]));
      if(rotated){
        frameRect = DFRect(double.parse(frameText[0]),double.parse(frameText[1]),double.parse(frameText[3]), double.parse(frameText[2]));
        frameOffset = DFOffset(double.parse(offsetText[1]),double.parse(offsetText[0]));
      }
      //print("frameSize:" + frameRect.toString());
      //print("frameOffset:" + frameOffset.toString());

      DFImageSprite sprite = DFImageSprite(
        image,
        offset:frameOffset,
        rect: frameRect,
        rotated:rotated,
        scale: 0.5,
      );

      //idle_00000.png
      String actionText = "idle_";
      String action = DFAnimation.IDLE;
      if(key.contains("idle_")){
        actionText = "idle_";
        action = DFAnimation.IDLE;
      }else if(key.contains("run_")){
        actionText = "run_";
        action = DFAnimation.RUN;
      }
      String keyNumber = key.replaceAll(actionText, "").replaceAll(".png", "");
      if(keyNumber.startsWith("000")){
        spriteAnimation.frames[action + DFAnimation.UP]?.add(sprite);
      }
      if(keyNumber.startsWith("100")){
        spriteAnimation.frames[action + DFAnimation.UP_RIGHT]?.add(sprite);
        spriteAnimation.frames[action + DFAnimation.UP_LEFT]?.add(sprite);
      }
      if(keyNumber.startsWith("200")){
        spriteAnimation.frames[action + DFAnimation.RIGHT]?.add(sprite);
        spriteAnimation.frames[action + DFAnimation.LEFT]?.add(sprite);
      }
      if(keyNumber.startsWith("300")){
        spriteAnimation.frames[action + DFAnimation.DOWN_RIGHT]?.add(sprite);
        spriteAnimation.frames[action + DFAnimation.DOWN_LEFT]?.add(sprite);
      }
      if(keyNumber.startsWith("400")){
        spriteAnimation.frames[action + DFAnimation.DOWN]?.add(sprite);
      }

    });

    return spriteAnimation;

  }

  /// 从Json里读取图片
  /// {
  /// 	"frames": {
  /// 		"idle_00000.png":
  ///     {
  /// 	       "frame": {"x":163,"y":2,"w":96,"h":78},
  /// 	       "offset": {"x":0,"y":0},
  ///          "rotated": true
  ///      }
  ///   }
  /// }
  static Future<DFSpriteAnimation> loadJson(String src,String json) async {

    DFSpriteAnimation spriteAnimation = DFSpriteAnimation(stepTime:200,loop: true);

    DFAnimation.sequence.forEach((element) {
      spriteAnimation.frames[element] = [];
    });

    ui.Image image = await DFAssetsLoader.loadImage(src);
    Map<String, dynamic> jsonMap = await DFAssetsLoader.loadJson(json);
    Map<String, dynamic> offsetMap = await DFAssetsLoader.loadJson(json.replaceAll(".json", ".txt"));

    final jsonFrames = jsonMap['frames'] as Map<String, dynamic>;
    final jsonOffset = offsetMap['frames'] as Map<String, dynamic>;

    jsonFrames.forEach((key, value) {

      final map = value as Map;
      final frame = map['frame'] as Map<String, dynamic>;

      int w = frame['w'];
      int h = frame['h'];
      int x = frame['x'];
      int y = frame['y'];

      bool rotated = false;
      if(map['rotated']!=null){
        rotated = map['rotated'] as bool;
      }

      int offsetX = 0;
      int offsetY = 0;
      if(jsonOffset.containsKey(key)){
        final offsetMap = jsonOffset[key];
        final offset = offsetMap['offset'] as Map<String, dynamic>;
        offsetX = offset['x'];
        offsetY = offset['y'];
      }

      DFRect frameRect = DFRect(x.toDouble(), y.toDouble(),w.toDouble(),h.toDouble());
      DFOffset frameOffset = DFOffset(offsetX.toDouble(),offsetY.toDouble());

      //print("frameSize:" + frameRect.toString());
      //print("frameOffset:" + frameOffset.toString());

      DFImageSprite sprite = DFImageSprite(
        image,
        offset:frameOffset,
        rect: frameRect,
        rotated:rotated,
        scale: 0.9,
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
        spriteAnimation.frames[action + DFAnimation.UP]?.add(sprite);
      }
      if(keyNumber >= 8 && keyNumber < 16){
        spriteAnimation.frames[action + DFAnimation.UP_RIGHT]?.add(sprite);
      }
      if(keyNumber >= 16 && keyNumber < 24){
        spriteAnimation.frames[action + DFAnimation.RIGHT]?.add(sprite);
      }
      if(keyNumber >= 24 && keyNumber < 32){
        spriteAnimation.frames[action + DFAnimation.DOWN_RIGHT]?.add(sprite);
      }
      if(keyNumber >= 32 && keyNumber < 40){
        spriteAnimation.frames[action + DFAnimation.DOWN]?.add(sprite);
      }
      if(keyNumber >= 40 && keyNumber < 48){
        spriteAnimation.frames[action + DFAnimation.DOWN_LEFT]?.add(sprite);
      }
      if(keyNumber >= 48 && keyNumber < 56){
        spriteAnimation.frames[action + DFAnimation.LEFT]?.add(sprite);
      }
      if(keyNumber >= 56 && keyNumber < 64){
        spriteAnimation.frames[action + DFAnimation.UP_LEFT]?.add(sprite);
      }

      if(keyNumber >= 128 && keyNumber < 136){
        spriteAnimation.frames[action + DFAnimation.UP]?.add(sprite);
      }
      if(keyNumber >= 136 && keyNumber < 144){
        spriteAnimation.frames[action + DFAnimation.UP_RIGHT]?.add(sprite);
      }
      if(keyNumber >= 144 && keyNumber < 152){
        spriteAnimation.frames[action + DFAnimation.RIGHT]?.add(sprite);
      }
      if(keyNumber >= 152 && keyNumber < 160){
        spriteAnimation.frames[action + DFAnimation.DOWN_RIGHT]?.add(sprite);
      }
      if(keyNumber >= 160 && keyNumber < 168){
        spriteAnimation.frames[action + DFAnimation.DOWN]?.add(sprite);
      }
      if(keyNumber >= 168 && keyNumber < 176){
        spriteAnimation.frames[action + DFAnimation.DOWN_LEFT]?.add(sprite);
      }
      if(keyNumber >= 176 && keyNumber < 184){
        spriteAnimation.frames[action + DFAnimation.LEFT]?.add(sprite);
      }
      if(keyNumber >= 184 && keyNumber < 189){
        spriteAnimation.frames[action + DFAnimation.UP_LEFT]?.add(sprite);
      }

    });

    return spriteAnimation;

  }

  /// 绑定动画同步子精灵
  void bindChild(DFSpriteAnimation sprite){
    sprite.isBind = true;
    sprite.position = DFPosition(sprite.position.x - size.width/2, sprite.position.y - size.height/2);
    this.bindSprites.add(sprite);
  }

  /// 播放动画
  void play(String animation) {

      if(this.currentAnimation != animation){
        this.currentIndex = 0;
        this.currentAnimation = animation;
        print("Play:" + animation.toString());
      }
  }

  /// 精灵更新
  @override
  void update(double dt) {

    /// 控制动画帧切换
    if(this.frames[this.currentAnimation]!=null && this.frames[this.currentAnimation]!.length > 0){

      List<DFImageSprite> sprites = this.frames[this.currentAnimation]!;

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

  /// 精灵渲染
  @override
  void render(Canvas canvas) {

    /// 画布暂存
    canvas.save();

    if(!isBind){
      /// 将子精灵转换为相对坐标
      if(parent!=null){
        DFPosition parentPosition = DFPosition(parent!.position.x - parent!.size.width/2,parent!.position.y - parent!.size.height/2);
        canvas.translate(parentPosition.x + position.x, parentPosition.y + position.y);
      }else{
        canvas.translate(position.x, position.y);
      }
    }else{
      /// 将子精灵转换为相对坐标
      canvas.translate(position.x, position.y);
    }

    /// 精灵矩形边界
    var paint = new Paint()..color =  Color(0x6000FF00);
    //canvas.drawRect(Rect.fromLTWH(- size.width/2,- size.height/2, size.width, size.height), paint);

    if(this.frames[this.currentAnimation]!=null && this.frames[this.currentAnimation]!.length > 0) {
      List<DFImageSprite> sprites = this.frames[this.currentAnimation]!;
      sprites[this.currentIndex].flippedX = currentAnimationFlippedX;
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
      element.currentAnimationFlippedX = currentAnimationFlippedX;
      element.render(canvas);
    });

    /// 画布恢复
    canvas.restore();
  }

}

