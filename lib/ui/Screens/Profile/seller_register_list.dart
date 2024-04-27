import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/seller_register_bloc.dart';
import 'package:virtual_furnish_app/ui/Styles/export_styles.dart';

class SellerRegisterList extends StatelessWidget {
  const SellerRegisterList({super.key, required this.sellerRegisterBloc});
  final SellerRegisterBloc sellerRegisterBloc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Register List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final value = await Navigator.pushNamed(context, '/seller_register');
          if (value == "success") {
            sellerRegisterBloc.add(SellerRegisterFetchList());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: PaddingStyles.paddingStyle1,
        child: BlocBuilder<SellerRegisterBloc, SellerRegisterState>(
          builder: (context, state) {
            switch(state.runtimeType){
              case SellerRegisterListFetchedEmpty:
                return ListTile(
                  title: Text('No Seller Registered'),
                );
              case SellerRegisterListFetchedSuccess:
                final sellerInfo = (state as SellerRegisterListFetchedSuccess).sellerList;
                    return ListTile(
                      title: Text(sellerInfo.shopName!),
                      subtitle: Text(sellerInfo.location!),
                    );
              case SellerRegisterListFetchedFail:
                final message = (state as SellerRegisterListFetchedFail).message;
                return ListTile(
                  title: Text('Error'),
                  subtitle: Text(message),
                );
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
