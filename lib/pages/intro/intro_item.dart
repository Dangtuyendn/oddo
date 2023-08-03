import 'package:flutter/material.dart';
import '../../common/styles.dart';
import '../../common/tools.dart';

class IntroItem extends StatelessWidget {
  final String image;
  final String largeText;
  final String smallText;

  const IntroItem(
      {Key? key,
      required this.image,
      required this.largeText,
      required this.smallText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(flex: 2, child: Tools.svgAsset(image)),
        Expanded(
            flex: 1,
            child: Column(children: <Widget>[
              Text(largeText,
                  style: const TextStyle(
                      color: Styles.lightTextColor,
                      fontSize: Styles.f26,
                      fontWeight: Styles.mediumFontWeight)),
              const SizedBox(height: 5.0),
              Text(smallText,
                  style: const TextStyle(
                      color: Styles.lightTextColor,
                      fontSize: Styles.f14,
                      fontWeight: Styles.lightFontWeight))
            ]))
      ],
    );
  }
}
