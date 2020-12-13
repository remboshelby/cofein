import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cofein/layers/bloc/cafe_list/bloc.dart';
import 'package:cofein/layers/drivers/dependencies.dart';
import 'package:cofein/layers/drivers/icon_maker.dart';
import 'package:cofein/layers/services/api/schemes.dart';
import 'package:cofein/layers/services/pages/cafe.dart';
import 'package:cofein/layers/ui/colors.dart';
import 'package:cofein/layers/ui/style.dart';
import 'package:cofein/layers/ui/theme.dart';
import 'package:cofein/ui/app_scaffold.dart';
import 'package:cofein/ui/cafe_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:optional/optional.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

CafeListBloc _bloc(BuildContext context) => BlocProvider.of(context);

class RouteMapProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CafeListBloc>(
      create: (_) => CafeListBloc(
        resolveDependency<CafeService>(),
      )..add(OnLoading()),
      child: RouteMapView(),
    );
  }
}

class RouteMapView extends StatefulWidget {
  static Size scSize;

  const RouteMapView({Key key}) : super(key: key);

  @override
  _RouteMapViewState createState() => _RouteMapViewState();
}

class _RouteMapViewState extends State<RouteMapView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _pc = PanelController();
  static Size scSize;
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
    scSize = MediaQuery.of(context).size;
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
            ],
          )),
    );
  }
}

class _UserButton extends StatelessWidget {
  final Function onTap;

  const _UserButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 26 + MediaQuery.of(context).padding.top,
      left: 16,
      child: GestureDetector(
        onTap: onTap,
        child: _UserAvatarBtn(),
      ),
    );
  }
}

class _CupButton extends StatelessWidget {
  final Function onTap;

  const _CupButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 26 + MediaQuery.of(context).padding.top,
      right: 16,
      child: _Cup(
        onTap: onTap,
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
  StreamSubscription _streamSubscription;
  double _panelHeightOpen;
  double _panelHeightClosed = 345;
  bool backdropEnabled = false;
  YandexMapController yandexMapController;

  YandexMap _yandexMap;
  double _fabPos = 1;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    _panelHeightOpen = screenHeight * .90;

    return SlidingUpPanel(
      defaultPanelState: PanelState.CLOSED,
      controller: widget.pc,
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed * 0.65,
      backdropEnabled: backdropEnabled,
      parallaxEnabled: true,
      renderPanelSheet: true,
      parallaxOffset: widget.parallaxOffset,
      onPanelClosed: () {},
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: _panelHeightClosed * 0.65,
            ),
            child: YandexMap(
              onMapTap: (point) {},
              onMapCreated: (controller) async {
                setState(() {
                  yandexMapController = controller;
                });
                await controller.move(
                  zoom: 14,
                  point: const Point(latitude: 55.751244, longitude: 37.618423),
                );
                _bloc(context).add(OnLoad());
                _streamSubscription = _bloc(context).listen((state) async {
                  if (state is LoadedState) {
                    final list = state.cafeList;
                    for (final item in list) {
                      await yandexMapController.addPlacemark(
                        Placemark(
                          point: Point(longitude: item.lon, latitude: item.lat),
                          rawImageData: await createPlacemarkIcon(),
                          opacity: 1.0,
                          onTap: (Point) async {
                            // onTapOnMark(placePoint);
                          },
                        ),
                      );
                    }
                  }
                });
              },
            ),
          ),
          _UserButton(
            onTap: () {},
          ),
          _CupButton(
            onTap: () {
              _bloc(context).add(OnRouteToOrder());
            },
          ),
          _MapControlPanel(
            yandexMapController: yandexMapController,
            panelHeightClosed: _panelHeightClosed,
            panelHeightOpen: _panelHeightOpen,
            fabPos: _fabPos,
            screenHeight: screenHeight,
          ),
        ],
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
    );
  }
}

class _MapControlPanel extends StatelessWidget {
  final double panelHeightOpen;
  final double panelHeightClosed;
  final double fabPos;
  final double screenHeight;
  final YandexMapController yandexMapController;

