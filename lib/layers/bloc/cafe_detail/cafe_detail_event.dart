import 'package:equatable/equatable.dart';

abstract class CafeDetailEvent extends Equatable {
  const CafeDetailEvent();
}
class OnLoad extends CafeDetailEvent {
  @override
  List<Object> get props => [];
}