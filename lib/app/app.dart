import 'package:cofein/app/locale/strings.dart';
import 'package:cofein/layers/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forms/strings.dart';

class CofeinApp extends StatefulWidget {
  final Widget home;

  const CofeinApp({
    @required this.home,
    Key key,
  }) : super(key: key);

  @override
  _CofeinAppState createState() => _CofeinAppState();
}

class _CofeinAppState extends State<CofeinApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppStringsDelegate(),
        FormsStringsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
      theme: themeConfig(),
      home: widget.home,
    );
  }
}
