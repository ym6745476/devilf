import 'package:devilf_engine/game/df_animation.dart';
import 'package:devilf_engine/util/df_ui_util.dart';
import 'package:devilf_engine/util/df_util.dart';
import 'package:devilf_engine/widget/df_button.dart';
import 'package:devilf_engine/widget/df_joystick.dart';
import 'package:example/data/effect_data.dart';
import 'package:example/layer/character_layer.dart';
import 'package:example/layer/rucksack_layer.dart';
import 'package:example/player/player_sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../game_manager.dart';

/// 控制界面
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
          _playerSprite?.startAutoFight(DFAction.CASTING, effect: EffectData.items["2001"]!);
        } else {
          _playerSprite?.cancelAutoFight(action: DFAction.IDLE);
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
              print("JoyStick Direction:" + direction);
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
                image: EffectData.items["1001"]!.icon!,
                size: Size(70, 70),
                onPressed: (button) {
                  _playerSprite?.moveToAction(DFAction.ATTACK, effect: EffectData.items["1001"]);
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
                image: EffectData.items["1002"]!.icon!,
                size: Size(50, 50),
                onPressed: (button) {
                  _playerSprite?.moveToAction(DFAction.ATTACK, effect: EffectData.items["1002"]);
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
              child: DFButton(
                image: EffectData.items["2001"]!.icon!,
                size: Size(50, 50),
                onPressed: (button) {
                  _playerSprite?.moveToAction(DFAction.CASTING, effect: EffectData.items["2001"]);
                },
              ),
            )),

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
              child: DFButton(
                image: EffectData.items["3001"]!.icon!,
                size: Size(50, 50),
                onPressed: (button) {
                  _playerSprite?.moveToAction(DFAction.CASTING, effect: EffectData.items["3001"]);
                },
              ),
            )),

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
              child: DFButton(
                image: EffectData.items["3002"]!.icon!,
                size: Size(50, 50),
                onPressed: (button) {
                  _playerSprite?.moveToAction(DFAction.CASTING, effect: EffectData.items["3002"]);
                },
              ),
            )),

        /// 采集
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 60,
          right: 170,
          child: DFButton(
            /// text: "采集",
            image: "assets/images/ui/skill_collect.png",
            size: Size(36, 36),
            onPressed: (button) {
              _playerSprite?.play(DFAction.COLLECT);
            },
          ),
        ),

        /// 拾取
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          right: 230,
          child: DFButton(
            /// text: "拾取",
            image: "assets/images/ui/skill_pick.png",
            size: Size(40, 40),
            onPressed: (button) {
              _playerSprite?.play(DFAction.COLLECT);
            },
          ),
        ),

        /// 锁定目标
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 16,
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

        /// 菜单
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          right: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DFButton(
                /// text: "角色",
                image: "assets/images/ui/menu_01.png",
                pressedImage: "assets/images/ui/menu_01_pressed.png",
                size: Size(50, 50),
                onPressed: (button) {
                  DFUiUtil.showLayer(context, CharacterLayer());
                },
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: DFButton(
                  /// text: "背包",
                  image: "assets/images/ui/menu_02.png",
                  pressedImage: "assets/images/ui/menu_02_pressed.png",
                  size: Size(50, 50),
                  onPressed: (button) {
                    DFUiUtil.showLayer(context, RucksackLayer());
                  },
                ),
              ),

            ],
          ),
        ),
      ]),
    );
  }
}
