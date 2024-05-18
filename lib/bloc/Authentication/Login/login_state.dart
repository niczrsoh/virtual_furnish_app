part of 'login_bloc.dart';
abstract class LoginState {
  const LoginState({this.message});
  final String? message;
}

final class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  String? userType;
  LoginSuccess({String? message, this.userType}):super(message: message);

}
class LoginFail extends LoginState {
  LoginFail({String? message}):super(message: message);
}

class LoginPageButtonEnabled extends LoginState {
  final bool isButtonEnabled;
  LoginPageButtonEnabled({required this.isButtonEnabled});
}

class CodeSent extends LoginState {
  final String verificationId;
  CodeSent({required this.verificationId});
}

class CodeFailed extends LoginState {
  final String message;
  CodeFailed({required this.message});
}

class CodeVerified extends LoginState {
  final String message;
  CodeVerified({required this.message});
}
