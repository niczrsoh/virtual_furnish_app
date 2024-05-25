import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';

class CustomSnackbar {
  static Future<void> showLoadingSnackbar(BuildContext context, String? message) async {
    await ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(color: CustomColor.vfPrimaryColor),
            const SizedBox(width: 16),
            Flexible(child: Text(message??"loading...")),
          ],
        ),
      ),
    ).closed;
  }

  static Future<void> showSuccessSnackbar(BuildContext context, String? message) async{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: CustomColor.successColor,
        content: Row(
          children: [
             Icon(Icons.check_circle,
                color: CustomColor.secondaryDarkAppColor),
            const SizedBox(width: 16),
            Flexible(child: Text(message??"Success")),
          ],
        ),
      ),
    ).closed;
  }

  static Future<void> showFailSnackbar(BuildContext context, String? message) async{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: CustomColor.failColor,
        content: Row(
          children: [
            Icon(Icons.error,
                color: CustomColor.primaryBackgroundColor),
            const SizedBox(width: 16),
            Flexible(child: Text(message?? "Failed")),
          ],
        ),
      ),
    ).closed;
  }

}
