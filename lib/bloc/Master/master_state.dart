part of 'master_bloc.dart';

sealed class MasterState extends Equatable {
  const MasterState({required this.tabIndex,  this.userType});
  final int tabIndex; 
  final String? userType;
  //copywith
  @override
  List<Object> get props => [tabIndex, userType!];
  
}
final class MasterInitial extends MasterState {
  MasterInitial({required super.tabIndex, super.userType});
}
final class MasterTabChanged extends MasterState {
  MasterTabChanged({required super.tabIndex, required super.userType});
}
final class MasterUserDataFetched extends MasterState {
  MasterUserDataFetched({required super.tabIndex, required  super.userType});
}