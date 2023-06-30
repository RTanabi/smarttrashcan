// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttrashcan/constants/app_constants.dart';
import 'package:smarttrashcan/constants/enums.dart';
import 'package:smarttrashcan/screens/auth/register.dart';
import 'package:smarttrashcan/screens/home/main_screen.dart';
import 'package:smarttrashcan/theme/theme.dart';
import 'package:smarttrashcan/widgets/double_back/double_back_to_close.dart';
import 'package:smarttrashcan/widgets/loading/loading.dart';
import 'package:smarttrashcan/widgets/text/AppText.dart';
import 'package:http/http.dart' as http;

class Code extends StatefulWidget {
  final String phone;
  const Code({super.key, required this.phone});

  @override
  State<Code> createState() => _CodeState();
}

class _CodeState extends State<Code> {
  String phone = "";
  String code = "";
  bool nextClicked = false;

  saveToken(String token, String phone) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('phone', phone);
    } catch (e) {}
  }

  apiOTP() async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}myapp/otp_test/"),
        body: jsonEncode(
          <String, String>{
            "otp": code,
            "phone": phone.substring(1),
          },
        ),
      );

      print("OTP => ${response.statusCode}");
      if (response.statusCode == 200) {
        setState(() {
          var jsondata = json.decode(utf8.decode(response.bodyBytes));
          print(jsondata);
          User.token = jsondata['token'];
          User.isNew = jsondata['is_new'];
          User.phone = phone;
          saveToken(jsondata["Token"].toString(), phone);
        });
        if (User.isNew) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Register(),
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
      } else if (response.statusCode == 401) {
        toast("کد وارد شده صحیح نیست");
      } else {
        toast("خطایی به‌ وجود آمده است");
      }
    } catch (e) {
      print("OTP catch => $e");
      toast("خطایی به‌ وجود آمده است");
    }
    setState(() {
      nextClicked = false;
    });
  }

  void Function()? nextButton() {
    if (!nextClicked) {
      apiOTP();
      setState(() {
        nextClicked = true;
      });
    }

    return null;
  }

  @override
  void initState() {
    setState(() {
      phone = widget.phone;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DoubleBackToClose(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Padding(
              padding: AppConstants.padding,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/icon.png",
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const AppText(
                          text: AppConstants.appName,
                          weight: AppTextFontWeight.bold,
                          size: AppTextFontSize.xxLarge,
                          textColor: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "کد ارسال شده به \"$phone\" را وارد نمایید.",
                          weight: AppTextFontWeight.medium,
                          size: AppTextFontSize.medium,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Pinput(
                            onChanged: (value) {
                              setState(() {
                                code = value;
                                if (code.length == 4) {
                                  nextButton();
                                }
                              });
                            },
                            autofocus: true,
                            length: 4,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: nextButton,
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Center(
                        child: nextClicked
                            ? const ButtonLoading()
                            : const AppText(
                                text: "ادامه",
                                weight: AppTextFontWeight.bold,
                                size: AppTextFontSize.xLarge,
                                textColor: AppTheme.textColor,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
