import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/user_profile_bloc.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/ui/Screens/master_page.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/router/router.dart';

class UserProfilePage extends StatelessWidget {
  final UserProfileBloc userProfileBloc;
  const UserProfilePage({super.key, required this.userProfileBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {},
        buildWhen: (previous, current) => current is !UserProfileActionState,
        builder: (context, state) {
            // if(state is UserProfileInitial){
            //   userProfileBloc.add(UserProfileFetched());
            //   return const Center(child: CircularProgressIndicator());}
            // else 
             userProfileBloc.add(UserProfileFetched());
            if(state is UserProfileFound){
              final foundState = state as UserProfileFound;
              return FoundWidget(
                  currentState: foundState,
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
              //remove current state
      //]        userProfileBloc.close();
              //reload the page
              
              
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false);
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
    required this.currentState,
    required this.userProfileBloc,
  });
  final UserModel userModel;
  final UserProfileFound currentState;
  final UserProfileBloc userProfileBloc;
  void refresh() {
    userProfileBloc.add(UserProfileFetched());
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = true;
    return SingleChildScrollView(
        child: Column(
      children: [
        ListTile(
          title: Text(userModel.username ?? ""),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userModel.email ?? "-"),
              const SizedBox(
                height: 10,
              ),
              if(userModel.status!="Guest")
              BlocBuilder<UserProfileBloc, UserProfileState>(
                bloc: userProfileBloc,
                buildWhen: (previous, current) => current is UserProfileActionState,
                builder: (context, state) {
                  return CustomButton(
                      onPressed: () async {
                        if(isButtonEnabled || (state is UserProfileButtonEnabled && state.isButtonEnabled)){
                          isButtonEnabled = false;
                        userProfileBloc.add(const UserProfileEventButtonEnabled(isButtonEnabled: false));
                        var result =
                            await Navigator.pushNamed(context, '/edit_profile');
                        if (result != null) {
                          refresh();
                          userProfileBloc.add(const UserProfileEventButtonEnabled(isButtonEnabled: true));
                        }}
                      },
                      buttonText: 'Edit Profile',
                      isDisabled: (state is UserProfileButtonEnabled)?!state.isButtonEnabled:!isButtonEnabled);
                },
              )
            ],
          ),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: (userModel.profilePic!=null&&userModel.profilePic!="")?Image.network(userModel.profilePic!).image:Image.asset('assets/images/profilepic-anonymous.jpg').image,
          ),
        ),
        if(userModel.status!="Guest")...[
        ListProfileTile(
            title: "My Orders", subtitle: "already have ${currentState.orderNo} order", onTap: () {

              Navigator.pushNamed(context, '/order_detail', arguments: {"type":"process"});
            }),
        ListProfileTile(
            title: "Shipping Address", subtitle: "3 address", onTap: () {}),
        ListProfileTile(
            title: "Seller Registration", subtitle: (userModel.sell!=null&&userModel.sell!.isNotEmpty)?"1 shop":"0 shop", onTap: () async {
              var result = await Navigator.pushNamed(context, '/seller_register_list');
              if (result != null) {
                refresh();
              }
            }),
        ListProfileTile(
            title: "Payment method", subtitle: "Visa **34", onTap: () {}),
        ListProfileTile(
            title: "Account Setting",
            subtitle: "Notifications, password",
            onTap: () {}),]
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
