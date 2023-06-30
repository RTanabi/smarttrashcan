import 'package:flutter/material.dart';
import 'package:smarttrashcan/constants/enums.dart';
import 'package:smarttrashcan/theme/theme.dart';
import 'package:smarttrashcan/widgets/text/AppText.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    this.height,
    this.width,
    this.padding,
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
    this.style,
    this.space,
    this.onTap,
  });

  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment align;
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
  final TextStyle? style;
  final double? space;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: padding ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: color ?? AppTheme.black.withOpacity(0.7),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? 10),
          ),
          border: border
              ? Border.all(
                  color: borderColor ?? AppTheme.white,
                  width: 3,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: child ??
            Column(
              mainAxisAlignment: align,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon == null
                    ? Container()
                    : Icon(
                        icon,
                        color: iconcolor ?? AppTheme.iconColorDisable,
                        size: iconsize ?? 25,
                      ),
                icon == null || text == null
                    ? Container()
                    : SizedBox(
                        height: space ?? 6.0,
                      ),
                text == null
                    ? Container()
                    : AppText(
                        text: text,
                        textColor: textColor ?? AppTheme.textColor,
                        size: AppTextFontSize.normal,
                        weight: AppTextFontWeight.bold,
                      ),
              ],
            ),
      ),
    );
  }
}
