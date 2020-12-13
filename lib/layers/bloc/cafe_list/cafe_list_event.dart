import 'package:cofein/layers/drivers/bloc.dart';

abstract class CafeListEvent extends PageEvent {
  const CafeListEvent();
}
class OnLoading extends CafeListEvent {
  @override
  List<Object> get props => [];
}
class OnLoad extends CafeListEvent {
  @override
  List<Object> get props => [];
}
class OnRouteToOrder extends CafeListEvent {

  OnRouteToOrder();
  @override
  List<Object> get props => [];
}
class OnRouteToDetail extends CafeListEvent {
  final int id;

  OnRouteToDetail(this.id);
  @override
  List<Object> get props => [id];
}
class OnShowMyLocation extends CafeListEvent {
  @override
  List<Object> get props => [];
}