import 'package:devilf_engine/util/df_ui_util.dart';
import 'package:devilf_engine/widget/df_button.dart';
import 'package:example/data/item_data.dart';
import 'package:example/item/item_info.dart';
import 'package:example/player/player_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../game_manager.dart';
import 'item_layer.dart';

/// 背包界面
class RucksackLayer extends StatefulWidget {
  final Size size;

  RucksackLayer({this.size = const Size(100, 100)});

  @override
  _RucksackLayerState createState() => _RucksackLayerState();
}

class _RucksackLayerState extends State<RucksackLayer> {
  double _width = 0;
  double _height = 0;
  double _scale = 1;
  double _containerWidth = 0;
  double _containerHeight = 0;
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
  }

  List<Widget> _getItemList() {
    double itemWidth = (this._containerWidth - 30 * this._scale - 10 * this._scale * 9) / 10;
    List<Widget> list = [];
    GameManager.items.forEach((item) {
      if (!item.isDressed) {
        list.add(Container(
          width: itemWidth,
          height: itemWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage("assets/images/ui/item_bg.png"),
            ),
          ),
          child: Container(
            width: itemWidth,
            height: itemWidth,
            padding: EdgeInsets.all(10 * this._scale),
            child: GestureDetector(
              child: Image.asset(
                item.icon!,
                fit: BoxFit.fill,
              ),
              onTap: () {
                print("点击：" + item.name);
                _onItemClick(item);
              },
            ),
          ),
        ));
      }
    });
    return list;
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
              width: this._width,
              height: this._height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
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
                    height:40 * this._scale,
                    margin: EdgeInsets.only(
                      top: 22 * this._scale,
                    ),
                    /*color: Color(0x60FFFFFF),*/
                    child: Text(
                      "背包",
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
                      top: 16 * this._scale,
                    ),
                    child: Container(
                      /*color: Color(0xFF000000),*/
                      margin: EdgeInsets.all(15 * this._scale),
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        reverse: false,
                        controller: _controller,
                        child: Wrap(spacing: 10 * this._scale, runSpacing: 10 * this._scale, children: _getItemList()),
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
