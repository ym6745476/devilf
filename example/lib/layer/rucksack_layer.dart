import 'package:devilf_engine/widget/df_button.dart';
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
  @override
  void initState() {
    super.initState();
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
            margin: EdgeInsets.only(top: 0,left:18),
            width: GameManager.visibleWidth * 0.70,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage("assets/images/ui/bg_01.png"),
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              child: Text("1111111111111111111111111111"),
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
