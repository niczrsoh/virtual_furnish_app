part of 'master_bloc.dart';

sealed class MasterState extends Equatable {
  const MasterState({required this.tabIndex});
  final int tabIndex; 
  @override
  List<Object> get props => [tabIndex];
}

final class MasterInitial extends MasterState {
  MasterInitial({required super.tabIndex});
}
