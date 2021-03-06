import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'log.dart';

abstract class PageState extends Equatable {
  const PageState();
}

abstract class PageEvent extends Equatable {
  const PageEvent();
}

class OnRouteTrigger extends PageEvent {
  @override
  List<Object> get props => [];
}

abstract class RouteState<S extends PageState> {
  final S previous;

  RouteState(this.previous);
}

abstract class PageBloc<E extends PageEvent, S extends PageState>
    extends Bloc<E, S> {
  PageBloc(S initialState) : super(initialState);

  @override
  Stream<S> mapEventToState(E event) async* {
    if (event is OnRouteTrigger) {
      try {
        yield (state as RouteState).previous;
      } catch (e) {
        log('ROUTE', 'Warning state is not `RouteState`');
      }
    } else {
      throw UnsupportedError('Unsupported event: $event');
    }
  }
}

T bloc<T extends Bloc>(BuildContext context) => BlocProvider.of<T>(context);

BlocBuilder<B, S> blocState<B extends Cubit<S>, S>(
  BlocWidgetBuilder<S> builder,
) =>
    BlocBuilder(builder: builder);

BlocBuilder<B, S> blocWhenState<B extends Cubit<S>, S, SS extends S>(
  BlocWidgetBuilder<SS> builder,
) =>
    BlocBuilder(builder: (context, state) {
      if (state is SS) {
        return builder(context, state);
      } else {
        return const SizedBox.shrink();
      }
    });
