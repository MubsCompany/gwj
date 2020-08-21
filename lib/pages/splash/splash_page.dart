import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/utils/session.dart';
import 'package:template/utils/uidata.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    init();    
    firebaseCloudMessagingListener(context);
    super.initState();
  }
  init() async{
    if(await Session.getHasBeenShownIntroViews()){
      if(await Session.getIsLogin()){
        new Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        });
      }else{
        new Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        });
      }
    }else{
      new Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushNamedAndRemoveUntil('/intro', (Route<dynamic> route) => false);
      });
    }
  }

  void firebaseCloudMessagingListener(BuildContext context) async {
    if (Platform.isIOS) {
      iOSPermission();
    }

    _firebaseMessaging.getToken().then((token) async {
      await Session.setFirebaseToken(token);
      print("TOKEN FIREBASE : "+token);
    });
    _firebaseMessaging.configure(
       onMessage: (Map<String, dynamic> message) async {
         print("onMessage: $message");
         print(message['data']['reminderId']);
         print(message['notification']['title']);
         print(message['notification']['body']);
         GlobalBloc.showSingleNotification(
           id: int.parse(message['data']['reminderId']),
           title: message['notification']['title'],
           body:  message['notification']['body']);
        //  _showItemDialog(message);
       },
      //  onBackgroundMessage: myBackgroundMessageHandler,
       onLaunch: (Map<String, dynamic> message) async {
         print("onLaunch: $message");
        //  _navigateToItemDetail(message);
       },
       onResume: (Map<String, dynamic> message) async {
         print("onResume: $message");
        //  _navigateToItemDetail(message);
       },
     );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: UIData.accentColor,
        // child: Text("SPLASH"),
        child: Image(image: AssetImage("assets/icon.png"),width: MediaQuery.of(context).size.width/2,),
      ),
    );
  }
}