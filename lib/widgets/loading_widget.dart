import 'package:flutter/material.dart';
import 'package:template/utils/uidata.dart';

class LoadingWidget extends StatelessWidget {
  bool show = false;

  LoadingWidget(this.show);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: show ? Container(
          child: Center(
            child: 
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(UIData.darkPrimaryColor),
            ),
          ),
          color: Colors.white.withOpacity(0.8),
        )
      : Container());
  }
}
