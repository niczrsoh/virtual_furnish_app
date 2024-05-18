// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'master_bloc.dart';

sealed class MasterEvent {
  const MasterEvent();

}
class FetchUserData extends MasterEvent {
  FetchUserData();
}

class TabChange extends MasterEvent {
  int tabIndex;
  TabChange({
    required this.tabIndex,
  });
}
