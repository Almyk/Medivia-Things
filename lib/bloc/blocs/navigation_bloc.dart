import 'package:bloc/bloc.dart';
import 'package:medivia_things/bloc/event/navigation_state.dart';
import 'package:medivia_things/bloc/state/navigation_event.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  @override
  // TODO: implement initialState
  NavigationState get initialState => null;

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) {
    // TODO: implement mapEventToState
    return null;
  }

}