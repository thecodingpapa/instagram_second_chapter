import 'dart:convert';

String getProfileImgPath(String username) {
  final encoder = AsciiEncoder();
  List<int> codes = encoder.convert(username);
  int sum = 0;
  codes.forEach((code) => sum += code);

  final imgNum = sum % 1000;

//  print("img num:$imgNum from $sum % 1000 || ${codes.toString()}");

  return "https://cdn.pixabay.com/photo/2013/07/13/10/07/man-156584_960_720.png";
//  return "https://picsum.photos/id/$imgNum/30/30";
}
