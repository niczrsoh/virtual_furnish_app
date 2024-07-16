import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/app.dart';
import 'package:virtual_furnish_app/bloc/Authentication/Login/login_bloc.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';

class PhoneLoginPage extends StatefulWidget {
  PhoneLoginPage({super.key, required this.loginBloc});
  final LoginBloc loginBloc;

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState<String>> _phoneKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Login with phone'),
        ),
        body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: _phoneKey,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        prefix: Text('+60 '),
                        border: OutlineInputBorder(),
                        labelText: 'phone',
                        hintText: 'Enter your phone number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (value.length < 9 || value.length > 10) {
                          return 'Phone number is invalid';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: mq.height * 0.02,
                    ),
                    SizedBox(
                      height: mq.height * 0.02,
                    ),
                    BlocConsumer<LoginBloc, LoginState>(
                      bloc: widget.loginBloc,
                      listener: (context, state) {
                        if (state is CodeSent) {
                          //snackbar
                          CustomSnackbar.showSuccessSnackbar(
                              context, 'Code sent successfully');
                          Navigator.pushNamed(context, '/otp_verification',
                              arguments: {
                                'verificationId': state.verificationId,
                                'phoneNumber': '+60${_phoneController.text}'
                              });
                        }
                      },
                      builder: (context, state) {
                        return CustomButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final FirebaseAuth _auth = FirebaseAuth.instance;
                              _auth.verifyPhoneNumber(
                                phoneNumber: '+60${_phoneController.text}',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) async {
                                  _auth.signInWithCredential(credential);
                                },
                                verificationFailed: (FirebaseAuthException e) {
                                  // Verification failed
                                  // if (e.code == 'invalid-phone-number') {
                                  //   emit(CodeFailed(message: "Invalid Phone Number"));
                                  // }
                                },
                                codeSent: (String verificationId,
                                    int? resendToken) async {
                                  CustomSnackbar.showSuccessSnackbar(
                                      context, 'Code sent successfully');
                                  Navigator.pushNamed(
                                      context, '/otp_verification', arguments: {
                                    'verificationId': verificationId,
                                    'phoneNumber': '+60${_phoneController.text}'
                                  });
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                                timeout: Duration(seconds: 60),
                              );
                            }
                          },
                          buttonText: 'Submit',
                          isDisabled: false,
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? MediaQuery.of(context).viewInsets.bottom
                          : 10,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
