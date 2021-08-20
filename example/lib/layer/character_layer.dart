import 'package:devilf_engine/core/df_position.dart';
import 'package:devilf_engine/util/df_ui_util.dart';
import 'package:devilf_engine/widget/df_button.dart';
import 'package:example/data/effect_data.dart';
import 'package:example/data/item_data.dart';
import 'package:example/data/job_data.dart';
import 'package:example/model/item_info.dart';
import 'package:example/player/player_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../game_manager.dart';
import 'item_layer.dart';

/// 人物界面
class CharacterLayer extends StatefulWidget {
  final Size size;

  CharacterLayer({this.size = const Size(100, 100)});

  @override
  _CharacterLayerState createState() => _CharacterLayerState();
}

class _CharacterLayerState extends State<CharacterLayer> {
  double _width = 0;
  double _scale = 1;
  double _containerWidth = 0;
  double _containerHeight = 0;
  List<ItemInfo> _items = [];
  List<DFPosition> _itemsPosition = [];
  late PlayerInfo _playerInfo;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    this._width = GameManager.visibleWidth * 0.70;
    this._scale = this._width / 1031;
    this._containerWidth = this._width - 130 * this._scale;
    this._containerHeight = 520 * this._scale;

    _playerInfo = GameManager.playerSprite!.player;

    _items.add(ItemInfo(1, type: ItemType.WEAPON));
    _items.add(ItemInfo(2, type: ItemType.CLOTHES));
    _items.add(ItemInfo(3, type: ItemType.BRACELET));
    _items.add(ItemInfo(4, type: ItemType.RING));
    _items.add(ItemInfo(5, type: ItemType.BELT));

    _items.add(ItemInfo(6, type: ItemType.HELMET));
    _items.add(ItemInfo(7, type: ItemType.NECKLACE));
    _items.add(ItemInfo(8, type: ItemType.BRACELET));
    _items.add(ItemInfo(9, type: ItemType.RING));
    _items.add(ItemInfo(10, type: ItemType.BOOTS));

    _items.add(ItemInfo(11, type: ItemType.MEDAL));
    _items.add(ItemInfo(12, type: ItemType.GEMSTONE));
    _items.add(ItemInfo(13, type: ItemType.SKILL));
    _items.add(ItemInfo(14, type: ItemType.PET));

    double bottom = this._containerHeight - 65;

    _itemsPosition.add(DFPosition(10, bottom - 200));
    _itemsPosition.add(DFPosition(10, bottom - 150));
    _itemsPosition.add(DFPosition(10, bottom - 100));
    _itemsPosition.add(DFPosition(10, bottom - 50));
    _itemsPosition.add(DFPosition(10, bottom));

    double right = this._containerWidth * 0.65 - 60;
    _itemsPosition.add(DFPosition(right, bottom - 200));
    _itemsPosition.add(DFPosition(right, bottom - 150));
    _itemsPosition.add(DFPosition(right, bottom - 100));
    _itemsPosition.add(DFPosition(right, bottom - 50));
    _itemsPosition.add(DFPosition(right, bottom));

