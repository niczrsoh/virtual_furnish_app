part of 'login_bloc.dart';
abstract class LoginState {
  const LoginState({this.message});
  final String? message;
  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  LoginSuccess({String? message}):super(message: message);

}
class LoginFail extends LoginState {
  LoginFail({String? message}):super(message: message);
}

class LoginPageButtonEnabled extends LoginState {
  final bool isButtonEnabled;
  LoginPageButtonEnabled({required this.isButtonEnabled});
}

