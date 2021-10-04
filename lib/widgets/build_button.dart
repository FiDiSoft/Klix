import 'package:flutter/material.dart';

class BuildButton extends StatelessWidget {
  const BuildButton({
    Key? key,
    required this.btnColor,
    required this.btnBorder,
    required this.btnText,
    required this.btnTextStyle,
  }) : super(key: key);

  final Color btnColor;
  final BoxBorder btnBorder;
  final String btnText;
  final TextStyle btnTextStyle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: btnBorder,
          color: btnColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Text(
              btnText,
              style: btnTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
