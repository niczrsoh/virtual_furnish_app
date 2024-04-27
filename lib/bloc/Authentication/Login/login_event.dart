part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class FillLoginForm extends LoginEvent {
  final String email;
  final String password;

  FillLoginForm({required this.email, required this.password});
}

class SelectGoogleAccount extends LoginEvent {
  SelectGoogleAccount();
}

class AddPhoneNumber extends LoginEvent {
  final String phoneNumber;

  AddPhoneNumber({required this.phoneNumber});
}

class AddGuest extends LoginEvent {
  AddGuest();
}

class LoginPageEnableButton extends LoginEvent {
  final bool isButtonEnabled;

  LoginPageEnableButton({required this.isButtonEnabled});
}

class VerifyCode extends LoginEvent {
  final String code;
  final String verificationId;

  VerifyCode({required this.code, required this.verificationId});
}