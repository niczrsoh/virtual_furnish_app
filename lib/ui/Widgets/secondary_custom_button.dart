import 'package:flutter/material.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';

class SecondaryCustomButton extends StatelessWidget {
  const SecondaryCustomButton(
      {super.key, required this.onPressed, required this.buttonText,required this.isDisabled,  this.width,  this.radius, this.icon});
  final VoidCallback? onPressed;
  final String? buttonText;
  final bool isDisabled;
  final double? width;
  final double? radius;
  final Icon? icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width??double.infinity,
      decoration: BoxDecoration(
        boxShadow: const[
           BoxShadow(
              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
        ],
        borderRadius: BorderRadius.circular(radius??12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: (isDisabled)?CustomColor.disabledButtonColor:CustomColor.primaryBackgroundColor,
          shape:  RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: CustomColor.primaryDarkAppColor, width: 2.0)
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon??Container(),
            SizedBox(width: 10,),
            Text(
              buttonText!,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: (isDisabled)?CustomColor.disabledTextColor:CustomColor.vfPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
