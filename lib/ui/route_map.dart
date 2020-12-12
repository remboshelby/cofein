import 'package:cofein/layers/ui/colors.dart';
import 'package:cofein/layers/ui/theme.dart';
import 'package:cofein/ui/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class RouteMapProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteMapView();
  }
}

class RouteMapView extends StatefulWidget {
  static Size scSize;

  const RouteMapView({Key key}) : super(key: key);

  static route() => MaterialPageRoute(
        builder: (context) {
          scSize = MediaQuery.of(context).size;
          return RouteMapProvider();
        },
      );

  @override
  _RouteMapViewState createState() => _RouteMapViewState();
}

class _RouteMapViewState extends State<RouteMapView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _pc = PanelController();
  static Size scSize = RouteMapView.scSize;
  static double keyPadding;
  static double _panelHeightOpenGeneral = scSize.height * 0.86;
  static double _panelHeightClosedGeneral = scSize.height * 0.55;

  static double _panelHeightOpenDetailed = scSize.height * 0.66;
  static double _panelHeightClosedDetailed =
      scSize.height * (190 / scSize.height);

  static double _panelHeightOpenRoute = scSize.height * 0.66;
  static double _panelHeightClosedRoute = scSize.height * (190 / scSize.height);
  double _fabPos = 0;

  int pressedDataIndex = 0;

  String currencySymbol = '';

  double zoomButtonsTopCalculatingFunction({
    @required double x,
    @required double screenHeight,
    @required double topPadding,
    @required panelHeightOpen,
    @required panelHeightClosed,
  }) {
    double result = (screenHeight +
                topPadding -
                (x * (panelHeightOpen - panelHeightClosed))) /
            2 -
        panelHeightClosed * 0.65;
    return result;
  }

  final BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(6.0),
    topRight: Radius.circular(6.0),
  );

  final double _parallaxOffset = 0.5;

  @override
  Widget build(BuildContext context) {
    keyPadding = MediaQuery.of(context).viewInsets.bottom;
    _panelHeightOpenGeneral = scSize.height * 0.86 - keyPadding;
    _panelHeightClosedGeneral = scSize.height * 0.55 - keyPadding;

    _panelHeightOpenDetailed = scSize.height * 0.66 - keyPadding;
    _panelHeightClosedDetailed =
        scSize.height * (190 / scSize.height) - keyPadding;

    _panelHeightOpenRoute = scSize.height * 0.66 - keyPadding;
    _panelHeightClosedRoute =
        scSize.height * (190 / scSize.height) - keyPadding;

    return AppScaffold(
      theme: themeConfig(),
      safeAreaTop: false,
      body: Scaffold(
          key: _scaffoldKey,
          body: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              _SlidingPanel(
                panelHeightClosedDetailed: _panelHeightClosedDetailed,
                borderRadius: _borderRadius,
                fabPos: _fabPos,
                ignoreOrNot: false,
                onPanelSlide: (double value) {
                  setState(() {
                    _fabPos = value;
                  });
                },
                panelHeightClosedGeneral: _panelHeightClosedGeneral,
                panelHeightClosedRoute: _panelHeightClosedRoute,
                panelHeightOpenDetailed: _panelHeightOpenDetailed,
                panelHeightOpenGeneral: _panelHeightOpenGeneral,
                panelHeightOpenRoute: _panelHeightOpenRoute,
                parallaxOffset: _parallaxOffset,
                pc: _pc,
              ),
              _PlanBackButton(false),
            ],
          )),
    );
  }
}

class _PlanBackButton extends StatelessWidget {
  final bool ignoreOrNot;

  _PlanBackButton(
    this.ignoreOrNot,
  );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 26 + MediaQuery.of(context).padding.top,
      left: 16,
      child: IgnorePointer(
        ignoring: ignoreOrNot,
        child: _BackButton(
          onTap: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
  }
}

class _SlidingPanel extends StatefulWidget {
  final double panelHeightOpenDetailed;
  final double panelHeightClosedDetailed;
  final double panelHeightOpenRoute;
  final double panelHeightClosedRoute;
  final double panelHeightOpenGeneral;
  final double panelHeightClosedGeneral;
  final PanelController pc;
  final double parallaxOffset;
  final bool ignoreOrNot;
  final double fabPos;
  final BorderRadiusGeometry borderRadius;
  final Function onPanelSlide;

  _SlidingPanel({
    this.panelHeightClosedDetailed,
    this.borderRadius,
    this.fabPos,
    this.ignoreOrNot,
    this.onPanelSlide,
    this.panelHeightClosedGeneral,
    this.panelHeightClosedRoute,
    this.panelHeightOpenDetailed,
    this.panelHeightOpenGeneral,
    this.panelHeightOpenRoute,
    this.parallaxOffset,
    this.pc,
  });

  @override
  __SlidingPanelState createState() => __SlidingPanelState();
}

class __SlidingPanelState extends State<_SlidingPanel> {
  double _panelHeightOpen;
  double _panelHeightClosed = 200;
  bool backdropEnabled = false;

