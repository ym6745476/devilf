import 'package:devilf_engine/core/df_position.dart';
import 'package:devilf_engine/widget/df_button.dart';
import 'package:example/data/effect_data.dart';
import 'package:example/data/item_data.dart';
import 'package:example/model/item_info.dart';
import 'package:example/player/player_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../game_manager.dart';

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

    _items.add(ItemInfo(1, "武器", icon: "", type: ItemType.WEAPON));
    _items.add(ItemInfo(2, "衣服", icon: "", type: ItemType.CLOTHES));
    _items.add(ItemInfo(3, "手镯", icon: "", type: ItemType.BRACELET));
    _items.add(ItemInfo(4, "戒子", icon: "", type: ItemType.RING));
    _items.add(ItemInfo(5, "腰带", icon: "", type: ItemType.BELT));

    _items.add(ItemInfo(6, "头盔", icon: "", type: ItemType.HELMET));
    _items.add(ItemInfo(7, "项链", icon: "", type: ItemType.NECKLACE));
    _items.add(ItemInfo(8, "手镯", icon: "", type: ItemType.BRACELET));
    _items.add(ItemInfo(9, "戒子", icon: "", type: ItemType.RING));
    _items.add(ItemInfo(10, "靴子", icon: "", type: ItemType.BOOTS));

    _items.add(ItemInfo(11, "勋章", icon: "", type: ItemType.MEDAL));
    _items.add(ItemInfo(12, "宝石", icon: "", type: ItemType.GEMSTONE));
    _items.add(ItemInfo(13, "特技", icon: "", type: ItemType.SKILL));
    _items.add(ItemInfo(14, "宠物", icon: "", type: ItemType.PET));

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

  Widget _getCharacter() {
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

  Widget _getProperty() {
    return Container(
      width: this._containerWidth * 0.35 - 26,
      height: this._containerHeight,
      color: Color(0xFF000000),
      child: Stack(
        children: [
          /*Positioned(
            left:0,
            top: 0,
            width: 320 * this._scale,
            height: 400 * this._scale,
            child: Image.asset(
              _playerInfo.clothes!.show!,
              fit: BoxFit.fitHeight,
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _getEquipItem(int index) {
    String? itemIcon;
    if (index == 0 && _playerInfo.weapon != null) {
      itemIcon = _playerInfo.weapon!.icon!;
    } else if (index == 1 && _playerInfo.clothes != null) {
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
              text: itemIcon != null ? null : _items[index].name,
              image: itemIcon,
              size: Size(30, 30),
              textColor: Color(0xFFc37e00),
              fontSize: 12,
              onPressed: (button) {
                _onItemClick(_items[index]);
              },
            ),
          ),
        ));
  }

  void _onItemClick(ItemInfo item) {
    ItemType type = item.type;
    if (type == ItemType.WEAPON) {
      if(_playerInfo.weapon != null){
        /// 卸下武器
        GameManager.items.add(_playerInfo.weapon!);
        GameManager.playerSprite!.removeWeapon();

      }

    } else if (type == ItemType.CLOTHES) {
      if(_playerInfo.clothes != null) {
        /// 卸下衣服
        GameManager.items.add(_playerInfo.clothes!);
        GameManager.playerSprite!.removeClothes();

      }
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GameManager.visibleWidth,
      height: GameManager.visibleHeight,
      decoration: BoxDecoration(color: Color(0x60000000)),
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
                          child: _getCharacter(),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: _getProperty(),
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
    );
  }
}
