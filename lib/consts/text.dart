import 'package:beats/consts/colors.dart';
import 'package:flutter/material.dart';

const bold = "bold";
const regular = "Regular";

ourStyle({
  fontfamily = "Regular",
  double? size = 14,
  color = whitecolor,
}) {
  return TextStyle(
    fontFamily: fontfamily,
    fontSize: size,
    color: color,
  );
}
