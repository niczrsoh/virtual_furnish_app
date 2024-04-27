part of 'master_bloc.dart';

sealed class MasterState {
  const MasterState({required this.tabIndex,  this.userType});
  final int tabIndex; 
  final String? userType;
  
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