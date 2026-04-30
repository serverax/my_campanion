// Compose a 1024x1024 square app-icon on the brand dark-green background
// with the logo centered. Output: assets/icon/app_icon.png
// Run with: dart run tools/prepare_icon.dart
import 'dart:io';

import 'package:image/image.dart' as img;

const int canvasSize = 1024;
// Brand dark green #0F3D2E
const int bgR = 0x0F;
const int bgG = 0x3D;
const int bgB = 0x2E;
const double logoFraction = 0.78;

void main() {
  final srcFile = File(
    r'E:\my_campanion\logo Image Apr 26, 2026, 11_54_55 PM.png',
  );
  if (!srcFile.existsSync()) {
    stderr.writeln('Logo source not found: ${srcFile.path}');
    exitCode = 1;
    return;
  }
  final logo = img.decodeImage(srcFile.readAsBytesSync());
  if (logo == null) {
    stderr.writeln('Could not decode logo source.');
    exitCode = 1;
    return;
  }

  // Resize logo so its long edge fills logoFraction of canvas
  final targetLong = (canvasSize * logoFraction).round();
  final logoMax = logo.width > logo.height ? logo.width : logo.height;
  final scale = targetLong / logoMax;
  final scaled = img.copyResize(
    logo,
    width: (logo.width * scale).round(),
    height: (logo.height * scale).round(),
    interpolation: img.Interpolation.cubic,
  );

  // Build canvas with brand background
  final canvas = img.Image(
    width: canvasSize,
    height: canvasSize,
    numChannels: 4,
  );
  img.fill(canvas, color: img.ColorRgba8(bgR, bgG, bgB, 255));

  // Center-composite the scaled logo
  final dx = (canvasSize - scaled.width) ~/ 2;
  final dy = (canvasSize - scaled.height) ~/ 2;
  img.compositeImage(canvas, scaled, dstX: dx, dstY: dy);

  final outDir = Directory('assets/icon');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);
  final outFile = File('${outDir.path}/app_icon.png');
  outFile.writeAsBytesSync(img.encodePng(canvas, level: 6));

  stdout.writeln(
    'app_icon.png  ${canvasSize}x$canvasSize  '
    '${(outFile.lengthSync() / 1024).toStringAsFixed(0)} KB',
  );

  // Also write a foreground (transparent) variant for adaptive icons
  final fg = img.Image(width: canvasSize, height: canvasSize, numChannels: 4);
  img.compositeImage(fg, scaled, dstX: dx, dstY: dy);
  final fgFile = File('${outDir.path}/app_icon_foreground.png');
  fgFile.writeAsBytesSync(img.encodePng(fg, level: 6));
  stdout.writeln(
    'app_icon_foreground.png  ${canvasSize}x$canvasSize  '
    '${(fgFile.lengthSync() / 1024).toStringAsFixed(0)} KB',
  );
}
