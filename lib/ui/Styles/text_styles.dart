import 'package:flutter/material.dart';
import 'package:virtual_furnish_app/enums/common_enum.dart';

class CustomTextStyle{

static TextStyle? homePageTitleText(BuildContext context){
  return Theme.of(context).textTheme.titleLarge!.copyWith(
    color: Colors.black,
    fontSize: 20,
    fontFamily: FontFamily.Poppins.value,
  );
}
}