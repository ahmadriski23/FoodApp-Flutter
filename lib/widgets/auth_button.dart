import 'package:flutter/material.dart';
import 'package:new_app/constants/color.dart';
import 'package:new_app/widgets/text_widgets.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
      {super.key,
      required this.fct,
      required this.buttonText,
      this.primary = kSecondColor});
  final Function fct;
  final String buttonText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    bool _isDark = true;
    return InkWell(
      onTap: () {
        fct();
      },
      child: Container(
        decoration: BoxDecoration(
            color: primary, borderRadius: BorderRadius.circular(100)),
        width: double.infinity,
        height: 50,
        child: Center(
            child:
                TextWidget(text: buttonText, color: kBlackColor, textSize: 16)),
      ),
    );
  }
}
