import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'master_event.dart';
part 'master_state.dart';

class MasterBloc extends Bloc<MasterEvent, MasterState> {
  MasterBloc() : super(MasterInitial(tabIndex: 0)) {
    on<MasterEvent>((event, emit) {
      // TODO: implement event handler
      if(event is TabChange){
         print(event.tabIndex);
        emit(MasterInitial(tabIndex: event.tabIndex));
      }
    });
  }
}
