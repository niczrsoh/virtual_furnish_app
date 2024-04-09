part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();
  
  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final String message;

  const RegisterSuccess({required this.message});
}

final class RegisterFail extends RegisterState {
  final String message;

  const RegisterFail({required this.message});
}

final class RegisterPageButtonEnabled extends RegisterState {
  final bool isButtonEnabled;

  const RegisterPageButtonEnabled({required this.isButtonEnabled});
}

