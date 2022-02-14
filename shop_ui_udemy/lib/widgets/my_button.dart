import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.child,
    this.width = 60,
    this.height = 30,
    this.color = Colors.amber,
    this.margin = 12.0,
    required this.onPressHandle,
    this.padding = 0,
    this.borderRardius = 12.0,
  }) : super(key: key);

  final Color color;
  final Widget child;
  final double width;
  final double height;
  final Function() onPressHandle;
  final double borderRardius;
  final double padding;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.all(margin),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRardius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(0, 3),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRardius),
          onTap: onPressHandle,
          child: child,
        ),
      ),
    );
  }
}
