import 'package:devilf_engine/util/df_ui_util.dart';
import 'package:devilf_engine/widget/df_button.dart';
import 'package:example/data/item_data.dart';
import 'package:example/model/item_info.dart';
import 'package:example/player/player_info.dart';
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

    this._containerWidth = this._width - 130 * this._scale;
    this._containerHeight = 520 * this._scale;
    _playerInfo = GameManager.playerSprite!.player;
  }

  List<Widget> _getItemList() {
    double itemWidth = (this._containerWidth - 16 - 5 * 8) / 9;
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
            padding: EdgeInsets.all(5),
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
                        "背包",
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
                    width: this._containerWidth,
                    height: this._containerHeight,
                    child: Container(
                      /*color: Color(0xFFFFFFFF),*/
                      margin: EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        reverse: false,
                        controller: _controller,
                        child: Wrap(spacing: 5, runSpacing: 5, children: _getItemList()),
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
