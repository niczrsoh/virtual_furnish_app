import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/edit_profile_bloc.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_alert_dialog.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';

class EditProfilePage extends StatefulWidget {
  final bloc;

  EditProfilePage({super.key, required this.bloc});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  UserModel userModel = UserModel();
  bool isFirstTime = true;
   String? profilePic;
   String? status;
  static TextEditingController usernameController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController contactController = TextEditingController();
  int age = 0;

  //key
  final GlobalKey<FormState> _usernameKey = GlobalKey<FormState>();

  bool isButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        showDialog(context: context, builder: (context){
          return CustomAlertDialog(title: "Are you sure", message: "Are you sure to leave this page withoit save your details?", confirmButtonText: "Yes", cancelButtonText: "No", confirmButtonPressed: (){
            Navigator.pop(context);
            Navigator.pop(context,"back");
          }, cancelButtonPressed: (){
            Navigator.pop(context);
          });
        });
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
          ),
          body: BlocConsumer<EditProfileBloc, EditProfileState>(
            listener: (context, state) {
              if (state is UserProfileFound && isFirstTime) {
                  setState(() {
                    isFirstTime = false;
                  });
                  usernameController.text = state.userModel.username ?? "";
                  emailController.text = state.userModel.email ?? "";
                  contactController.text = (state.userModel.contact!=null)? ((state.userModel.contact!.contains("+60"))?state.userModel.contact!.replaceAll("+60", ""):state.userModel.contact!):"";
                  profilePic = state.userModel.profilePic;
                  status = state.userModel.status ?? "User";
                  age = state.userModel.age ?? 0;
              } else if (state is EditProfileSuccess) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
                Navigator.pop(context,"update success");
              } else if (state is EditProfileError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
            },
            builder: (context, state) {
              switch (state.runtimeType) {
                case FetchUserProfile || EditProfileInitial:
                  return const Center(child: CircularProgressIndicator());
                case UserProfileFound:
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: (profilePic != null && profilePic!.isNotEmpty)
                                ? (profilePic!.contains("https://"))
                                    ? Image.network(profilePic!).image
                                    : Image.file(File(profilePic!)).image
                                : Image.asset('assets/images/profilepic-anonymous.jpg')
                                    .image,
                          ),
                          TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: mq.height * 0.2,
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Select a profile picture",
                                            ),
                                            ListTile(
                                              title: Text("Take a Picture"),
                                              onTap: () {
                                                changeProfilePicture(
                                                    ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              title: Text("Choose from Gallery"),
                                              onTap: () {
                                                changeProfilePicture(
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Text(
                                "Change Profile Picture",
                                style: TextStyle(color: Colors.black),
                              )),
                          ListTile(
                            title: const Text('Username'),
                            subtitle: TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                hintText: 'Enter your username',
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text('Email'),
                            subtitle: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                              ),
                            ),
                          ),
                          ListTile(
                            title: const Text('Phone Number'),
                            subtitle: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      "+60 - ",
                                      style: TextStyle(fontSize: 15),
                                    )),
                                Expanded(
                                  flex: 6,
                                  child: TextFormField(
                                    controller: contactController,
                                    inputFormatters: [
                                      //only number
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your phone number',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: const Text('Status'),
                            subtitle: DropdownButton<String>(
                              value: status,
                              onChanged: (String? newValue) {
                                setState(() {
                                  status = newValue;
                                });
                              },
                              items: <String>[
                                'Computer Programmer',
                                'Student',
                                'User',
                                'Office Worker',
                                'Housewife',
                                'Others'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          ListTile(
                            title: const Text('Age'),
                            subtitle: Slider(
                              value: age.toDouble(),
                              max: 100,
                              divisions: 5,
                              label: age.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  age = value.round();
                                });
                              },
                            ),
                          ),
                          CustomButton(
                              onPressed: () {
                                debugPrint('username: ${_usernameKey}');
                                widget.bloc.add(ProfileModification(
                                    username: usernameController.text,
                                    email: emailController.text,
                                    contact: contactController.text,
                                    status: status!,
                                    age: age,
                                    profilePic: profilePic!));
                              },
                              buttonText: 'Save',
                              isDisabled: false)
                        ],
                      ),
                    ),
                  );
                case UserProfileError:
                  final errorState = state as UserProfileError;
                  return Center(child: Text('Error: ${errorState.errorMessage}'));
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }

  Future<void> changeProfilePicture(ImageSource source) async {
    //add code to change profile picture
    XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        profilePic = image.path;
      });
    }
  }
}
