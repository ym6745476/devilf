import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 按钮
class DFButton extends StatefulWidget {
  final String? text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  final Size size;
  final String image;
  final String? pressedImage;
  final void Function(DFButton button) onPressed;

  Function setSelected = (bool selected) {
    print("DFButton setSelected:" + selected.toString());
  };

  DFButton({
    this.text,
    this.fontSize = 14,
    this.textColor = const Color(0xFFFFFFFF),
    this.fontWeight = FontWeight.normal,
    this.size = const Size(80, 80),
    required this.image,
    this.pressedImage,
    required this.onPressed,
  });

  @override
  _DFButtonState createState() => _DFButtonState();
}

class _DFButtonState extends State<DFButton> {
  Color? _color;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    widget.setSelected = this.setSelected;
  }

  void setSelected(bool selected) {
    print("setSelected:" + selected.toString());
    setState(() {
      _isSelected = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: GestureDetector(
          onTap: () {
            widget.onPressed(widget);
          },
          onTapDown: (detail) {
            setState(() {
              this._color = Colors.black54;
            });
          },
          onTapCancel: () {
            setState(() {
              this._color = null;
            });
          },
          onTapUp: (detail) {
            setState(() {
              this._color = null;
            });
          },
          child: Stack(fit: StackFit.expand, children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                child: Image.asset(
                  (_isSelected && widget.pressedImage != null) ? widget.pressedImage! : widget.image,
                  fit: BoxFit.fill,
                  width: widget.size.width,
                  height: widget.size.height,
                  color: this._color,
                  colorBlendMode: BlendMode.dstIn,
                ),
              ),
            ),
            widget.text != null
                ? Positioned(
                    top: 0,
                    left: 0,
                    width: widget.size.width,
                    height: widget.size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.text!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: widget.fontSize,
                            fontWeight: widget.fontWeight,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ]),
        ));
  }
}
