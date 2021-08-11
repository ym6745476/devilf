import 'package:devilf_engine/game/df_animation.dart';
import 'package:devilf_engine/util/df_util.dart';
import 'package:devilf_engine/widget/df_button.dart';
import 'package:devilf_engine/widget/df_joystick.dart';
import 'package:example/effect/effect_info.dart';
import 'package:example/player/player_sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../game_manager.dart';

/// 控制器层
class ControlLayer extends StatefulWidget {
  ControlLayer();

  @override
  _ControlLayerState createState() => _ControlLayerState();
}

class _ControlLayerState extends State<ControlLayer> {
  /// 玩家精灵
  PlayerSprite? _playerSprite;

  /// 自动按钮
  DFButton? _autoFightButton;

  @override
  void initState() {
    super.initState();
    _playerSprite = GameManager.playerSprite;

    _autoFightButton = DFButton(
      /// text: "自动战斗",
      image: "assets/images/ui/auto_off.png",
      pressedImage: "assets/images/ui/auto_on.png",
      size: Size(40, 40),
      onPressed: (button) {
        GameManager.isAutoFight = !GameManager.isAutoFight;
        button.setSelected(GameManager.isAutoFight);

        if (GameManager.isAutoFight) {
          EffectInfo effect1 = EffectInfo();
          effect1.name = "1002";
          effect1.type = EffectType.ATTACK;
          effect1.damageRange = 100;
          effect1.vision = 60;
          effect1.delayTime = 10;
          effect1.texture = "assets/images/effect/" + effect1.name + ".json";

          EffectInfo effect2 = EffectInfo();
          effect2.name = "2001";
          effect2.type = EffectType.TRACK;
          effect2.damageRange = 50;
          effect2.vision = 120;
          effect2.delayTime = 400;
          effect2.texture = "assets/images/effect/" + effect2.name + ".json";

          _playerSprite?.moveToAction(DFAction.ATTACK, effect: effect1, autoFight: true);
          _playerSprite?.moveToAction(DFAction.CASTING, effect: effect2, autoFight: true);
        } else {
          _playerSprite?.cancelAutoFight(idle: true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: GameManager.visibleWidth,
      height: GameManager.visibleHeight,
      child: Stack(fit: StackFit.expand, children: <Widget>[
        /// 摇杆
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom,
          left: 0,
          child: DFJoyStick(
            /// backgroundImage: "assets/images/ui/joystick.png",
            /// handleImage: "assets/images/ui/joystick_btn.png",
            handleColor: Color(0x60FFFFFF),
            backgroundColor: Color(0x40FFFFFF),
            onChange: (String direction, double radians) {
              /// 获取8方向的弧度
              radians = DFUtil.getRadians(direction);
              _playerSprite?.cancelAutoFight();
              GameManager.isAutoFight = false;
              _autoFightButton!.setSelected(false);
              _playerSprite?.play(DFAction.RUN, direction: direction, radians: radians);
            },
            onCancel: (direction) {
              _playerSprite?.play(DFAction.IDLE, direction: direction);
            },
          ),
        ),

        Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/ui/skill_primary_bg.png"),
                ),
              ),
              alignment: Alignment.center,
              child: DFButton(
                /// text: "攻击",
                image: "assets/images/skill_icon/1002.png",
                size: Size(70, 70),
                onPressed: (button) {
                  EffectInfo effect = EffectInfo();
                  effect.name = "1002";
                  effect.type = EffectType.ATTACK;
                  effect.damageRange = 100;
                  effect.vision = 60;
                  effect.delayTime = 10;
                  effect.texture = "assets/images/effect/" + effect.name + ".json";
                  _playerSprite?.moveToAction(DFAction.ATTACK, effect: effect);
                },
              ),
            )),

        Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 120,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/ui/skill_secondary_bg.png"),
                ),
              ),
              alignment: Alignment.center,
              child: DFButton(
                /// text: "小火球",
                image: "assets/images/skill_icon/2001.png",
                size: Size(50, 50),
                onPressed: (button) {
                  EffectInfo effect = EffectInfo();
                  effect.name = "2001";
                  effect.type = EffectType.TRACK;
                  effect.damageRange = 50;
                  effect.vision = 120;
                  effect.delayTime = 400;
                  effect.texture = "assets/images/effect/" + effect.name + ".json";
                  _playerSprite?.moveToAction(DFAction.CASTING, effect: effect);
                },
              ),
            )),

        Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 105,
            right: 65,
            child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/ui/skill_secondary_bg.png"),
                  ),
                ),
                alignment: Alignment.center,
                child: Container())),

        Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 63,
            right: 105,
            child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/ui/skill_secondary_bg.png"),
                  ),
                ),
                alignment: Alignment.center,
                child: Container())),

        Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 10,
            right: 120,
            child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/ui/skill_secondary_bg.png"),
                  ),
                ),
                alignment: Alignment.center,
                child: Container())),

        /// 采集
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 60,
          right: 170,
          child: DFButton(
            /// text: "采集",
            image: "assets/images/ui/skill_collect.png",
            size: Size(36, 36),
            onPressed: (button) {
              _playerSprite?.play(DFAction.DIG);
            },
          ),
        ),

        /// 拾取
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 18,
          right: 230,
          child: DFButton(
            /// text: "拾取",
            image: "assets/images/ui/skill_pick.png",
            size: Size(40, 40),
            onPressed: (button) {
              _playerSprite?.play(DFAction.DIG);
            },
          ),
        ),

        /// 锁定目标
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 18,
          right: 180,
          child: DFButton(
            /// text: "目标",
            image: "assets/images/ui/skill_select.png",
            size: Size(40, 40),
            onPressed: (button) {
              _playerSprite?.lockTargetSprite();
            },
          ),
        ),

        /// 自动战斗
        _autoFightButton != null
            ? Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 180,
                right: 15,
                child: _autoFightButton!,
              )
            : Container(),
      ]),
    );
  }
}
