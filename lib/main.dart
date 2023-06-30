import 'package:flutter/material.dart';
import 'package:smarttrashcan/screens/url_screen.dart';
import 'package:smarttrashcan/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map for TrashBin',
      theme: ThemeData(
        fontFamily: 'IranSans',
        scaffoldBackgroundColor: AppTheme.scaffoldBackgroundColor,
        primaryColor: AppTheme.primaryColor,
        primarySwatch: AppTheme.primarySwatch,
        colorScheme: AppTheme.colorScheme,
        iconTheme: const IconThemeData(
          color: AppTheme.iconColor,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppTheme.primaryColor,
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              AppTheme.primaryColor,
            ),
            textStyle: MaterialStatePropertyAll(
              TextStyle(
                color: AppTheme.white,
              ),
            ),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const URLScreen(),
    );
  }
}
