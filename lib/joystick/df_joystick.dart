
import 'dart:math';

import 'package:flutter/material.dart';

class DFJoyStick extends StatefulWidget{

  final Size size;
  final void Function(Offset) onChange;

  const DFJoyStick({
    required this.onChange,
    this.size = const Size(100,100),
  });

  @override
  State<StatefulWidget> createState() => DFJoyStickState();

}

class DFJoyStickState extends State<DFJoyStick> {

  /// 偏移量
  Offset delta = Offset.zero;

  /// 更新位置
  void updateDelta(Offset newD){
    widget.onChange(newD);
    setState(() {
      delta = newD;
    });
  }

  void calculateDelta(Offset offset){
    Offset newD = offset - Offset(widget.size.width/2,widget.size.height/2);
    updateDelta(Offset.fromDirection(newD.direction,min(widget.size.width/4, newD.distance)));//活动范围控制在bgSize之内
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size.width/2)
        ),
        child: GestureDetector(

          /// 摇杆背景
          child: Container(
            decoration: BoxDecoration(
              color: Color(0x88ffffff),
              borderRadius: BorderRadius.circular(widget.size.width/2),
            ),
            child: Center(
              child: Transform.translate(offset: delta,

                /// 摇杆
                child: SizedBox(
                  width: widget.size.width/2,
                  height: widget.size.height/2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xccffffff),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),),
            ),
          ),
          onPanDown: onDragDown,
          onPanUpdate: onDragUpdate,
          onPanEnd: onDragEnd,
        ),
      ),
    );
  }

  void onDragDown(DragDownDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragUpdate(DragUpdateDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragEnd(DragEndDetails d) {
    updateDelta(Offset.zero);
  }
}