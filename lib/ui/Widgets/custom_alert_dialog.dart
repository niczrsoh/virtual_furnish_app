import 'package:flutter/material.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final VoidCallback? confirmButtonPressed;
  final VoidCallback? cancelButtonPressed;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
     this.confirmButtonText,
     this.cancelButtonText,
     this.confirmButtonPressed,
     this.cancelButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: CustomColor.vfPrimaryColor),
      ),
      backgroundColor: CustomColor.secondaryBackgroundColor,
      title: Text(title,textAlign: TextAlign.justify),
      content: Text(message,textAlign: TextAlign.justify,),
      actions: [
        (confirmButtonText !=null)?
        TextButton(
          onPressed: confirmButtonPressed,
          child: Text(
            confirmButtonText!,
            style: TextStyle(color: CustomColor.vfPrimaryColor),
          ),
        ):Container(),
          (cancelButtonText !=null)?
        TextButton(
          onPressed: cancelButtonPressed,
          child: Text(
            cancelButtonText!,
            style: TextStyle(color: CustomColor.vfPrimaryColor),
          ),
        ):Container()
      ],
    );
  }
}
