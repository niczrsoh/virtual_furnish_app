import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Authentication/Login/login_bloc.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/seller_repo.dart';
import 'package:virtual_furnish_app/enums/globalization_enum.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';
import 'package:virtual_furnish_app/ui/Styles/text_styles.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';
import 'package:virtual_furnish_app/ui/Widgets/secondary_custom_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc loginBloc = LoginBloc();

   TextEditingController emailController = TextEditingController();

   TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          ),
        body: BlocConsumer<LoginBloc, LoginState>(
          bloc: loginBloc,
          listener: (context, state) async {
            if (state is LoginSuccess) {
              print('login success');
              await CustomSnackbar.showSuccessSnackbar(context, state.message);
              Navigator.pushNamed(context, '/master');
              loginBloc.add(LoginPageEnableButton(isButtonEnabled: true));
            } else if (state is LoginFail) {
              print('login fail');
              CustomSnackbar.showFailSnackbar(context, state.message);
                loginBloc.add(LoginPageEnableButton(isButtonEnabled: true));
            } else if (state is LoginLoading) {
              print('loading');
              CustomSnackbar.showLoadingSnackbar(context, 'loading');
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to the future of furniture shop',
                      style: CustomTextStyle.primaryTitleText(context),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        autofocus: true,
                        autocorrect: false,
                        controller: emailController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter Email',
                          labelText: 'Email',
                        ),
                        onEditingComplete: () {
                          if (emailController.text.isEmpty) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Please enter your email address.');
                          }else if(!emailController.text.contains('@') || emailController.text.split('@').length>2) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Please enter a valid email address.');
                          }else if(emailController.text.startsWith('@')) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Please enter a valid email address.');
                          }else if(emailController.text.split('@').length<1) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Please enter a valid email address.');
                          }},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter Password',
                          labelText: 'Password',
                        ),
                        onEditingComplete: () {
                          if (passwordController.text.isEmpty) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Please enter your password.');
                          }else if(passwordController.text.length<6) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Password	is	too short, try again.');
                          }else if(!passwordController.text.contains(RegExp(r'[0-9]'))&& !passwordController.text.contains(RegExp(r'[a-z]|[A-Z]'))) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Password missing alphabet and number.');
                          }
                          else if(!passwordController.text.contains(RegExp(r'[0-9]'))) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Password missing number.');
                                 //missing character
                          }else if(!passwordController.text.contains(RegExp(r'[a-z]|[A-Z]'))) {
                            CustomSnackbar.showFailSnackbar(
                                context, 'Password missing alphabet.');
                          }}
                      ),
                    ),
                    //forgot password at the left side
                    Row(
                      children: [
                          Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: TextButton(child:Text('Create a new Account'), onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          }, style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(CustomColor.vfPrimaryColor)),
                          )),
                          Expanded(
                            child: Container(),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: TextButton(child:Text('Forgot Password'), onPressed: () {
                            // Navigator.pushNamed(context, '/register');
                          },style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(CustomColor.vfPrimaryColor)),)
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    BlocSelector<LoginBloc, LoginState, bool>(
                      bloc: loginBloc,
                      selector: (state) {
                        if (state is LoginPageButtonEnabled) {
                          return state.isButtonEnabled;
                        }else{
                          return true;
                        }
                      },
                      builder: (context, isButtonEnabled) {
                        return Column(children: [
                          CustomButton(
                            onPressed: () async {
                              if (isButtonEnabled) {
                                loginBloc.add(LoginPageEnableButton(
                                    isButtonEnabled: false));
                                await CustomSnackbar.showLoadingSnackbar(
                                    context, 'loading');
                                //login with email and password
                                inputEmailAndPassword();
                           
                              }
                            },
                            buttonText: 'Login',
                            isDisabled: !isButtonEnabled,
                            radius: 30,
                          ),
                          SizedBox(height: mq.height * 0.05),
                          SecondaryCustomButton(
                            onPressed: () async {
                              if (isButtonEnabled) {
                                loginBloc.add(LoginPageEnableButton(
                                    isButtonEnabled: false));
                                //login google
                                await CustomSnackbar.showLoadingSnackbar(
                                    context, 'loading');
                                loginGoogle();
                              }
                            },
                            icon: Icon(
                              Icons.g_mobiledata_outlined,
                              color: CustomColor.vfPrimaryColor,
                              size: 30,
                            ),
                            width: mq.width * 0.8,
                            buttonText: 'Sign In with Google',
                            isDisabled: !isButtonEnabled,
                          ),
                          const SizedBox(height: 10),
                          SecondaryCustomButton(
                            onPressed: () {
                              (isButtonEnabled)
                                  ? Navigator.pushNamed(
                                      context, '/login_with_phone')
                                  : null;
                            },
                            icon: Icon(
                              Icons.phone_android_outlined,
                              color: CustomColor.vfPrimaryColor,
                            ),
                            width: mq.width * 0.8,
                            buttonText: 'Sign In With Phone',
                            isDisabled: !isButtonEnabled,
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                              onPressed: () async {
                                if (isButtonEnabled) {
                                  loginBloc.add(LoginPageEnableButton(
                                      isButtonEnabled: false));
                                  //login anonymously
                                  await CustomSnackbar.showLoadingSnackbar(
                                      context, 'loading');
                                  loginGuest();
                                }
                              },
                              child: Text('Continue as Guest',
                                  style: TextStyle(
                                    color: (isButtonEnabled)
                                        ? Colors.purple
                                        : Colors.grey,
                                  ))),
                        ]);
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void loginGuest() {
    loginBloc.add(AddGuest());
  }

  void loginGoogle() {
    loginBloc.add(SelectGoogleAccount());
  }
  
  void inputEmailAndPassword() {
         loginBloc.add(FillLoginForm(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim()));
  }
}
