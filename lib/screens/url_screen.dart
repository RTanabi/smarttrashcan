import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarttrashcan/constants/app_constants.dart';
import 'package:smarttrashcan/constants/enums.dart';
import 'package:smarttrashcan/screens/splashscreen.dart';
import 'package:smarttrashcan/theme/theme.dart';
import 'package:smarttrashcan/widgets/text/AppText.dart';

class URLScreen extends StatefulWidget {
  const URLScreen({super.key});

  @override
  State<URLScreen> createState() => _URLScreenState();
}

class _URLScreenState extends State<URLScreen> {
  String url = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Padding(
          padding: AppConstants.padding,
          child: Stack(
            textDirection: TextDirection.rtl,
            children: [
              Center(
                child: SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        text: "محل وارد کردن url برای اتصال به سرور",
                        size: AppTextFontSize.normal,
                        weight: AppTextFontWeight.medium,
                        // textColor: AppTheme.white,
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            url = value;
                          });
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        decoration: InputDecoration(
                          hintText: '192.168.1.4:8000',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.iconColorDisable,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: url.isEmpty
                      ? null
                      : () {
                          setState(() {
                            DevelopmentServer.apiBaseUrl = "http://$url/";
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SplashScreen(),
                            ),
                          );
                        },
                  child: const SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Center(
                      child: AppText(
                        text: "وارد شوید",
                        weight: AppTextFontWeight.bold,
                        size: AppTextFontSize.xLarge,
                        textColor: AppTheme.textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
