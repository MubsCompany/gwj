
import 'package:flutter/cupertino.dart';

class HeaderWave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      _buildHeaderWave(context),
    ]);
  }
}

Widget _buildHeaderWave(BuildContext context) {
  return Opacity(
    opacity: 1,
    child: Align(
      alignment: Alignment.topCenter,
      child:Image.asset('assets/ellipse_header.png',
        width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,),
    ),
  );
}