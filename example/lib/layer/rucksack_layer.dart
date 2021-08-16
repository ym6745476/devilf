import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../game_manager.dart';

/// 背包界面
class RucksackLayer extends StatefulWidget {
  RucksackLayer();

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
    return SizedBox(
        width: GameManager.visibleWidth,
        height: GameManager.visibleHeight,
        child: Container(
          decoration: BoxDecoration(color: Color(0x96000000)),
          child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children:[]
          ),
        ));
  }
}
