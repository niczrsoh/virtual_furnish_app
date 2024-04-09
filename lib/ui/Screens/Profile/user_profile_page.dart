import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/user_profile_bloc.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';

class UserProfilePage extends StatelessWidget {
  final UserProfileBloc userProfileBloc;
  const UserProfilePage({super.key, required this.userProfileBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
            if(state is UserProfileInitial){
              userProfileBloc.add(UserProfileFetched());
              return const Center(child: CircularProgressIndicator());}
            else if(state is UserProfileFound || state is UserProfileButtonEnabled){
              final foundState ;
              if(state is UserProfileButtonEnabled){
                final buttonState = state as UserProfileButtonEnabled;
                foundState = buttonState.userProfileFound;}
              else{
                foundState = state as UserProfileFound;
              }
              return FoundWidget(
                  userModel: foundState.userModel,
                  userProfileBloc: userProfileBloc);}
            else if(state is UserProfileError){
              final errorState = state as UserProfileError;
              return Center(
                child: Text('Error: ${errorState.errorMessage}'),
              );}else{
              return const Center(child: CircularProgressIndicator());
              }
          }
        
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () {
                   AuthRepo.logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}

class FoundWidget extends StatelessWidget {
  const FoundWidget({
    super.key,
    required this.userModel,
    required this.userProfileBloc,
  });
  final UserModel userModel;
  final UserProfileBloc userProfileBloc;
  void refresh() {
    userProfileBloc.add(UserProfileFetched());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        ListTile(
          title: Text(userModel.username ?? ""),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userModel.email ?? ""),
              const SizedBox(
                height: 10,
              ),
              BlocSelector<UserProfileBloc, UserProfileState, bool>(
                bloc: userProfileBloc,
                selector: (state){ 
                  if(state is UserProfileButtonEnabled){
                  return state.isButtonEnabled;}
                  else return true;},
                builder: (context, isButtonEnabled) {
                  return CustomButton(
                      onPressed: () async {
                        if(isButtonEnabled){
                        userProfileBloc.add(const UserProfileEventButtonEnabled(isButtonEnabled: false));
                        var result =
                            await Navigator.pushNamed(context, '/edit_profile');
                        if (result != null) {
                          refresh();
                          userProfileBloc.add(const UserProfileEventButtonEnabled(isButtonEnabled: true));
                        }}
                      },
                      buttonText: 'Edit Profile',
                      isDisabled: !isButtonEnabled);
                },
              )
            ],
          ),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: Image.network(userModel.profilePic ??
                    "https://img.freepik.com/premium-vector/user-profile-icon-flat-style-member-avatar-vector-illustration-isolated-background-human-permission-sign-business-concept_157943-15752.jpg?size=338&ext=jpg&ga=GA1.1.1700460183.1708646400&semt=ais")
                .image,
          ),
        ),
        ListProfileTile(
            title: "My Orders", subtitle: "already have 0 order", onTap: () {}),
        ListProfileTile(
            title: "Shipping Address", subtitle: "3 address", onTap: () {}),
        ListProfileTile(
            title: "Seller Registration", subtitle: "Pending", onTap: () async {
              var result = await Navigator.pushNamed(context, '/seller_register');
              if (result != null) {
                refresh();
              }
            }),
        ListProfileTile(
            title: "Payment method", subtitle: "Visa **34", onTap: () {}),
        ListProfileTile(
            title: "Account Setting",
            subtitle: "Notifications, password",
            onTap: () {}),
      ],
    ));
  }
}

class ListProfileTile extends StatelessWidget {
  const ListProfileTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle ?? ""),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
      ),
      onTap: onTap,
    );
  }
}
