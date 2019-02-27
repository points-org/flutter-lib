import 'package:flutter/material.dart';

class HorizontalSpacing extends StatelessWidget {
  final double height;
  final Color color;

  HorizontalSpacing({this.height = 10, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color ?? Colors.transparent,
    );
  }
}

class VerticalSpacing extends StatelessWidget {
  final double width;
  final Color color;

  VerticalSpacing({this.width = 10, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: color ?? Colors.transparent,
    );
  }
}
