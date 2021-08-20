import 'package:devilf_engine/widget/df_button.dart';
import 'package:example/model/item_info.dart';
import 'package:example/player/player_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../game_manager.dart';

/// 物品界面
class ItemLayer extends StatefulWidget {
  final Size size;
  final ItemInfo item;
  Function? onRefresh;

  ItemLayer(this.item, {this.size = const Size(100, 100),this.onRefresh});

  @override
  _ItemLayerState createState() => _ItemLayerState();
}

class _ItemLayerState extends State<ItemLayer> {
  double _width = 0;
  double _height = 0;
  double _scale = 1;
  late PlayerInfo _playerInfo;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    this._width = GameManager.visibleWidth * 0.25;
    this._scale = this._width / 402;
    this._height = 530 * this._scale;

    _playerInfo = GameManager.playerSprite!.player;
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

    setState(() {

    });

    if(widget.onRefresh != null){
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

    setState(() {

    });

    if(widget.onRefresh != null){
      widget.onRefresh!();
    }
  }

  Widget _getPropertyItem(String label, String text) {
    return Container(
      width: this._width,
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
              height: this._height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage("assets/images/ui/bg_03.png"),
                ),
              ),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  /// 标题
                  Positioned(
                    top: 5 * this._scale,
                    width: this._width,
                    child: Center(
                      child: Text(
                        widget.item.name,
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
                    top: 45 * this._scale,
                    left: 0,
                    bottom: 0,
                    width: this._width,
                    child: Container(
                      color: Color(0x80000000),
                      margin: EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        reverse: false,
                        controller: _controller,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _getPropertyItem("类别：", ItemType.getName(widget.item.type)),
                            _getPropertyItem("生命：", widget.item.hp.toString()),
                            _getPropertyItem("魔法：", widget.item.mp.toString()),
                            _getPropertyItem("物攻：", widget.item.minAt.toString() + "-" + _playerInfo.maxAt.toString()),
                            _getPropertyItem("魔攻：", widget.item.minMt.toString() + "-" + _playerInfo.maxMt.toString()),
                            _getPropertyItem("物防：", widget.item.minDf.toString() + "-" + _playerInfo.maxDf.toString()),
                            _getPropertyItem("魔防：", widget.item.minMf.toString() + "-" + _playerInfo.maxMf.toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
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
                      size: Size(36, 36),
                      onPressed: (button) {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    left: 2,
                    bottom: 0,
                    child: Column(
                      children: [
                        widget.item.isDressed
                            ? DFButton(
                                text: "卸下",
                                image: "assets/images/ui/btn_01.png",
                                pressedImage: "assets/images/ui/btn_02.png",
                                size: Size(60, 36),
                                onPressed: (button) {
                                  _onTakeOffClick(widget.item);
                                },
                              )
                            : DFButton(
                                text: "装备",
                                image: "assets/images/ui/btn_01.png",
                                pressedImage: "assets/images/ui/btn_02.png",
                                size: Size(60, 36),
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
