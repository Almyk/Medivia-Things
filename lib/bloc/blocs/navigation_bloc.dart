import 'package:bloc/bloc.dart';
import 'package:medivia_things/bloc/event/navigation_state.dart';
import 'package:medivia_things/bloc/state/navigation_event.dart';
import 'package:medivia_things/utils/constants.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  @override
  NavigationState get initialState => VipList();

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async*{
    if (event is ShowVipList) {
      yield VipList();
    }
    if (event is ShowOnlineDestiny) {
      yield OnlineList(server: destiny);
    }
    if (event is ShowOnlineLegacy) {
      yield OnlineList(server: legacy);
    }
    if (event is ShowOnlinePendulum) {
      yield OnlineList(server: pendulum);
    }
    if (event is ShowOnlineProphecy) {
      yield OnlineList(server: prophecy);
    }
    if (event is ShowOnlineStrife) {
      yield OnlineList(server: strife);
    }
  }

}