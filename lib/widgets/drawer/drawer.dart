import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttrashcan/constants/app_constants.dart';
import 'package:smarttrashcan/constants/enums.dart';
import 'package:smarttrashcan/screens/anotherPage/history.dart';
import 'package:smarttrashcan/screens/splashscreen.dart';
import 'package:smarttrashcan/theme/theme.dart';
import 'package:smarttrashcan/widgets/text/AppText.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future removeUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('name');
      await prefs.remove('phone');
    } catch (e) {}
  }

  logOut() {
    removeUser();
    toast("خروج از حساب با موفقیت انجام شد");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      ),
    );
  }

  Widget listItem(IconData icon, String title, onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: AppTheme.primaryColor,
      ),
      title: AppText(
        text: title,
        size: AppTextFontSize.medium,
        weight: AppTextFontWeight.bold,
      ),
      trailing: const Icon(
        Icons.navigate_next,
        color: AppTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: CloseButton(
                        color: AppTheme.primaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppText(
                      text: User.name.isEmpty
                          ? "کاربر ${User.phone.substring(7)}"
                          : User.name,
                      size: AppTextFontSize.medium,
                      weight: AppTextFontWeight.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                      text: User.phone,
                      size: AppTextFontSize.medium,
                    ),
                  ],
                ),
              ),
              const Divider(
                color: AppTheme.primaryColor,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          listItem(
                            Icons.work_history_rounded,
                            "تاریخچه فعالیت",
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HistoryScreen(),
                                ),
                              );
                            },
                          ),
                          listItem(
                              Icons.logout_rounded, "خروج از حساب", logOut),
                        ],
                      ),
                    ),
                    const AppText(text: "version: 1.0.0"),
                    const AppText(text: AppConstants.appNameEn),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
