import 'package:devilf_engine/widget/df_button.dart';
import 'package:example/item/item_info.dart';
import 'package:example/player/player_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../game_manager.dart';

/// 物品界面
class ItemLayer extends StatefulWidget {
  final Size size;
  final ItemInfo item;
  Function? onRefresh;

  ItemLayer(this.item, {this.size = const Size(100, 100), this.onRefresh});

  @override
  _ItemLayerState createState() => _ItemLayerState();
}

class _ItemLayerState extends State<ItemLayer> {
  double _width = 0;
  double _height = 0;
  double _scale = 1;
  late PlayerInfo _playerInfo;
  bool canDress = true;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    this._width = GameManager.visibleWidth * 0.25;
    this._scale = this._width / 402;
    this._height = 530 * this._scale;

    _playerInfo = GameManager.playerSprite!.player;

    if(widget.item.type == ItemType.COIN || widget.item.type == ItemType.POTION){
      canDress = false;
    }

  }

  void _onTakeOnClick(ItemInfo item) {
    if (item.type == ItemType.CLOTHES) {
      if (_playerInfo.clothes != null) {
        _playerInfo.clothes!.isDressed = false;
      }
      item.isDressed = true;
      GameManager.playerSprite!.changeClothes(item);
    } else if (item.type == ItemType.WEAPON) {
      if (_playerInfo.weapon != null) {
        _playerInfo.weapon!.isDressed = false;
      }
      item.isDressed = true;
      GameManager.playerSprite!.changeWeapon(item);
    } else {}

    setState(() {});

    if (widget.onRefresh != null) {
      widget.onRefresh!();
    }
  }

  void _onTakeOffClick(ItemInfo item) {
    String type = item.type;
    if (type == ItemType.WEAPON) {
      if (_playerInfo.weapon != null) {
        /// 卸下武器
        item.isDressed = false;
        GameManager.playerSprite!.removeWeapon();
      }
    } else if (type == ItemType.CLOTHES) {
      if (_playerInfo.clothes != null) {
        /// 卸下衣服
        item.isDressed = false;
        GameManager.playerSprite!.removeClothes();
      }
    }

    setState(() {});

    if (widget.onRefresh != null) {
      widget.onRefresh!();
    }
  }

  Widget _getPropertyItem(String label, String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.only(left: 20 * this._scale, top: 10 * this._scale, bottom: 10 * this._scale),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 24 * this._scale,
              color: Color(0xFFad8b3d),
              shadows: [Shadow(color: Color(0xFF222222), offset: Offset(0.5, 0.5), blurRadius: 0.2)],
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 24 * this._scale,
              color: Color(0xFFa1a3a6),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
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
              width: this._width,
              height: this._height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/ui/bg_03.png"),
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
                    height: 36 * this._scale,
                    margin: EdgeInsets.only(
                      top: 7 * this._scale,
                    ),
                    /*color: Color(0x30FFFFFF),*/
                    child: Text(
                      widget.item.name,
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
                    width: this._width,
                    height: this._height - 50 * this._scale,
                    child: Container(
                      color: Color(0x80000000),
                      margin: EdgeInsets.all(16 * this._scale),
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        reverse: false,
                        controller: _controller,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100 * this._scale,
                                  height: 100 * this._scale,
                                  margin: EdgeInsets.all(10 * this._scale),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/ui/equip_bg.png"),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 100 * this._scale,
                                    height: 100 * this._scale,
                                    decoration: widget.item.icon != null
                                        ? BoxDecoration(
                                            image: DecorationImage(
                                            image: AssetImage("assets/images/ui/border_01.png"),
                                          ))
                                        : BoxDecoration(),
                                    alignment: Alignment.center,
                                    child: DFButton(
                                      image: widget.item.icon,
                                      size: Size(60 * this._scale, 60 * this._scale),
                                      textColor: Color(0xFFc37e00),
                                      fontSize: 22 * this._scale,
                                      onPressed: (button) {},
                                    ),
                                  ),
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      _getPropertyItem(
                                          "类别：", ItemType.getName(widget.item.type), this._width - 160 * this._scale),
                                      _getPropertyItem("职业：", "通用", this._width - 160 * this._scale),
                                    ]),
                              ],
                            ),
                            _getPropertyItem("生命：", widget.item.hp.toString(), this._width),
                            _getPropertyItem("魔法：", widget.item.mp.toString(), this._width),
                            _getPropertyItem(
                                "物攻：", widget.item.minAt.toString() + " - " + _playerInfo.maxAt.toString(), this._width),
                            _getPropertyItem(
                                "魔攻：", widget.item.minMt.toString() + " - " + _playerInfo.maxMt.toString(), this._width),
                            _getPropertyItem(
                                "物防：", widget.item.minDf.toString() + " - " + _playerInfo.maxDf.toString(), this._width),
                            _getPropertyItem(
                                "魔防：", widget.item.minMf.toString() + " - " + _playerInfo.maxMf.toString(), this._width),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 200 * this._scale,
              height: this._height,
              margin: EdgeInsets.only(top: 0),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: DFButton(
                      /// text: "关闭",
                      image: "assets/images/ui/btn_close_03.png",
                      size: Size(72 * this._scale, 72 * this._scale),
                      onPressed: (button) {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    left: 10 * this._scale,
                    bottom: 0,
                    child: Column(
                      children: [
                        widget.item.isDressed && canDress
                            ? DFButton(
                                text: "卸下",
                                fontSize: 28 * this._scale,
                                image: "assets/images/ui/btn_01.png",
                                pressedImage: "assets/images/ui/btn_02.png",
                                size: Size(120 * this._scale, 72 * this._scale),
                                onPressed: (button) {
                                  _onTakeOffClick(widget.item);
                                },
                              )
                            : DFButton(
                                text: "装备",
                                fontSize: 28 * this._scale,
                                image: "assets/images/ui/btn_01.png",
                                pressedImage: "assets/images/ui/btn_02.png",
                                size: Size(120 * this._scale, 72 * this._scale),
                                onPressed: (button) {
                                  _onTakeOnClick(widget.item);
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
