import 'package:flutter/material.dart';
import 'package:kumpulin/constant/theme.dart';
import 'package:kumpulin/widgets/build_button.dart';

class SendAllAndDeleteButtonWidget extends StatelessWidget {
  const SendAllAndDeleteButtonWidget({
    Key? key,
    required this.onTap,
    required this.statusSelect,
  }) : super(key: key);
  final VoidCallback onTap;
  final bool statusSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8.0,
        bottom: 16.0,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: onTap,
        child: BuildButton(
          btnColor: whiteBackground,
          btnBorder: Border.all(
            width: 1,
            color: primaryColor,
          ),
          btnText: statusSelect ? "Send all image" : 'Delete all image',
          btnTextStyle: bodyTextStyle.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
