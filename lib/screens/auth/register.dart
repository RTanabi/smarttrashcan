// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttrashcan/constants/app_constants.dart';
import 'package:smarttrashcan/constants/enums.dart';
import 'package:smarttrashcan/screens/home/main_screen.dart';
import 'package:smarttrashcan/theme/theme.dart';
import 'package:smarttrashcan/widgets/double_back/double_back_to_close.dart';
import 'package:smarttrashcan/widgets/loading/loading.dart';
import 'package:smarttrashcan/widgets/text/AppText.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name = "";
  bool nextClicked = false;

  saveName(String name) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name);
    } catch (e) {}
  }

  apiRegister() async {
    try {
      var response = await http.post(
        Uri.parse("${AppConstants.apiBaseUrl}myapp/set_info/"),
        headers: {
          "token": User.token,
        },
        body: jsonEncode(
          <String, String>{
            "name": name,
          },
        ),
      );
      print("register => ${response.statusCode}");
      if (response.statusCode == 200) {
        setState(() {
          var jsondata = json.decode(utf8.decode(response.bodyBytes));
          print(jsondata);
          User.name = name;
          saveName(name);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        });
      } else {
        toast("خطایی به‌ وجود آمده است");
      }
    } catch (e) {
      toast("خطایی به‌ وجود آمده است");
      print("register catch => $e");
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
      apiRegister();
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
                          text: "لطفا نام و نام خانوادگی خود را وارد نمایید.",
                          weight: AppTextFontWeight.medium,
                          size: AppTextFontSize.medium,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(35),
                          ],
                          decoration: InputDecoration(
                            hintText: 'نام و نام خانوادگی',
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
                                text: "ثبت نام",
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
