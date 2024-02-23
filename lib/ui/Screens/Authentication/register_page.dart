import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/app.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';

import '../../../bloc/Authentication/bloc/Register/register_bloc.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  RegisterBloc registerBloc = RegisterBloc();
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
              CustomSnackbar.showSuccessSnackbar(context, state.message);
              Navigator.pushNamed(context, '/login');
              registerBloc.add(const RegisterPageEnableButton(isButtonEnabled: true));
            } else if (state is RegisterFail) {
              CustomSnackbar.showFailSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
                               bool isButtonEnabled = true;
                   if(state is RegisterPageButtonEnabled && state.isButtonEnabled == false){
                     isButtonEnabled = false;
                   }
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            } else if (value.length < 6 || value.length > 20) {
                              return 'Length of name should be between 6 and 20 characters';
                            } else if (!RegExp(r'^[a-zA-Z]+$')
                                .hasMatch(value)) {
                              return 'Name missing alphabet characters';
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!value.contains('@') ||
                                !value.contains('.') ||
                                !RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                                    .hasMatch(value)) {
                              return 'Email is invalid. Plaese enter a valid email';
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 5 || value.length > 30) {
                              return 'Length of password should be between 6 and 30 characters';
                            } 
                            // else if (!RegExp(r'^[a-z]+$')
                            //     .hasMatch(value)) {
                            //   return 'Password missing alphabet characters';
                            // } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            //   return 'Password missing numeric characters';
                            // }
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              } else if (value != _passwordController.text) {
                                return 'Password does not match';
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
                            registerBloc.add(RegisterPageEnableButton(isButtonEnabled: false));
                            CustomSnackbar.showLoadingSnackbar(context,'Register user ...');
                            addNewUser();
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

  void addNewUser() {
       if (_formKey.currentState!.validate()) {
      registerBloc.add(RegisterCreation(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ));
    }
  }
}
