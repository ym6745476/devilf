import 'package:devilf_engine/core/df_position.dart';
import 'package:devilf_engine/util/df_ui_util.dart';
import 'package:devilf_engine/widget/df_button.dart';
import 'package:example/item/item_info.dart';
import 'package:example/player/player_info.dart';
import 'package:flutter/material.dart';
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
  double _height = 0;
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
    this._height = 641 * this._scale;
    this._containerWidth = this._width - 126 * this._scale;
    this._containerHeight = 528 * this._scale;

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

    double itemWidth = 80 * this._scale;
    double left = 20 * this._scale;
    double bottom = this._containerHeight - 140 * this._scale;

    double offset = 5 * this._scale;

    _itemsPosition.add(DFPosition(left, bottom - itemWidth * 4 - 4 * offset));
    _itemsPosition.add(DFPosition(left, bottom - itemWidth * 3 - 3 * offset));
    _itemsPosition.add(DFPosition(left, bottom - itemWidth * 2 - 2 * offset));
    _itemsPosition.add(DFPosition(left, bottom - itemWidth - 1 * offset));
    _itemsPosition.add(DFPosition(left, bottom));

    double right = this._containerWidth * 0.60 - 100 * this._scale;
    _itemsPosition.add(DFPosition(right, bottom - itemWidth * 4 - 4 * offset));
    _itemsPosition.add(DFPosition(right, bottom - itemWidth * 3 - 3 * offset));
    _itemsPosition.add(DFPosition(right, bottom - itemWidth * 2 - 2 * offset));
    _itemsPosition.add(DFPosition(right, bottom - itemWidth - 1 * offset));
    _itemsPosition.add(DFPosition(right, bottom));

    _itemsPosition.add(DFPosition(left + itemWidth + 1 * offset, bottom));
    _itemsPosition.add(DFPosition(left + itemWidth * 2 + 2 * offset, bottom));
    _itemsPosition.add(DFPosition(right - itemWidth * 2 + -2 * offset, bottom));
    _itemsPosition.add(DFPosition(right - itemWidth - 1 * offset, bottom));
  }

  Widget _getCharacterWidget() {
    return Container(
      width: this._containerWidth * 0.60,
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
            bottom: 0,
            width: this._containerWidth * 0.60,
            height: this._containerHeight,
            child: Container(
              alignment: Alignment.center,
              child: Image.asset(
                _playerInfo.clothes!.show!,
                fit: BoxFit.fitHeight,
                width: 256 * this._scale,
                height: 320 * this._scale,
              ),
            ),
          ),
          Positioned(
            left: 60 * this._scale,
            bottom: 100 * this._scale,
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

    Map<String,int> property = GameManager.getPropertyIncrease(GameManager.playerSprite!);

    double width = this._containerWidth * 0.40 - 50 * this._scale;
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
            padding: EdgeInsets.only(top: 15 * this._scale, bottom: 10 * this._scale),
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
                  fontSize: 26 * this._scale,
                  color: Color(0xFFffc20e),
                  shadows: [Shadow(color: Color(0xFF222222), offset: Offset(0.5, 0.5), blurRadius: 0.2)],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: width,
            height: this._containerHeight - 105 * this._scale,
            /*color: Color(0x60FFFFFF),*/
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _getPropertyItem("等级：", _playerInfo.level.toString()),
                  _getPropertyItem("职业：", JobType.NAMES[_playerInfo.job]),
                  _getPropertyItem("生命：", _playerInfo.hp.toString() + "/" + (_playerInfo.maxHp + property["maxHp"]!).toString()),
                  _getPropertyItem("魔法：", _playerInfo.mp.toString() + "/" + (_playerInfo.maxMp + property["maxMp"]!).toString()),
                  _getPropertyItem("经验：", _playerInfo.exp.toString()),
                  _getPropertyItem("物攻：", (_playerInfo.minAt + property["minAt"]!).toString() + " - " + (_playerInfo.maxAt + property["maxAt"]!).toString()),
                  _getPropertyItem("魔攻：", (_playerInfo.minMt + property["minMt"]!).toString() + " - " + (_playerInfo.maxAt + property["maxMt"]!).toString()),
                  _getPropertyItem("物防：", (_playerInfo.minDf + property["minDf"]!).toString() + " - " + (_playerInfo.maxAt + property["maxDf"]!).toString()),
                  _getPropertyItem("魔防：", (_playerInfo.minMf + property["minMf"]!).toString() + " - " + (_playerInfo.maxAt + property["maxMf"]!).toString()),
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
          width: 80 * this._scale,
          height: 80 * this._scale,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/ui/equip_bg.png"),
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 80 * this._scale,
            height: 80 * this._scale,
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
              size: Size(60 * this._scale, 60 * this._scale),
              textColor: Color(0xFFc37e00),
              fontSize: 22 * this._scale,
              onPressed: (button) {
                _onItemClick(item);
              },
            ),
          ),
        ));
  }

  Widget _getPropertyItem(String label, String text) {
    return Container(
      width: this._containerWidth * 0.35 - 26 * this._scale,
      padding: EdgeInsets.only(left: 10 * this._scale, top: 5 * this._scale, bottom: 5 * this._scale),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 22 * this._scale,
              color: Color(0xFFad8b3d),
              shadows: [Shadow(color: Color(0xFF222222), offset: Offset(0.5, 0.5), blurRadius: 0.2)],
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 22 * this._scale,
              color: Color(0xFFa1a3a6),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _onItemClick(ItemInfo item) {
    DFUiUtil.showLayer(
        context,
        ItemLayer(
          item,
          onRefresh: () {
            setState(() {});
          },
        ));
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
              margin: EdgeInsets.only(top: 0, left: 0),
              width: this._width,
              height: this._height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/ui/bg_01.png"),
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// 标题
                  Container(
                    width: this._width,
                    height: 40 * this._scale,
                    margin: EdgeInsets.only(
                      top: 22 * this._scale,
                    ),
                    /*color: Color(0xFFFFFFFF),*/
                    child: Text(
                      "角色",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28 * this._scale,
                        color: Color(0xFFc37e00),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  /// 内容
                  Container(
                    width: this._containerWidth,
                    height: this._containerHeight,
                    margin: EdgeInsets.only(
                      top: 15 * this._scale,
                    ),
                    child: Container(
                      /*color: Color(0x60FFFFFF),*/
                      margin: EdgeInsets.all(20 * this._scale),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: _getCharacterWidget(),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10 * this._scale),
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
              margin: EdgeInsets.only(top: 30 * this._scale),
              child: DFButton(
                /// text: "关闭",
                image: "assets/images/ui/btn_close_01.png",
                size: Size(72 * this._scale, 72 * this._scale),
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
