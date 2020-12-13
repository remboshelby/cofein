import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';

Future<Uint8List> createPlacemarkIcon() async {

  final rec = PictureRecorder();
  final canvas = Canvas(rec);
  final dpr = window.devicePixelRatio;
  final paint = Paint();

  String assetName = 'images/cup_point.png';

  paint.isAntiAlias = true;

  final bd = await rootBundle.load(assetName);
  final lst = Uint8List.view(bd.buffer);
  final codec = await instantiateImageCodec(
    lst,
    targetWidth: (54 * dpr).ceil(),
    targetHeight: (66 * dpr).ceil(),
  );

  final frameInfo = await codec.getNextFrame();
  final image = frameInfo.image;

  canvas.drawImage(image, Offset(0, 0), paint);

  var picture = rec.endRecording();
  final img = await picture.toImage(image.width, image.height);

  final byteData = await img.toByteData(format: ImageByteFormat.png);
  return byteData.buffer.asUint8List();
}
