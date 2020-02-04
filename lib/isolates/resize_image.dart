import 'dart:io';
import 'package:image/image.dart';

File getResizedImage(File file) {
  Image image = decodeImage(file.readAsBytesSync());
  Image thumbnail = copyResizeCropSquare(image, 300);

  return File(file.path.substring(0, file.path.length - 3) + "jpg")
    ..writeAsBytesSync(encodeJpg(thumbnail, quality: 50));
}
