import 'package:flutter/material.dart';

class Config {
  final String apiBaseUrl;
  final bool apiLogging;
  final bool diagnostic;
  final bool reportCrashes;

  Config({
    @required this.apiBaseUrl,
    @required this.apiLogging,
    @required this.diagnostic,
    @required this.reportCrashes,
  })  : assert(apiBaseUrl != null),
        assert(apiLogging != null),
        assert(diagnostic != null),
        assert(reportCrashes != null);

  Config copyWith({
    String apiBaseUrl,
    bool apiLogging,
    bool diagnostic,
    bool reportCrashes,
  }) {
    return Config(
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      apiLogging: apiLogging ?? this.apiLogging,
      diagnostic: diagnostic ?? this.diagnostic,
      reportCrashes: reportCrashes ?? this.reportCrashes,
    );
  }
}


class AppConfig extends InheritedWidget {
  final Config config;

  const AppConfig({
    @required this.config,
    @required Widget child,
  })  : assert(config != null),
        super(child: child);

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}