import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DevelopmentServer {
  static const siteUrl = '';
  static String apiBaseUrl = 'http://192.168.1.4:8000/';
  static const apiVersion = '';
}

class AppConstants {
  static const String appName = 'سیستم مانیتورینگ هوشمند زباله';
  static const String appNameEn = 'Intelligent waste monitoring system';
  static const String appEn = 'IWMS';
  static String appVersion = '';
  static String apiBaseUrl = DevelopmentServer.apiBaseUrl;
  static const String apiVersion = DevelopmentServer.apiVersion;
  static const String supportPhone = '';
  static const String supportEmail = '';
  static const EdgeInsetsGeometry paddingh =
      EdgeInsets.symmetric(horizontal: 25.0);
  static const EdgeInsetsGeometry paddingv =
      EdgeInsets.symmetric(vertical: 20.0);
  static const EdgeInsetsGeometry padding =
      EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0);
  static const EdgeInsetsGeometry paddingAll = EdgeInsets.all(10.0);
}

void toast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    webBgColor: "linear-gradient(to right, #4B4B4B, #4B4B4B)",
    textColor: Colors.white,
    fontSize: 20,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 3,
  );
}

class User {
  static String token = '';
  static bool isNew = false;
  static String name = '';
  static String phone = '';
}
