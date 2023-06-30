// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarttrashcan/constants/app_constants.dart';
import 'package:smarttrashcan/constants/enums.dart';
import 'package:smarttrashcan/screens/auth/code.dart';
import 'package:smarttrashcan/theme/theme.dart';
import 'package:smarttrashcan/widgets/double_back/double_back_to_close.dart';
import 'package:smarttrashcan/widgets/loading/loading.dart';
import 'package:smarttrashcan/widgets/text/AppText.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phone = "";
  bool nextClicked = false;

  apiLogin() async {
    try {
      print("${AppConstants.apiBaseUrl}myapp/login/");
      var response = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}myapp/login/"),
        body: jsonEncode(
          <String, String>{
            "phone": phone.substring(1),
          },
        ),
      );
      print("login => ${response.statusCode}");
      if (response.statusCode == 200) {
        setState(() {
          var jsondata = json.decode(utf8.decode(response.bodyBytes));
          print(jsondata);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Code(
                phone: phone,
              ),
            ),
          );
        });
      } else {
        toast("خطایی به‌ وجود آمده است");
      }
    } catch (e) {
      toast("خطایی به‌ وجود آمده است");
      print("login catch => $e");
    }
    setState(() {
      nextClicked = false;
    });
  }

  void Function()? nextButton() {
    if (!nextClicked) {
      setState(() {
        nextClicked = true;
      });
      apiLogin();
    }

    return null;
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
                        const AppText(
                          text:
                              "برای ورود یا ثبت نام شماره همراه خود را وارد نمایید.",
                          weight: AppTextFontWeight.medium,
                          size: AppTextFontSize.medium,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              phone = value;
                              if (phone.length >= 11) {
                                nextButton();
                              }
                            });
                          },
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: '09123456789',
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
