import 'package:flutter/material.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, required this.onPressed, required this.buttonText,required this.isDisabled,  this.width,  this.radius});
  final VoidCallback? onPressed;
  final String? buttonText;
  final bool isDisabled;
  final double? width;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width??mq.width*0.8,
      decoration: BoxDecoration(
        boxShadow: const[
           BoxShadow(
              color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
        ],
        gradient: (isDisabled)? 
        LinearGradient(
          colors: CustomColor.vFColorDisabledGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
        :LinearGradient(
          colors: CustomColor.vfColorGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius??12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        child: Text(
          buttonText!,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            color: (isDisabled)?CustomColor.disabledTextColor:CustomColor.primaryDarkTextColor,
          ),
        ),
      ),
    );
  }
}
