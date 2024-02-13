import 'package:example/constants/text.dart';
import 'package:flutter/material.dart';

class Loader {
  void showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(
                color: Colors.cyan,
              ),
              Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    "Loading...",
                    style: kHeadingtext,
                  )),
            ],
          ),
        );
        ;
      },
    );
  }
}
