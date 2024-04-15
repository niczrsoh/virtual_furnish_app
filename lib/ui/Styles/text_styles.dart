import 'package:flutter/material.dart';
import 'package:virtual_furnish_app/enums/common_enum.dart';

class CustomTextStyle{

static TextStyle? primaryTitleText(BuildContext context){
  return Theme.of(context).textTheme.titleLarge!.copyWith(
    color: Colors.black,
    fontSize: 20,
    fontFamily: FontFamily.Poppins.value,
  );
}
static TextStyle? secondaryTitleText(BuildContext context){
  return Theme.of(context).textTheme.titleMedium!.copyWith(
    color: Colors.black,
    fontSize: 18,
    fontFamily: FontFamily.Poppins.value,
    fontWeight: FontWeight.w600,
  );
}
static TextStyle? tertiaryTitleText(BuildContext context){
  return Theme.of(context).textTheme.titleSmall!.copyWith(
    color: Colors.black,
    fontSize: 16,
    fontFamily: FontFamily.Poppins.value,
    fontWeight: FontWeight.w500,
  );
}
static TextStyle? normalBoldText(BuildContext context){
  return Theme.of(context).textTheme.bodyMedium!.copyWith(
    color: Colors.black,
    fontSize: 15,
    fontFamily: FontFamily.Poppins.value,
    fontWeight: FontWeight.w500,
  );
}
static TextStyle? normalText(BuildContext context){
  return Theme.of(context).textTheme.bodySmall!.copyWith(
    color: Colors.black,
    fontSize: 12,
    fontFamily: FontFamily.Poppins.value,
    fontWeight: FontWeight.w300,
  );
}
}