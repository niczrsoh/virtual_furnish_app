import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/checkout_bloc.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Styles/export_styles.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_loading_bar.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';
import 'package:virtual_furnish_app/ui/Widgets/secondary_custom_button.dart';

class AddressPage extends StatefulWidget {
   AddressPage({super.key, required this.checkoutBloc});
  final CheckoutBloc checkoutBloc;

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  bool isButtonDisabled = false;
  bool isFirst = true;
  List<bool> isSelected = [];
  bool isAdded = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController addressController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: CustomColor.primaryBackgroundColor,
        backgroundColor: CustomColor.vfPrimaryColor,
        onPressed: () {
          //pop up a dialog to add address
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: CustomColor.vfSecondaryColor,
                  contentPadding: PaddingStyles.paddingStyle1,
                  
                  title: Text('Add Address', style: TextStyle(color: CustomColor.primaryBackgroundColor)),
                  content: TextFormField(
                    //two line
                    maxLines: 5,
                    controller: addressController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill up the shipping address text field.';
                      }else if (!value.contains(RegExp(r'[a-zA-Z]'))){
                        return 'Shipping address missing words.';
                      }
                      return null;
                    
                    },
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel', style: TextStyle(color: CustomColor.primaryBackgroundColor))),
                    TextButton(
                        onPressed: () {
                          if(addressController.value.text.isEmpty){
                            CustomSnackbar.showFailSnackbar(context, "Please fill up the shipping address text field.");
                            return;
                          }else if (!addressController.value.text.contains(RegExp(r'[a-zA-Z]'))){
                            CustomSnackbar.showFailSnackbar(context, "Shipping address missing words.");
                            return;
                          }
                          else{
                          widget.checkoutBloc.add(AddAddress(address: addressController.text));
                          CustomSnackbar.showLoadingSnackbar(context, "Adding Address");
                          Navigator.pop(context);}
                        },
                        child: Text('Add', style: TextStyle(color: CustomColor.primaryBackgroundColor)))
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        bloc: widget.checkoutBloc,
        listenWhen: (previous, current) => current is CheckoutAddressActionState,
        buildWhen: (previous, current) => current is CheckoutAddressState,
        listener: (context, state) {
          // TODO: implement listener
          if(state is CheckoutAddressAdded){
           setState(() {
             isAdded = true;
           });
           CustomSnackbar.showSuccessSnackbar(context, "Address Added");
          }
          else if(state is CheckoutAddressRemoved){
            CustomSnackbar.showSuccessSnackbar(context, "Address Removed");
          }
          else if(state is CheckoutAddressError){
            CustomSnackbar.showFailSnackbar(context, state.message);
          }else if (state is CheckoutAddressChanged){
            //false all the selected
            isSelected = List.generate(isSelected.length, (index) => false);
            isSelected[0] = true;
            CustomSnackbar.showSuccessSnackbar(context, "Address Changed");}
        },
        builder: (context, state) {
          switch(state.runtimeType){
            case CheckoutAddressEmpty:
            return Center(child: Text("No Address Added Yet"));
            case CheckoutAddressLoaded:
            final currentState = state as CheckoutAddressLoaded;
            if(isFirst || isAdded){
            isSelected = List.generate(currentState.address.length, (index) => false);
            isSelected[0] = true;
            if(isAdded){
              isAdded = false;
            }
            }
            isFirst = false;
          return ListView.builder(
            itemCount: currentState.address.length,
            itemBuilder: 
          (context, index){
            return CheckboxListTile(
              fillColor: MaterialStateProperty.all(CustomColor.vfPrimaryColor),
              title: Text(currentState.address[index]+((index==0)?" (default address)":"")),
              value: isSelected[index],
              secondary: IconButton(
                icon: Icon(Icons.delete),
                onPressed: (){
                  widget.checkoutBloc.add(RemoveAddress(address: currentState.address[index]));
                  CustomSnackbar.showLoadingSnackbar(context, "Removing Address");
                },
              ),
              onChanged: (value) {
                setState(() {
                   //set all the other values to false
                   isSelected = List.generate(currentState.address.length, (index) => false);
                   isSelected[index] = value!;
                });
                //change the address
               widget.checkoutBloc.add(ChangeAddress(address: currentState.address[index]));
            //   CustomSnackbar.showLoadingSnackbar(context, "Changing Address");
              },
            );
          },
          );
          default:
          return const RunningDotsLoader();
          }
        },
      ),
    );
  }
}
