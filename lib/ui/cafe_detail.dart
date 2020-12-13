import 'package:cofein/layers/bloc/cafe_detail/bloc.dart';
import 'package:cofein/layers/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

CafeDetailBloc _bloc(BuildContext context) => BlocProvider.of(context);


class CafeDetailProvider extends StatelessWidget {
  final int id;

  const CafeDetailProvider({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CafeDetailBloc>(
      create: (BuildContext context) => _bloc(context)..add(OnLoad()),
      child: CafeDetail(),
    );
  }
}

class CafeDetail extends StatefulWidget {
  static route(int id) => MaterialPageRoute(
        builder: (context) {
          return CafeDetailProvider(id: id);
        },
      );

  @override
  _CafeDetailState createState() => _CafeDetailState();
}

class _CafeDetailState extends State<CafeDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CofeinColors.red,
    );
  }
}
