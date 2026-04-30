// One-shot script to read raw artwork from E:\my_campanion, resize to a
// reasonable max side, and save sanitized filenames into assets/images/.
// Run with: dart run tools/resize_assets.dart
import 'dart:io';

import 'package:image/image.dart' as img;

const Map<String, String> mapping = <String, String>{
  '99 names.png': '99_names.png',
  'adhkar.png': 'adhkar.png',
  'ahlam.png': 'ahlam.png',
  'books.png': 'books.png',
  'duaa.png': 'duaa.png',
  'logo Image Apr 26, 2026, 11_54_55 PM.png': 'logo.png',
  'masjid.png': 'masjid.png',
  'qibla.jpg': 'qibla.jpg',
  'quraan.png': 'quraan.png',
  'shekh.png': 'shekh.png',
};

void main() {
  final src = Directory(r'E:\my_campanion');
  final dst = Directory('assets/images');
  if (!dst.existsSync()) dst.createSync(recursive: true);

  for (final entry in mapping.entries) {
    final srcFile = File('${src.path}\\${entry.key}');
    if (!srcFile.existsSync()) {
      stdout.writeln('SKIP missing: ${entry.key}');
      continue;
    }
    final bytes = srcFile.readAsBytesSync();
    final image = img.decodeImage(bytes);
    if (image == null) {
      stdout.writeln('SKIP undecodable: ${entry.key}');
      continue;
    }

    img.Image out = image;
    final maxSide = image.width > image.height ? image.width : image.height;
    if (maxSide > 512) {
      out = img.copyResize(
        image,
        width: image.width >= image.height ? 512 : null,
        height: image.height > image.width ? 512 : null,
        interpolation: img.Interpolation.cubic,
      );
    }

    final ext = entry.value.toLowerCase().split('.').last;
    final List<int> encoded = ext == 'jpg' || ext == 'jpeg'
        ? img.encodeJpg(out, quality: 88)
        : img.encodePng(out, level: 6);

    final dstFile = File('${dst.path}/${entry.value}');
    dstFile.writeAsBytesSync(encoded);

    stdout.writeln(
      '${entry.value.padRight(16)} '
      '${out.width}x${out.height}  '
      '${(encoded.length / 1024).toStringAsFixed(0)} KB',
    );
  }
}
