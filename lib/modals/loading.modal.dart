import 'package:flutter/material.dart';

Future<T?>? showLoader<T>(BuildContext context) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return const Dialog(
            child: SizedBox(
          width: 200,
          height: 150,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ));
      });
}
