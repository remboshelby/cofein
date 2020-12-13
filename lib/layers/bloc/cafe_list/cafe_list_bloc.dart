import 'dart:async';
import 'package:cofein/layers/drivers/bloc.dart';
import 'package:cofein/layers/services/pages/cafe.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bloc.dart';

class CafeListBloc extends PageBloc<CafeListEvent, CafeListState> {
  final CafeService cafeService;

  CafeListBloc(this.cafeService) : super(CafeListInitial());

  @override
  Stream<CafeListState> mapEventToState(
      PageEvent event,
  ) async* {
    if (event is OnLoad) {
      yield* _onLoad(event);
    }else if (event is OnShowMyLocation) {
      yield* _showMyLocation(event);
    } else if (event is OnRouteToDetail) {
      assert(state is LoadedState);
      final previous = state as LoadedState;
      yield LoadingState();
      final item = await cafeService.getCafeById(event.id);
      yield DetailLoadedState(
        cafe: item,
      );
    }
    else if (event is OnRouteToOrder){
      yield LoadingState();
    }
    else if (event is OnLoading){
      yield LoadingState();
    }
  }
  Stream<CafeListState> _showMyLocation(OnShowMyLocation event) async* {
    var locationPermission = await hasLocationPermission();
    // await _plansService.showMyLocation();
    // yield* displayLocationWarningMessage();
  }
  Stream<CafeListState> _onLoad(OnLoad event) async* {
    yield LoadingState();
    await Future.delayed(Duration(milliseconds: 2500));
    final list = await cafeService.getCafeList();
    final location = await getLocationPermission();
    if (location){
      yield LoadedState(list);
    }else {
      yield LoadedState(list);
    }
    yield LoadedState(list);
  }
}
Future<bool> getLocationPermission() async {
  var status = await Permission.location.request();
  return status.isGranted;
}
Future<bool> hasLocationPermission() async {
  var status = await Permission.location.status;
  if (status == PermissionStatus.granted) {
    return true;
  } else {
    return false;
  }
}
