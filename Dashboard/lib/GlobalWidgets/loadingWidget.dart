import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:therapy_dashboard/Utils/Colors.dart';

Widget loadingWidget() {
  return Center(
    child: SpinKitFadingCircle(
      color: vermelho, // Cor do indicador de loading
      size: 40.0, // Tamanho do indicador de loading
    ),
  );
}
