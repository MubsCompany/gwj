import 'package:flutter/material.dart';
class BaseContainerWidget extends StatelessWidget {
  Widget child;
  BaseContainerWidget({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/new_background.jpg"),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter
        )
      ),
      child: this.child,
    );
  }
}