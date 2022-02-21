import 'package:flutter/material.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/widgets/build_button.dart';

class SendButtonWidget extends StatelessWidget {
  const SendButtonWidget({
    Key? key,
    required this.statusSelect,
    required this.onTap,
  }) : super(key: key);
  final bool statusSelect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10.0,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: onTap,
        child: BuildButton(
          btnColor: primaryColor,
          btnBorder: Border.all(width: 1),
          btnText: statusSelect ? 'Send the selected image' : 'Send image',
          btnTextStyle: bodyTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
