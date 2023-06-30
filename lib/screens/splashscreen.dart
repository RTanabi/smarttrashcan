import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttrashcan/constants/app_constants.dart';
import 'package:smarttrashcan/constants/enums.dart';
import 'package:smarttrashcan/screens/auth/login.dart';
import 'package:smarttrashcan/screens/home/main_screen.dart';
import 'package:smarttrashcan/theme/theme.dart';
import 'package:smarttrashcan/widgets/text/AppText.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String token = '';
  String name = '';
  String phone = '';

  chekToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('token')) {
        String _token = prefs.getString('token')!;
        setState(() {
          token = _token;
          User.token = token;
        });
      }
      if (prefs.containsKey('name')) {
        String _name = prefs.getString('name')!;
        setState(() {
          name = _name;
          User.name = name;
        });
      }
      if (prefs.containsKey('phone')) {
        String _phone = prefs.getString('phone')!;
        setState(() {
          phone = _phone;
          User.phone = phone;
        });
      }
      print("${User.name} ${User.phone}");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    chekToken();
    Timer(
      const Duration(seconds: 2),
      () {
        if (token.isEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Padding(
        padding: AppConstants.padding,
        child: Stack(
          textDirection: TextDirection.rtl,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //icon
                  Lottie.asset(
                    'assets/lottie/trash3.json',
                    filterQuality: FilterQuality.high,
                    height: 200,
                    width: 200,
                    fit: BoxFit.fill,
                    repeat: false,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  //text
                  const AppText(
                    text: AppConstants.appName,
                    size: AppTextFontSize.xxLarge,
                    weight: AppTextFontWeight.bold,
                    textColor: AppTheme.white,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: LoadingJumpingLine.circle(
                backgroundColor: Colors.white70,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
