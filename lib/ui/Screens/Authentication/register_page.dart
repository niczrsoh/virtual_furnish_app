import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/app.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';

import '../../../bloc/Authentication/Register/register_bloc.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  RegisterBloc registerBloc = RegisterBloc();
  bool isButtonEnabled = true;
  static final TextEditingController _nameController = TextEditingController();

  static final TextEditingController _emailController = TextEditingController();

  static final TextEditingController _passwordController = TextEditingController();

  static final TextEditingController _confirmPasswordController = TextEditingController();

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final GlobalKey<FormFieldState<String>> _nameKey =
      GlobalKey<FormFieldState<String>>();

  static final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();

  static final GlobalKey<FormFieldState<String>> _passwordKey =
      GlobalKey<FormFieldState<String>>();

  static final GlobalKey<FormFieldState<String>> _confirmPasswordKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       // FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: BlocConsumer<RegisterBloc, RegisterState>(
          bloc: registerBloc,
          listener: (context, state) {
            if (state is RegisterSuccess) {
              isButtonEnabled = true;
              CustomSnackbar.showSuccessSnackbar(context, state.message);
              Navigator.pop(context);
              registerBloc.add(const RegisterPageEnableButton(isButtonEnabled: true));
            } else if (state is RegisterFail) {
              isButtonEnabled = true;
              CustomSnackbar.showFailSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          key: _nameKey,
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                            hintText: 'Enter your name',
                          ),
                          onEditingComplete: () {
                              if (_nameController == null || _nameController.text.isEmpty) {
                              CustomSnackbar.showFailSnackbar(context, 'Please enter your name');
                            } else if (_nameController.text.length < 6) {
                              CustomSnackbar.showFailSnackbar(context, 'Name is too short');
                            } else if (!_nameController.text.contains(RegExp(r'^[a-zA-Z]')) ) {
                              CustomSnackbar.showFailSnackbar(context, 'Name missing alphabet characters');
                            } else if (_nameController.text.length>50 ) {
                              CustomSnackbar.showFailSnackbar(context, 'Name is too long');
                            } 
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            } else if (value.length < 6) {
                              return 'Name is too short';
                            } else if (!value.contains(RegExp(r'^[a-zA-Z]')) ) {
                              return 'Name missing alphabet characters';
                            } else if (value.length>50 ) {
                              return 'Name is too long';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        TextFormField(
                          key: _emailKey,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Enter your email',
                          ),
                           onEditingComplete: () {
                          if (_emailController.text.isEmpty) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Please enter your email address.');
                          }else if(!_emailController.text.contains('@') || _emailController.text.split('@').length>2) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Please enter a valid email address.');
                          }else if(_emailController.text.startsWith('@')) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Please enter a valid email address.');
                          }else if(_emailController.text.split('@').length<1) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Please enter a valid email address.');
                          }},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!value.contains('@') || value.split('@').length>2) {
                              return 'Please enter a valid email address';
                            } else if (value.startsWith('@')) {
                              return 'Please enter a valid email address';
                            } else if (value.split('@').length<1) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        TextFormField(
                          key: _passwordKey,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Enter your password',
                          ),
                            onEditingComplete: () {
                          if (_passwordController.text.isEmpty) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Please enter your password.');
                          }else if(_passwordController.text.length<6) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Password	is	too short, try again.');
                          }else if(!_passwordController.text.contains(RegExp(r'[0-9]'))&& !_passwordController.text.contains(RegExp(r'[a-z]|[A-Z]'))) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Password missing alphabet and number.');
                          }
                          else if(!_passwordController.text.contains(RegExp(r'[0-9]'))) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Password missing number.');
                                 //missing character
                          }else if(!_passwordController.text.contains(RegExp(r'[a-z]|[A-Z]'))) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Password missing alphabet.');
                          }},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password is too short';
                            } else if (!value.contains(RegExp(r'[0-9]'))&& !value.contains(RegExp(r'[a-z]|[A-Z]'))) {
                              return 'Password missing alphabet and number';
                            } else if (!value.contains(RegExp(r'[0-9]'))) {
                              return 'Password missing number';
                            } else if (!value.contains(RegExp(r'[a-z]|[A-Z]'))) {
                              return 'Password missing alphabet';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        TextFormField(
                            key: _confirmPasswordKey,
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confirm Password',
                              hintText: 'Confirm your password',
                            ),
                            onEditingComplete: () {
                              if (_confirmPasswordController.text.isEmpty) {
                                CustomSnackbar.showFailSnackbar(
                                    context, 'Please fill up the confirm password text field.');
                              } else if (_confirmPasswordController.text != _passwordController.text) {
                                CustomSnackbar.showFailSnackbar(
                                    context, 'Different	with	the filled in password.');
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill up the confirm password text field.';
                              } else if (value != _passwordController.text) {
                                return 'Different	with	the filled in password.';
                              }
                            }),

                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        //forgot password at the right side
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Already have an account?'),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        CustomButton(
                          isDisabled: !isButtonEnabled,
                          onPressed: () {
                            //validate the form first
                            //if the form is valid, then register the user
                            //if the form is not valid, show an error message
                            if(_formKey.currentState!.validate()){
                            CustomSnackbar.showLoadingSnackbar(context,'Register user ...');
                            addNewUser(context);
                            }else{
                              CustomSnackbar.showFailSnackbar(context, 'Please check again the required fields');
                            }

                          },
                          buttonText: 'Sign Up',
                        ),
                        // SizedBox(
                        //   height: MediaQuery.of(context).viewInsets.bottom > 0
                        //       ? MediaQuery.of(context).viewInsets.bottom
                        //       : 10,
                        // ),
                      ],
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }

  void addNewUser(BuildContext context) {
       if (_formKey.currentState!.validate()) {
      registerBloc.add(RegisterCreation(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ));
      CustomSnackbar.showLoadingSnackbar(context, 'Please verify your email address');
    }
  }
}
