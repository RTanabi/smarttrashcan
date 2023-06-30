import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:smarttrashcan/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:smarttrashcan/constants/enums.dart';
import 'package:smarttrashcan/theme/theme.dart';
import 'package:smarttrashcan/widgets/container/appcontainer.dart';
import 'package:smarttrashcan/widgets/text/AppText.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  List historyList = [];

  apiUserHistoryLIST() async {
    try {
      var response = await http.get(
          Uri.parse("${AppConstants.apiBaseUrl}myapp/UserHistoryLIST/"),
          headers: {
            "token": User.token,
          });
      print("UserHistoryLIST => ${response.statusCode}");
      if (response.statusCode == 200) {
        setState(() {
          var jsondata = json.decode(utf8.decode(response.bodyBytes));
          print(jsondata);
          historyList = jsondata['list'];
        });
      } else {
        toast("خطایی به‌ وجود آمده است");
      }
    } catch (e) {
      toast("خطایی به‌ وجود آمده است");
      print("UserHistoryLIST catch => $e");
    }
  }

  @override
  void initState() {
    apiUserHistoryLIST();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const AppText(
              text: "تاریخچه فعالیت",
              size: AppTextFontSize.large,
              weight: AppTextFontWeight.bold,
            ),
          ),
          body: historyList.isEmpty
              ? Center(
                  child: LoadingBouncingGrid.circle(
                    backgroundColor: AppTheme.primaryColor,
                    size: 25,
                  ),
                )
              : ListView.separated(
                  padding: AppConstants.padding,
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    return AppContainer(
                      height: 180,
                      border: true,
                      borderColor: AppTheme.primaryColor,
                      color: Colors.transparent,
                      padding: AppConstants.padding,
                      child: Column(
                        children: [
                          AppText(
                            text: "سطل زباله " +
                                "${historyList[index]['trashcan_id']}",
                            textColor: AppTheme.primaryColor,
                            weight: AppTextFontWeight.bold,
                            size: AppTextFontSize.large,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.date_range_rounded,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const AppText(
                                text: "تاریخ فعالیت: ",
                                textColor: AppTheme.primaryColor,
                                weight: AppTextFontWeight.bold,
                                size: AppTextFontSize.normal,
                              ),
                              AppText(
                                text: historyList[index]['date'].toString(),
                                textColor: AppTheme.primaryColor,
                                weight: AppTextFontWeight.bold,
                                size: AppTextFontSize.normal,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const AppText(
                                text: "ساعت فعالیت: ",
                                textColor: AppTheme.primaryColor,
                                weight: AppTextFontWeight.bold,
                                size: AppTextFontSize.normal,
                              ),
                              AppText(
                                text: historyList[index]['time']
                                    .toString()
                                    .split('.')
                                    .first,
                                textColor: AppTheme.primaryColor,
                                weight: AppTextFontWeight.bold,
                                size: AppTextFontSize.normal,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
                ),
        ),
      ),
    );
  }
}
