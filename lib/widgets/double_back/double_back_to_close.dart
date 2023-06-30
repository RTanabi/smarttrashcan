// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DoubleBackToClose extends StatefulWidget {
  const DoubleBackToClose({super.key, @required this.child});
  final Widget? child;

  @override
  _DoubleBackToClose createState() => _DoubleBackToClose();
}

class _DoubleBackToClose extends State<DoubleBackToClose> {
  DateTime backButtonPressTime = DateTime(2000);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (DateTime.now().difference(backButtonPressTime) >
            const Duration(seconds: 1)) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'double press to exit',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          backButtonPressTime = DateTime.now();
          return false;
        }
        Fluttertoast.cancel();
        return true;
      },
      child: widget.child != null ? widget.child as Widget : const Text(''),
    );
  }
}
