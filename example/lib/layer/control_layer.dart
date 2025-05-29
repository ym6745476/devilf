import 'package:devilf_engine/game/df_animation.dart';
import 'package:devilf_engine/util/df_ui_util.dart';
import 'package:devilf_engine/util/df_util.dart';
import 'package:devilf_engine/widget/df_button.dart';
import 'package:devilf_engine/widget/df_check_button.dart';
import 'package:devilf_engine/widget/df_joystick.dart';
import 'package:example/data/effect_data.dart';
import 'package:example/item/item_sprite.dart';
import 'package:example/layer/character_layer.dart';
import 'package:example/layer/rucksack_layer.dart';
import 'package:example/monster/monster_sprite.dart';
import 'package:example/player/player_sprite.dart';
import 'package:flutter/material.dart';

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
  DFCheckButton? _autoFightButton;

  /// 目标名称
  String? _targetName;

  @override
  void initState() {
    super.initState();
    _playerSprite = GameManager.playerSprite;

    _autoFightButton = DFCheckButton(
      /// text: "自动战斗",
      value: 1,
      image: "assets/images/ui/auto_off.png",
      checkedImage: "assets/images/ui/auto_on.png",
      size: Size(40, 40),
      onChanged: (DFCheckButton button, bool checked, int value) {
        if (checked) {
          _playerSprite?.startAutoFight(DFAction.CASTING, effect: EffectData.newEffectInfo(template: "2001"));
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
              _autoFightButton!.setChecked(false);
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
                image: EffectData.getIcon("1001"),
                size: Size(70, 70),
                onPressed: (button) {
                  _playerSprite?.cancelAutoFight();
                  _autoFightButton!.setChecked(false);
                  _playerSprite?.moveToAction(DFAction.ATTACK, effect: EffectData.newEffectInfo(template: "1001"));
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
                image: EffectData.getIcon("1002"),
                size: Size(50, 50),
                onPressed: (button) {
                  _playerSprite?.cancelAutoFight();
                  _autoFightButton!.setChecked(false);
                  _playerSprite?.moveToAction(DFAction.ATTACK, effect: EffectData.newEffectInfo(template: "1002"));
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
                image: EffectData.getIcon("2001"),
                size: Size(50, 50),
                onPressed: (button) {
                  _playerSprite?.cancelAutoFight();
                  _autoFightButton!.setChecked(false);
                  _playerSprite?.moveToAction(DFAction.CASTING, effect: EffectData.newEffectInfo(template: "2001"));
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
                image: EffectData.getIcon("3001"),
                size: Size(50, 50),
                onPressed: (button) {
                  _playerSprite?.cancelAutoFight();
                  _autoFightButton!.setChecked(false);
                  _playerSprite?.moveToAction(DFAction.CASTING, effect: EffectData.newEffectInfo(template: "3001"));
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
                image: EffectData.getIcon("3002"),
                size: Size(50, 50),
                onPressed: (button) {
                  _playerSprite?.cancelAutoFight();
                  _autoFightButton!.setChecked(false);
                  _playerSprite?.moveToAction(DFAction.CASTING, effect: EffectData.newEffectInfo(template: "3002"));
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
              _playerSprite?.cancelAutoFight();
              _autoFightButton!.setChecked(false);
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
            size: Size(36, 36),
            onPressed: (button) {
                _playerSprite?.cancelAutoFight();
                _autoFightButton!.setChecked(false);
                _playerSprite?.moveToAction(DFAction.PICKUP);
            },
          ),
        ),

        /// 查看目标
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          right: 180,
          child: DFButton(
            /// text: "目标",
            image: "assets/images/ui/skill_select.png",
            size: Size(40, 40),
            onPressed: (button) {
              if (_playerSprite?.targetSprite == null) {
                setState(() {
                  _targetName = "没有选择目标";
                });
              } else {
                if (_playerSprite?.targetSprite is MonsterSprite) {
                  MonsterSprite targetSprite = _playerSprite?.targetSprite as MonsterSprite;
                  setState(() {
                    _targetName = targetSprite.monster.name;
                  });
                } else if (_playerSprite?.targetSprite is PlayerSprite) {
                  PlayerSprite targetSprite = _playerSprite?.targetSprite as PlayerSprite;
                  setState(() {
                    _targetName = targetSprite.player.name;
                  });
                } else if (_playerSprite?.targetSprite is ItemSprite) {
                  ItemSprite targetSprite = _playerSprite?.targetSprite as ItemSprite;
                  setState(() {
                    _targetName = targetSprite.item.name;
                  });
                }
              }
            },
          ),
        ),

        /// 目标信息
        _targetName != null
            ? Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 60,
                right: 220,
                child: Container(
                  height: 20,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10),
                    color: Color(0x90000000)
                  ),
                  child: Text(
                    "当前目标：" + _targetName!,
                    style: TextStyle(
                      fontSize: 8,
                      color: Color(0xFF1d953f),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            : Container(),

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
                size: Size(48, 48),
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
                  size: Size(48, 48),
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
