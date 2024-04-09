part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterCreation extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterCreation({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [name, email, password, confirmPassword];
}

class RegisterPageEnableButton extends RegisterEvent {
  final bool isButtonEnabled;

  const RegisterPageEnableButton({required this.isButtonEnabled});
}

