part of 'seller_register_bloc.dart';

sealed class SellerRegisterEvent extends Equatable {
  const SellerRegisterEvent();

  @override
  List<Object> get props => [];
}

class SellerRegisterCreate extends SellerRegisterEvent {
  final String shopName;
  final String email;
  final String password;
  final String location;
  final String businessType;
  final String? companyBankDoc;
  final String? companySsmDoc;
  final String? individualBankDoc;
  final String? individualIcDoc;

  SellerRegisterCreate({
    required this.shopName,
    required this.email,
    required this.password,
    required this.location,
    required this.businessType,
     this.companyBankDoc,
     this.companySsmDoc,
     this.individualBankDoc,
     this.individualIcDoc,
  });

  @override
  List<Object> get props => [
        shopName,
        email,
        password,
        location,
        businessType,
      ];
}

class SellerRegisterUploadDocument extends SellerRegisterEvent {
  final String docType;
  SellerRegisterUploadDocument({required this.docType});

  @override
  List<Object> get props => [docType];
}

class SellerRegisterBusinessType extends SellerRegisterEvent {
  final String businessType;

  SellerRegisterBusinessType({required this.businessType});

  @override
  List<Object> get props => [businessType];
}

class SellerRegisterUpdate extends SellerRegisterEvent {
  final String shopName;
  final String email;
  final String password;
  final String location;
  final String businessType;
  final String? companyBankDoc;
  final String? companySsmDoc;
  final String? individualBankDoc;
  final String? individualIcDoc;

  SellerRegisterUpdate({
    required this.shopName,
    required this.email,
    required this.password,
    required this.location,
    required this.businessType,
     this.companyBankDoc,
     this.companySsmDoc,
     this.individualBankDoc,
     this.individualIcDoc,
  });

  @override
  List<Object> get props => [
        shopName,
        email,
        password,
        location,
        businessType,
      ];
}

class SellerRegisterDelete extends SellerRegisterEvent{
  final String shopId;

  SellerRegisterDelete({required this.shopId});
  
}

class SellerRegisterPageButtonEnabled extends SellerRegisterEvent {
  final bool isButtonEnabled;

  SellerRegisterPageButtonEnabled({required this.isButtonEnabled});

  @override
  List<Object> get props => [isButtonEnabled];
}
