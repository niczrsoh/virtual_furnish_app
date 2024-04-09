import 'package:flutter/material.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, required this.onPressed, required this.buttonText,required this.isDisabled,  this.width,  this.radius, this.icon, this.height});
  final VoidCallback? onPressed;
  final String? buttonText;
  final bool isDisabled;
  final double? width;
  final double? radius;
  final double? height;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height??mq.height*0.06,
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
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(icon!=null)...[ Icon(icon, color: Colors.white, size: 15,),SizedBox(width: 5,)],
            Flexible(
              child: Text(
              buttonText!,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: (isDisabled)?CustomColor.disabledTextColor:CustomColor.primaryDarkTextColor,
              ),
                        ),
            ),]
        ),
      ),
    );
  }
}
