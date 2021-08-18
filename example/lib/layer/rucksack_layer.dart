import 'package:devilf_engine/widget/df_button.dart';
import 'package:example/data/item_data.dart';
import 'package:example/model/item_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../game_manager.dart';

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
  ScrollController _controller = ScrollController();
  List<ItemInfo> _items = [];

  @override
  void initState() {
    super.initState();

    this._width = GameManager.visibleWidth * 0.70;
    this._scale = this._width / 1031;

    ItemData.items.forEach((key, value) {
      _items.add(ItemData.newItemInfo(key));
    });

  }

  List<Widget> _getItemList() {
    double itemWidth = (this._width - 146 * this._scale - 50)/10;
    List<Widget> list = [];
    _items.forEach((item) {
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
            onTap: (){
              print("点击：" + item.name);
              if(item.type == ItemType.CLOTHES){
                GameManager.playerSprite!.changeClothes(item);
              }else if(item.type == ItemType.WEAPON){
                GameManager.playerSprite!.changeWeapon(item);
              }else{

              }
            },
          ),
        ),
      ));
    });
    return list;
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
                  top: 118 * this._scale,
                  left:69 * this._scale,
                  width: this._width - 146 * this._scale,
                  height: 504 * this._scale,
                  child: Container(
                    /*color: Color(0xFF3e4145),*/
                    child:  CustomScrollView(
                        physics: ClampingScrollPhysics(),
                        reverse: false,
                        controller: _controller,
                        slivers: <Widget>[
                          SliverPadding(
                              padding: EdgeInsets.only(left: 5, top:5,right: 0),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate(
                                  <Widget>[
                                    Wrap(spacing: 5, runSpacing: 5, children: _getItemList()),
                                  ],
                                ),
                              )),
                        ]),
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
