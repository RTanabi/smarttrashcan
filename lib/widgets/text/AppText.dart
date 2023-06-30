import 'package:flutter/material.dart';

import '../../constants/enums.dart';

const Map<String, double> _FONT_SIZES = {
  'xxSmall': 6.0, // 3x small
  'xSmall': 8.0, // 2x small
  'small': 10.0, // s
  'normal': 12.0, // normal
  'medium': 14.0, // medium
  'large': 16.0, // 1x large
  'xLarge': 18.0, // 2x large
  'xxLarge': 20.0, // 3x large
};

const Map<String, FontWeight> _FONT_WEIGHT = {
  'ultraLight': FontWeight.w300, // 2x light
  'light': FontWeight.w400, // light
  'medium': FontWeight.w500, // medium
  'bold': FontWeight.w700, // bold
  'heavy': FontWeight.w900, // 2x bold
};

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    @required this.text,
    this.size = AppTextFontSize.small,
    this.weight = AppTextFontWeight.light,
    this.style,
    this.align = TextAlign.start,
    this.textColor,
    this.softWrap,
    this.overflow,
    this.maxLines,
  });

  final text;
  final AppTextFontSize size;
  final AppTextFontWeight weight;
  final TextStyle? style;
  final TextAlign align;
  final Color? textColor;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;

  static double? fontSize(AppTextFontSize size) =>
      _FONT_SIZES[size.toString().split('.').last];
  static FontWeight? fontWeight(AppTextFontWeight weight) =>
      _FONT_WEIGHT[weight.toString().split('.').last];

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize(size),
        fontWeight: fontWeight(weight),
      ).merge(style),
    );
  }
}
