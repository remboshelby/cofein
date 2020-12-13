import 'package:cofein/layers/drivers/bloc.dart';
import 'package:cofein/layers/services/api/schemes.dart';
import 'package:equatable/equatable.dart';

abstract class CafeListState extends PageState {
  const CafeListState();
}

class CafeListInitial extends CafeListState {
  @override
  List<Object> get props => [];
}

class LoadingState extends CafeListState {
  @override
  List<Object> get props => [];
}

class LoadedState extends CafeListState {
  final List<Cafe> cafeList;

  LoadedState(this.cafeList);

  @override
  List<Object> get props => [cafeList];
}

class DetailLoadedState extends CafeListState {
  final CafeDetail cafe;

  DetailLoadedState({this.cafe});

  @override
  List<Object> get props => [cafe];
}

class RouteToDetail extends LoadedState implements RouteState {
  @override
  final LoadedState previous;

  RouteToDetail(
    this.previous,
  ) : super(previous.cafeList);

  @override
  List<Object> get props => [previous];
}
