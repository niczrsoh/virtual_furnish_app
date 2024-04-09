import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/seller_profile_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/user_profile_bloc.dart';
import 'package:virtual_furnish_app/data/model/Authentication/sell_account_model.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';

class SellerProfilePage extends StatelessWidget {
  final SellerProfileBloc sellerProfileBloc;
  const SellerProfilePage({super.key, required this.sellerProfileBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SellerProfileBloc, SellerProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
            if(state is SellerProfileInitial){
              sellerProfileBloc.add(SellerProfileSearch());
              return const Center(child: CircularProgressIndicator());}
            else if(state is SellerProfileFoundState){
              final  foundState = state as SellerProfileFoundState;
              return FoundWidget(
                  userModel: foundState.userProfile,
                  sellerModel: foundState.sellerProfile,
                  sellerProfileBloc: sellerProfileBloc);}
            else if(state is SellerProfileError){
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
        title: const Text('My Selling Profile'),
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
    required this.sellerModel,
    required this.sellerProfileBloc,
  });
  final UserModel userModel;
  final SellerAccountModel sellerModel;
  final SellerProfileBloc sellerProfileBloc;
  void refresh() {
    sellerProfileBloc.add(SellerProfileSearch());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        ListTile(
          title: Text(userModel.username ?? ""),
          subtitle:  Text(userModel.email ?? ""),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: Image.network(userModel.profilePic ??
                    "https://img.freepik.com/premium-vector/user-profile-icon-flat-style-member-avatar-vector-illustration-isolated-background-human-permission-sign-business-concept_157943-15752.jpg?size=338&ext=jpg&ga=GA1.1.1700460183.1708646400&semt=ais")
                .image,
          ),
        ),
        ListProfileTile(
            title: sellerModel.shopName??"", leading: "Shop Image", onTap: () {}),
        ListProfileTile(
            title: sellerModel.email??"", leading: "email Image", onTap: () {}),
        ListProfileTile(
            title: sellerModel.location??"", leading: "location Image", onTap: () {
            }),
      ],
    ));
  }
}

class ListProfileTile extends StatelessWidget {
  const ListProfileTile({
    super.key,
    required this.title,
    this.leading,
    required this.onTap,
  });
  final String title;
  final String? leading;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Text(leading ?? ""),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
      ),
      onTap: onTap,
    );
  }
}
