import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/seller_register_bloc.dart';
import 'package:virtual_furnish_app/ui/Screens/master_page.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';

final TextEditingController shopNameController = TextEditingController();
 final TextEditingController emailController = TextEditingController();

 final TextEditingController passwordController = TextEditingController();

 final TextEditingController locationController = TextEditingController();
class SellerRegistrationPage extends StatefulWidget {
  final SellerRegisterBloc bloc;
   SellerRegistrationPage({super.key, required this.bloc});

  @override
  State<SellerRegistrationPage> createState() => _SellerRegistrationPageState();
}

class _SellerRegistrationPageState extends State<SellerRegistrationPage> {
  String businessType = 'Individual';

  String companyBankDoc = '';

  String companySsmDoc = '';

  String individualBankDoc = '';

  String individualIcDoc = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Seller Registration'),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: shopNameController,
                    decoration: const InputDecoration(
                      labelText: 'Shop Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                //email
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                //password
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                //location
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),

                  ),
                ),
               
                BlocConsumer<SellerRegisterBloc, SellerRegisterState>(
                  listenWhen:  (previous, current) {
                    if (current is SellerRegisterSuccess) {
                      return true;
                    } else if (current is SellerRegisterFail) {
                      return true;
                    } else if (current is SellerRegisterDocumentUpdated) {
                      return true;
                    } else if (current is SellerRegisterBusinessTypeUpdated) {
                      return true;
                    }
                    return false;
                  },
                          listener: (context, state) {
                if (state is SellerRegisterSuccess) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                  Navigator.pop(context, "success create");
                } else if (state is SellerRegisterFail) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is SellerRegisterDocumentUpdated) {
                  if (state.docType == 'companyBankDoc') {
                    companyBankDoc = state.docPath.name;
                  } else if (state.docType == 'companySsmDoc') {
                    companySsmDoc = state.docPath.name;
                  } else if (state.docType == 'individualBankDoc') {
                    individualBankDoc = state.docPath.name;
                  } else if (state.docType == 'nricDoc') {
                    individualIcDoc = state.docPath.name;
                  }
                } else if (state is SellerRegisterBusinessTypeUpdated) {
                  businessType = state.businessType;
                }
                          },
                          builder: (context, state) {
                return Column(
                  children: [
                       //radio buttons for business type
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text('Business Type: '),
                      Radio(
                        activeColor: Theme.of(context).primaryColor,
                        value: 'Individual',
                        groupValue: businessType,
                        onChanged: (value) {
                          widget.bloc.add(SellerRegisterBusinessType(
                              businessType: value.toString()));
                        },
                      ),
                      const Text('Individual'),
                      Radio(
                        activeColor: Theme.of(context).primaryColor,
                        value: 'Company',
                        groupValue: businessType,
                        onChanged: (value) {
                            widget.bloc.add(SellerRegisterBusinessType(
                              businessType: value.toString()));
                        },
                      ),
                      const Text('Company'),
                    ],
                  ),
                ),
                       Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: (businessType == 'Company')
                                ? Column(
                                    children: [
                                      //submit company bank doc
                                      const Text('Company Bank Doc'),
                                      ElevatedButton(
                                        onPressed: () {
                                          //upload company bank doc
                                          uploadDocument("companyBankDoc");
                                        },
                                        child: Text('Submit',
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                            )),
                                      ),
                                      Text('$companyBankDoc'),
                                      //submit company ssm doc
                                      const Text('Company SSM Doc'),
                                      ElevatedButton(
                                        onPressed: () {
                                          //upload company ssm doc
                                          uploadDocument("companySsmDoc");
                                        },
                                        child: Text('Submit',
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                            )),
                                      ),
                                      Text('$companySsmDoc'),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      const Text('Bank Doc'),
                                      ElevatedButton(
                                        onPressed: () {
                                          //upload individual bank doc
                                          uploadDocument("individualBankDoc");
                                        },
                                        child: Text('Submit',
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                            )),
                                      ),
                                      Text('$individualBankDoc'),
                                      const Text('NRIC Doc'),
                                      ElevatedButton(
                                        onPressed: () {
                                          uploadDocument("nricDoc");
                                        },
                                        child: Text('Submit',
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                            )),
                                      ),
                                      Text('$individualIcDoc'),
                                    ],
                                  )),
                      
                    //submit button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        onPressed: () {
                          widget.bloc.add(SellerRegisterCreate(
                              email: emailController.text,
                              password: passwordController.text,
                              shopName: shopNameController.text,
                              location: locationController.text,
                              businessType: businessType,
                              companyBankDoc: companyBankDoc,
                              companySsmDoc: companySsmDoc,
                              individualBankDoc: individualBankDoc,
                              individualIcDoc: individualIcDoc));
                        },
                        buttonText: 'Submit',
                        isDisabled: false,
                      ),
                    ),
                  ],
                );
                          },
                        ),
              ],
            )));
  }

  void uploadDocument(String docType) {
    //upload document
    widget.bloc.add(SellerRegisterUploadDocument(docType: docType));
  }
}
