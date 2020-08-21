
import 'package:flutter/cupertino.dart';

class Wave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      _buildWave(context),
    ]);
  }
}

Widget _buildWave(BuildContext context) {
  return Opacity(
    opacity: 1,
    child: Align(
      alignment: Alignment.bottomCenter,
      child:Image.asset('assets/bottom.png',
        width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,),
    ),
  );
}