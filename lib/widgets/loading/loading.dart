import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:smarttrashcan/theme/theme.dart';

class ButtonLoading extends StatelessWidget {
  const ButtonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingFadingLine.circle(
      backgroundColor: AppTheme.iconColor,
      size: 20,
    );
  }
}