    _itemsPosition.add(DFPosition(10 + 50, bottom));
    _itemsPosition.add(DFPosition(10 + 50 + 50, bottom));
    _itemsPosition.add(DFPosition(right - 50 - 50, bottom));
    _itemsPosition.add(DFPosition(right - 50, bottom));
  }

  Widget _getCharacterWidget() {
    return Container(
      width: this._containerWidth * 0.65,
      height: this._containerHeight,
      decoration: BoxDecoration(
        color: Color(0xFF000000),
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage("assets/images/ui/bg_character.png"),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            top: 0,
            width: this._containerWidth * 0.65,
            height: this._containerHeight,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 100 * this._scale),
              child: Image.asset(
                _playerInfo.clothes!.show!,
                fit: BoxFit.fitHeight,
                width: 256 * this._scale,
                height: 320 * this._scale,
              ),
            ),
          ),
          Positioned(
            left: 85 * this._scale,
            top: 20 * this._scale,
            child: _playerInfo.weapon != null
                ? Container(
                    child: Image.asset(
                      _playerInfo.weapon!.show!,
                      fit: BoxFit.fitHeight,
                      width: 256 * this._scale,
                      height: 352 * this._scale,
                    ),
                  )
                : Container(),
          ),
          _getEquipItem(0),
          _getEquipItem(1),
          _getEquipItem(2),
          _getEquipItem(3),
          _getEquipItem(4),
          _getEquipItem(5),
          _getEquipItem(6),
          _getEquipItem(7),
          _getEquipItem(8),
          _getEquipItem(9),
          _getEquipItem(10),
          _getEquipItem(11),
          _getEquipItem(12),
          _getEquipItem(13),
        ],
      ),
    );
  }

  Widget _getPropertyWidget() {
    double width = this._containerWidth * 0.35 - 26;
    return Container(
      width: width,
      height: this._containerHeight,
      color: Color(0xFF060606),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width,
            padding: EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage("assets/images/ui/power_bg.png"),
              ),
            ),
            child: Center(
              child: Text(
                "战斗力：" + _playerInfo.battle.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFFffc20e),
                  shadows: [Shadow(color: Color(0xFF222222), offset: Offset(0.5, 0.5), blurRadius: 0.2)],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: width,
            height: this._containerHeight - 100 * this._scale,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _getPropertyItem("等级：", _playerInfo.level.toString()),
                  _getPropertyItem("职业：", JobData.items[_playerInfo.job.toString()]!),
                  _getPropertyItem("生命：", _playerInfo.hp.toString() + "/" + _playerInfo.maxHp.toString()),
                  _getPropertyItem("魔法：", _playerInfo.mp.toString() + "/" + _playerInfo.maxMp.toString()),
                  _getPropertyItem("经验：", _playerInfo.exp.toString()),
                  _getPropertyItem("物攻：", _playerInfo.minAt.toString() + "-" + _playerInfo.maxAt.toString()),
                  _getPropertyItem("魔攻：", _playerInfo.minMt.toString() + "-" + _playerInfo.maxMt.toString()),
                  _getPropertyItem("物防：", _playerInfo.minDf.toString() + "-" + _playerInfo.maxDf.toString()),
                  _getPropertyItem("魔防：", _playerInfo.minMf.toString() + " -" + _playerInfo.maxMf.toString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEquipItem(int index) {
    String? itemIcon;
    ItemInfo item = _items[index];
    if (index == 0 && _playerInfo.weapon != null) {
      item = _playerInfo.weapon!;
      itemIcon = _playerInfo.weapon!.icon!;
    } else if (index == 1 && _playerInfo.clothes != null) {
      item = _playerInfo.clothes!;
      itemIcon = _playerInfo.clothes!.icon!;
    }
    return Positioned(
        top: _itemsPosition[index].y,
        left: _itemsPosition[index].x,
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/ui/equip_bg.png"),
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 45,
            height: 45,
            decoration: itemIcon != null
                ? BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage("assets/images/ui/border_01.png"),
                  ))
                : BoxDecoration(),
            alignment: Alignment.center,
            child: DFButton(
              text: itemIcon != null ? null : ItemType.getName(_items[index].type),
              image: itemIcon,
              size: Size(30, 30),
              textColor: Color(0xFFc37e00),
              fontSize: 12,
              onPressed: (button) {
                _onItemClick(item);
              },
            ),
          ),
        ));
  }

  Widget _getPropertyItem(String label, String text) {
    return Container(
      width: this._containerWidth * 0.35 - 26,
      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFad8b3d),
              shadows: [Shadow(color: Color(0xFF222222), offset: Offset(0.5, 0.5), blurRadius: 0.2)],
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFa1a3a6),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _onItemClick(ItemInfo item) {
    DFUiUtil.showLayer(context,
        ItemLayer(item,onRefresh: (){
           setState(() {});
        },)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GameManager.visibleWidth,
      height: GameManager.visibleHeight,
      decoration: BoxDecoration(color: Color(0x60000000)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 0, left: 18),
              width: this._width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/ui/bg_01.png"),
                ),
              ),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  /// 标题
                  Positioned(
                    top: 60 * this._scale,
                    width: this._width,
                    child: Center(
                      child: Text(
                        "角色",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFc37e00),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  /// 内容
                  Positioned(
                    top: 114 * this._scale,
                    left: 66 * this._scale,
                    width: _containerWidth,
                    height: _containerHeight,
                    child: Container(
                      /*color: Color(0xFFFFFFFF),*/
                      margin: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: _getCharacterWidget(),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: _getPropertyWidget(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: DFButton(
                /// text: "关闭",
                image: "assets/images/ui/btn_close_01.png",
                size: Size(36, 36),
                onPressed: (button) {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
