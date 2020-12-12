import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppScaffold extends StatelessWidget {
  final ThemeData theme;
  final Widget background;
  final Widget body;
  final bool safeArea;
  final bool safeAreaBottom;
  final bool safeAreaTop;
  final Widget bottomNavigationBar;
  final AppBar appBar;

  const AppScaffold({
    Key key,
    @required this.theme,
    this.background,
    @required this.body,
    this.safeAreaBottom = true,
    this.safeAreaTop = true,
    this.safeArea = true,
    this.bottomNavigationBar,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = theme.primaryColorBrightness;

    final SystemUiOverlayStyle overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return Theme(
      data: theme,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Scaffold(
          appBar: appBar,
          bottomNavigationBar: bottomNavigationBar,
          body: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyText2,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned.fill(
                  child: Container(color: theme.scaffoldBackgroundColor),
                ),
                Positioned.fill(child: background ?? SizedBox.shrink()),
                safeArea
                    ? SafeArea(
                        top: safeAreaTop,
                        bottom: safeAreaBottom,
                        child: SizedBox(width: double.infinity, child: body),
                      )
                    : SizedBox(width: double.infinity, child: body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
