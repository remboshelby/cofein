import 'package:equatable/equatable.dart';

abstract class CafeDetailState extends Equatable {
  const CafeDetailState();
}

class CafeListInitial extends CafeDetailState {
  @override
  List<Object> get props => [];
}

class LoadingState extends CafeDetailState {
  @override
  List<Object> get props => [];
}

abstract class LoadedState extends CafeDetailState {
  @override
  List<Object> get props => [];
}
