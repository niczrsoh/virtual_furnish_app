// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'master_bloc.dart';

sealed class MasterEvent extends Equatable {
  const MasterEvent();

  @override
  List<Object> get props => [];
}

class TabChange extends MasterEvent {
  int tabIndex;
  TabChange({
    required this.tabIndex,
  });
  
}
