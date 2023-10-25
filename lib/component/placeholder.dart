import 'package:flutter/material.dart';

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.0,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
    );
  }
}

class TextPlaceholder extends StatelessWidget {
  final double width;
  final double row;
  final double height;
  final double spacing;

  const TextPlaceholder({
    Key? key,
    required this.width,
    this.height = 10,
    this.spacing = 0,
    this.row = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    bool addspace = false;
    final space = SizedBox(height: spacing);
    for (int i = 0; i < row; ++i) {
      if (addspace && spacing > 0) {
        children.add(space);
      }
      children.add(Container(
        width: width,
        height: height,
        color: Colors.white,
      ));
      addspace = !addspace;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
