import 'package:flutter/material.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/widgets/base_container_widget.dart';
import 'package:pigment/pigment.dart';
class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BaseContainerWidget(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30,),
                Image(
                  image: AssetImage("assets/icon.png"),
                  width: fullWidth / 2,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  color: Colors.white,
                  width: fullWidth,
                  child: Text("WELCOME TO GRIP WORK JOURNEY APPLICATIONS",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),
                              textAlign: TextAlign.center,
                            ),
                ),
                SizedBox(height: 50,),
                MaterialButton(
                  onPressed: ()=> Navigator.of(context).pushNamed("/login"),
                  color: UIData.darkPrimaryColor,
                  minWidth: fullWidth - 150,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text("ALREADY HAVE ACCOUNT",),
                ),
                SizedBox(height: 10,),
                MaterialButton(
                  onPressed: ()=>Navigator.of(context).pushNamed("/register"),
                  color: UIData.accentColor,
                  minWidth: fullWidth - 150,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text("NEED A NEW ACCOUNT",),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}