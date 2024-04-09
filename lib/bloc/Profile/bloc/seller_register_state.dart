part of 'seller_register_bloc.dart';

sealed class SellerRegisterState extends Equatable {
  const SellerRegisterState();
  
  @override
  List<Object> get props => [];
}

final class SellerRegisterInitial extends SellerRegisterState {}

final class SellerRegisterSuccess extends SellerRegisterState {
  final String message;

  const SellerRegisterSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class SellerRegisterFail extends SellerRegisterState {
  final String message;

  const SellerRegisterFail({required this.message});

  @override
  List<Object> get props => [message];
}

final class SellerRegisterDocumentUpdated extends SellerRegisterState {
  final String docType;
  final PlatformFile docPath;

  const SellerRegisterDocumentUpdated({required this.docType, required this.docPath});

  @override
  List<Object> get props => [docType, docPath];
}

final class SellerRegisterBusinessTypeUpdated extends SellerRegisterState {
  final String businessType;

  const SellerRegisterBusinessTypeUpdated({required this.businessType});

  @override
  List<Object> get props => [businessType];
}
