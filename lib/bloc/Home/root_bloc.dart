import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(RootInitial()) {
    on<RootEvent>((event, emit) {
    });
  }
}
