import 'dart:async';
import 'package:bloc/bloc.dart';
import 'bloc.dart';

class CafeDetailBloc extends Bloc<CafeDetailEvent, CafeDetailState> {
  CafeDetailBloc() : super(CafeListInitial());

  @override
  Stream<CafeDetailState> mapEventToState(
    CafeDetailEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
