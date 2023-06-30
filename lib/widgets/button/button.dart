import 'package:flutter/material.dart';
import 'package:smarttrashcan/constants/enums.dart';
import 'package:smarttrashcan/theme/theme.dart';
import 'package:smarttrashcan/widgets/text/AppText.dart';

class AppButtons extends StatelessWidget {
  const AppButtons({
    super.key,
    this.height,
    this.width,
    this.padding,
    this.style,
    this.align = MainAxisAlignment.center,
    this.child,
    this.color,
    this.textColor,
    this.iconcolor,
    this.borderColor,
    this.borderRadius,
    this.border = false,
    this.icon,
    this.iconsize,
    this.text,
    this.textSize,
    this.weight,
    this.space,
    this.onTap,
  });

  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment align;
  final ButtonStyle? style;
  final Widget? child;
  final Color? color;
  final Color? textColor;
  final Color? iconcolor;
  final Color? borderColor;
  final double? iconsize;
  final double? borderRadius;
  final bool border;
  final IconData? icon;
  final String? text;
  final AppTextFontWeight? weight;
  final AppTextFontSize? textSize;
  final double? space;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: child ??
              AppText(
                text: text,
                weight: weight ?? AppTextFontWeight.bold,
                size: textSize ?? AppTextFontSize.xLarge,
                textColor: textColor ?? AppTheme.textColor,
              ),
        ),
      ),
    );
  }
}