  double _fabPos = 1;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    _panelHeightOpen = screenHeight * .55;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SlidingUpPanel(
          defaultPanelState: PanelState.CLOSED,
          controller: widget.pc,
          maxHeight: _panelHeightOpen,
          minHeight: _panelHeightClosed * 0.65,
          backdropEnabled: backdropEnabled,
          parallaxEnabled: true,
          renderPanelSheet: true,
          parallaxOffset: widget.parallaxOffset,
          onPanelClosed: () {},
          body: Padding(
            padding: EdgeInsets.only(
              bottom: _panelHeightClosed * 0.65,
            ),
            child: _YandexMapView(),
          ),
          panelSnapping: true,
          margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          panelBuilder: (scrollController) {
            return _GeneralSlider(
              scrollController: scrollController,
              onTapObject: () async {
                await widget.pc.close();
              },
              x: widget.fabPos,
            );
          },
          borderRadius: widget.borderRadius,
          onPanelSlide: widget.onPanelSlide,
        ),
        _MapControlPanel(),
      ],
    );
  }
}

class _MapControlPanel extends StatelessWidget {
  final double panelHeightOpen;
  final double panelHeightClosed;
  final double _initFabHeight = 160.0;

  const _MapControlPanel({
    Key key,
    this.panelHeightOpen,
    this.panelHeightClosed,
  }) : super(key: key);

  double zoomButtonsTopCalculatingFunction({
    @required double x,
    @required double screenHeight,
    @required double topPadding,
  }) {
    return (screenHeight +
                topPadding -
                (x * (panelHeightOpen - panelHeightClosed))) /
            2 -
        panelHeightClosed;
  }

  double posButtonsTopCalculatingFunction({@required double x}) {
    return _initFabHeight + x * (panelHeightOpen - panelHeightClosed);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: zoomButtonsTopCalculatingFunction(
            x: _fabPos,
            screenHeight: screenHeight,
            topPadding: MediaQuery.padding.top,
          ),
          right: 16,
          child: _MapZoomPanel(
            onTapZoomIn: () async {},
            onTapZoomOut: () async {},
          ),
        ),
        Positioned(
          bottom: posButtonsTopCalculatingFunction(x: _fabPos),
          right: 16,
          child: _LocationButton(
            onTap: () {
              print("Go to my location");
            },
          ),
        ),
      ],
    );
  }
}

class _LocationButton extends StatelessWidget {
  final Function onTap;

  const _LocationButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: Colors.white,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      mini: true,
      child: Icon(
        Icons.near_me,
        color: Colors.black,
        size: 20,
      ),
    );
  }
}

class _YandexMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return YandexMap(
      onMapTap: (point) {},
      onMapCreated: (controller) async {},
    );
  }
}

class _MapZoomPanel extends StatelessWidget {
  final Function onTapZoomIn;
  final Function onTapZoomOut;

  const _MapZoomPanel({Key key, this.onTapZoomIn, this.onTapZoomOut})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: onTapZoomIn,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          mini: true,
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          ),
        ),
        SizedBox(height: 4),
        FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: onTapZoomOut,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          mini: true,
          child: Icon(
            Icons.remove,
            color: Colors.black,
            size: 30,
          ),
        ),
      ],
    );
  }
}

String refactorNamingByNumber({int num, List<String> options}) {
  assert(num != 0);
  assert(options != null && options.length > 0);
  final sNum = num.toString();
  final l = sNum.length;
  final lastDecimal = int.parse(sNum.substring(l - 1, l));
  final firstDecimal = int.parse(sNum.substring(0, 1));

  String name;

  if (lastDecimal == 0) {
    name = options[2];
  } else if (lastDecimal == 1) {
    name = options[0];
  } else if (lastDecimal < 5) {
    name = options[1];
  } else {
    name = options[2];
  }

  if (l == 2 && firstDecimal == 1) {
    name = options[2];
  }

  return '$num $name';
}

class _GeneralSlider extends StatefulWidget {
  final double x;
  final ScrollController scrollController;
  final void Function() onTapObject;

  const _GeneralSlider({
    Key key,
    this.scrollController,
    this.onTapObject,
    this.x,
  }) : super(key: key);

  @override
  _GeneralSliderState createState() => _GeneralSliderState();
}

class _GeneralSliderState extends State<_GeneralSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [..._mapToLoading()],
    );
  }

  List<Widget> _mapToLoading() => [
        _HeaderTitle(),
        _HeaderBodyDivider(),
        _LoadingSpots(),
      ];
}

class _LoadingSpots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _HeaderBodyDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 2,
      color: CofeinColors.whiteBackground,
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _HeaderTitleText("state.details.title"),
        ],
      ),
    );
  }
}

class _HeaderTitleText extends StatelessWidget {
  final String title;

  const _HeaderTitleText(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: CofeinColors.red,
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final Widget child;
  final Function onTap;

  const _BackButton({Key key, @required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: onTap,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      mini: true,
      child: Padding(
        padding: EdgeInsets.only(right: 4),
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 26,
        ),
      ),
    );
  }
}
