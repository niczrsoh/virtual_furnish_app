import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';

class Resetpage extends StatefulWidget {
  const Resetpage({super.key});

  @override
  State<Resetpage> createState() => _ResetpageState();
}

class _ResetpageState extends State<Resetpage> {
  final oldPasswordTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isContinueButtonDisabled = true;
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  //foucs node for each text field
  void confirmPasswords() {
    if (passwordTextController.text.trim() !=
        confirmPasswordTextController.text.trim()) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Password Mismatch'),
              content: const Text(
                  'Please check your password again. Make sure your password is the same as your confirmation password.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });
    }
  }

  void checkButtonStatus() {
    if (oldPasswordTextController.text.trim().isNotEmpty &&
        passwordTextController.text.trim().isNotEmpty &&
        confirmPasswordTextController.text.trim().isNotEmpty) {
      setState(() {
        isContinueButtonDisabled = false;
      });
    } else {
      setState(() {
        isContinueButtonDisabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Password'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: oldPasswordTextController,
                    obscureText: !_showOldPassword,
                    onChanged: (value) {
                      checkButtonStatus();
                    },
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      hintText: 'Current password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showOldPassword = !_showOldPassword;
                          });
                        },
                        icon: Icon(Icons.remove_red_eye,
                            color: (_showOldPassword)
                                ? CustomColor.vfPrimaryColor
                                : CustomColor.disabledButtonColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passwordTextController,
                    obscureText: !_showNewPassword,
                    onChanged: (value) {
                      checkButtonStatus();
                    },
                    decoration: InputDecoration(
                      
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      hintText: 'New password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showNewPassword = !_showNewPassword;
                          });
                        },
                        icon: Icon(Icons.remove_red_eye,
                            color: (_showNewPassword)
                                ? CustomColor.vfPrimaryColor
                                : CustomColor.disabledButtonColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (value) {
                      checkButtonStatus();
                    },
                    controller: confirmPasswordTextController,
                    obscureText: !_showConfirmPassword,
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      hintText: 'Confirm new password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                        icon: Icon(Icons.remove_red_eye,
                            color: (_showConfirmPassword)
                                ? CustomColor.vfPrimaryColor
                                : CustomColor.disabledButtonColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                    buttonText: 'Save',
                    isDisabled: isContinueButtonDisabled,
                    onPressed: () async {
                      checkButtonStatus();
                      if (!isContinueButtonDisabled) {
                        setState(() {
                          isContinueButtonDisabled = true;
                        });
                        CustomSnackbar.showLoadingSnackbar(
                            context, "Verifying new password...");
                        if (validatePassword(
                                passwordTextController.text.trim()) ==
                            false) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 0, 15, 12),
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Password is not obeying the rule.\nPlease check again.",
                                        ),
                                      ),
                                    ],
                                  )));
                          confirmPasswordTextController.clear();
                          passwordTextController.clear();
                        } else if (passwordTextController.text.trim() ==
                            confirmPasswordTextController.text.trim()) {
                          String message = await AuthRepo.changePassword(
                              oldPasswordTextController.text.trim(),
                              passwordTextController.text.trim());
                          if (message == "Successfully changed password") {
                            CustomSnackbar.showSuccessSnackbar(
                                context, message);
                          } else {
                            CustomSnackbar.showFailSnackbar(context, message);
                          }
                        } else {
                          confirmPasswords();
                          confirmPasswordTextController.clear();
                        }
                        setState(() {
                          isContinueButtonDisabled = false;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

bool validatePassword(String password) {
if (password.isEmpty) {
                        return false;
                          }else if(password.length<6) {
                           return false;
                          }else if(!password.contains(RegExp(r'[0-9]'))&& password.contains(RegExp(r'[a-z]|[A-Z]'))) {
                            return false;
                          }
                          else if(!password.contains(RegExp(r'[0-9]'))) {
                            return false;
                                 //missing character
                          }else if(!password.contains(RegExp(r'[a-z]|[A-Z]'))) {
                            return false;
                          }else{
                            return true;
                          }
}