  const _MapControlPanel({
    Key key,
    this.panelHeightOpen,
    this.yandexMapController,
    this.fabPos,
    this.screenHeight,
    this.panelHeightClosed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 214,
          right: 16,
          child: _MapZoomPanel(
            onTapZoomIn: () async {
              await yandexMapController.zoomIn();
            },
            onTapZoomOut: () async {
              await yandexMapController.zoomOut();
            },
          ),
        ),
        Positioned(
          top: 413,
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

class _Cup extends StatelessWidget {
  final Function onTap;

  const _Cup({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _RoundButton(
      onTap: () {},
      child: SvgPicture.asset(
        'images/cup.svg',
        color: CofeinColors.black,
      ),
    );
  }
}

class _LocationButton extends StatelessWidget {
  final Function onTap;

  const _LocationButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _RoundButton(
      onTap: () {},
      child: Icon(
        Icons.near_me,
        color: Colors.black,
        size: 20,
      ),
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
        GestureDetector(
          onTap: onTapZoomIn,
          child: Container(
            decoration: BoxDecoration(
              color: CofeinColors.white1,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(5.0),
                topRight: const Radius.circular(5.0),
                bottomLeft: const Radius.circular(5.0),
                bottomRight: const Radius.circular(5.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.1),
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 12.5,
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: onTapZoomOut,
          child: Container(
            decoration: BoxDecoration(
              color: CofeinColors.white1,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(5.0),
                topRight: const Radius.circular(5.0),
                bottomLeft: const Radius.circular(5.0),
                bottomRight: const Radius.circular(5.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.1),
              child: Icon(
                Icons.remove,
                color: Colors.black,
                size: 12.5,
              ),
            ),
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
    return BlocBuilder<CafeListBloc, CafeListState>(
      builder: (context, state) {
        if (state is LoadedState) {
          return _Body(
            scrollController: widget.scrollController,
            cafes: state.cafeList,
          );
        } else if (state is LoadingState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [..._mapToLoading()],
          );
        } else if (state is DetailLoadedState) {
          return Container();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  List<Widget> _mapToLoading() => [
        _HeaderBodyDivider(),
        _LoadingSpots(),
      ];
}

class _Body extends StatelessWidget {
  final ScrollController scrollController;
  final List<Cafe> cafes;

  const _Body({
    Key key,
    this.cafes,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SearchTextField(),
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: cafes.length,
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final cafe = cafes[index];
                return CafeItem(
                  id: cafe.id,
                  name: cafe.name,
                  logo: cafe.logo,
                  rating: cafe.rating.isPresent ? cafe.rating.value : 0.0,
                  address: cafe.name,
                  reviewCount: cafe.reviewCount,
                );
              }),
        ),
      ],
    );
  }
}

class CafeDetailItem extends StatelessWidget {
  final int id;
  final String name;
  final String logo;
  final double rating;
  final String address;
  final double reviewCount;
  final String startWorkTime;
  final String stopWorkTime;

  const CafeDetailItem({
    Key key,
    this.name,
    this.address,
    this.logo,
    this.id,
    this.rating,
    this.reviewCount,
    this.startWorkTime = '',
    this.stopWorkTime = '22:00',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _bloc(context).add(OnRouteToDetail(id));
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(
          left: 16,
          top: 17,
          right: 15,
          bottom: 60,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: cofeinHeaderTextStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: cofeinTextStyle,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        RatingBar(
                          initialRating: rating,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                            full: _image('images/star.svg'),
                            half: _image('images/star_half.svg'),
                            empty: _image('images/star_border.svg'),
                          ),
                          itemSize: 13.3,
                          itemPadding: EdgeInsets.only(right: 3.3),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                          ignoreGestures: true,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${rating.toStringAsFixed(2)}',
                          style: cofeinMediumTextStyle,
                        ),
                        const SizedBox(
                          width: 9,
                        ),
                        Text(
                          '$reviewCount оценок',
                          style: cofeinTextStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                CachedNetworkImage(
                  height: 80,
                  width: 80,
                  imageUrl: logo,
                  placeholder: (context, url) => MyIconSpinner(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Открыто до: $stopWorkTime',
                  style: cofeinMedium2TextStyle,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CafeItem extends StatelessWidget {
  final int id;
  final String name;
  final String logo;
  final double rating;
  final String address;
  final double reviewCount;
  final String startWorkTime;
  final String stopWorkTime;

  const CafeItem({
    Key key,
    this.name,
    this.address,
    this.logo,
    this.id,
    this.rating,
    this.reviewCount,
    this.startWorkTime = '',
    this.stopWorkTime = '22:00',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _bloc(context).add(OnRouteToDetail(id));
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(
          left: 16,
          top: 5,
          right: 15,
          bottom: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: cofeinHeaderTextStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: cofeinTextStyle,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        RatingBar(
                          initialRating: rating,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                            full: _image('images/star.svg'),
                            half: _image('images/star_half.svg'),
                            empty: _image('images/star_border.svg'),
                          ),
                          itemSize: 13.3,
                          itemPadding: EdgeInsets.only(right: 3.3),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                          ignoreGestures: true,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${rating.toStringAsFixed(2)}',
                          style: cofeinMediumTextStyle,
                        ),
                        const SizedBox(
                          width: 9,
                        ),
                        Text(
                          '$reviewCount оценок',
                          style: cofeinTextStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CachedNetworkImage(
                      height: 80,
                      width: 80,
                      imageUrl: logo,
                      placeholder: (context, url) =>
                          MyIconSpinner(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'images/running_man.svg',
                          color: CofeinColors.black,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '5 мин',
                          style: cofeinMedium2TextStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Открыто до: $stopWorkTime',
                  style: cofeinMedium2TextStyle,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class MyIconSpinner extends StatefulWidget {
  MyIconSpinner({Key key, this.title, this.color = Colors.blue, this.height =40, this.width=40}) : super(key: key);

  final String title;
  final double height;
  final double width;
  final Color color;

  @override
  _MyIconSpinnerState createState() => _MyIconSpinnerState();
}

class _MyIconSpinnerState extends State<MyIconSpinner>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    _controller.addListener((){
      if(_controller.isCompleted){
        _controller.repeat();
      }
    });

    super.initState();
  }
  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Image.asset(
      "images/coffie.gif",
      height:widget.height,
      width: widget.width,
    );
  }
}
class SearchTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: CofeinColors.grey,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
            top: Radius.circular(16),
          )),
      width: MediaQuery.of(context).size.width,
      height: 36,
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 113,
            child: buildTextField(),
          ),
        ],
      ),
    );
  }
}

Widget buildTextField() {
  return TextField(
    autofocus: false,
    decoration: InputDecoration(
      hintText: 'Поиск',
      border: InputBorder.none,
      prefixIcon: Icon(
        Icons.search,
        color: Colors.grey,
      ),
    ),
  );
}

Widget _image(String asset) {
  return SvgPicture.asset(
    asset,
    color: CofeinColors.black,
  );
}

class _LoadingSpots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyIconSpinner(width: 90,height: 90,);
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

class _RoundButton extends StatelessWidget {
  final Widget child;
  final Function onTap;

  const _RoundButton({Key key, @required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.white,
      onPressed: onTap,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      mini: true,
      child: child,
    );
  }
}

class _UserAvatarBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: SvgPicture.asset(
        'images/user_avatar.svg',
        color: CofeinColors.black,
      ),
    );
  }
}
