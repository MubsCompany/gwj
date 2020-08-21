import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:template/models/Reminder.dart';
import 'package:template/models/ResponseData.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/bloc_provider.dart';
import 'package:template/utils/session.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class GlobalBloc extends Object implements BlocBase {
  @override
  void dispose() {
    _loadingController.close();
    _uploadedFileController.close();
    _roleController.close();
  }
  static final _loadingController = BehaviorSubject<bool>();
  static Stream<bool> get loadingStream => _loadingController.stream;

  static setLoadingController(bool isLoad){
    _loadingController.sink.add(isLoad);
  }

  static final _roleController = BehaviorSubject<String>();
  static Stream<String> get roleStream => _roleController.stream;

  static setRoleController(String role){
    _roleController.sink.add(role);
  }

  List<FocusNode> listFocusNode = [];
  generateFocusNode(int length){
    for (var i = 0; i < length; i++) {
      listFocusNode.add(FocusNode());
    }
  }
  Function(int) get getFocusNode => listFocusNode.elementAt;

  BehaviorSubject<File> _uploadedFileController = BehaviorSubject<File>();
  Stream<File> get uploadedFileStream => _uploadedFileController.stream;
  File getUploadedFile() =>_uploadedFileController.value;
  resetFile() => _uploadedFileController.sink.add(null);
  uploadFile()async{
    GlobalBloc.setLoadingController(true);
    try {
      File file = await ImagePicker.pickImage(source: ImageSource.gallery);
      if(file != null){
        File croppedFile = await ImageCropper.cropImage(
          sourcePath: file.path,
          maxWidth: 512,
          maxHeight: 512,
        );
        _uploadedFileController.sink.add(croppedFile);
      }
    } catch (e) {
      print(e);
    } finally{
      GlobalBloc.setLoadingController(false);
    }
  }
    
  static FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static initializeNotifications() async {
    var initializeAndroid = AndroidInitializationSettings('ic_launcher');
    var initializeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(initializeAndroid, initializeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }
  

  static Future singleNotification(
      DateTime datetime, String message, String subtext, int hashcode,
      {String sound}) async {
    var androidChannel = AndroidNotificationDetails(
      datetime.toString(),
      message,
      subtext,
      importance: Importance.Max,
      priority: Priority.Max,
      icon: 'ic_launcher',
      largeIcon: 'ic_launcher',
      largeIconBitmapSource: BitmapSource.Drawable,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    localNotificationsPlugin.schedule(
        hashcode, message, subtext, datetime, platformChannel,
        payload: hashcode.toString());
  }
  static showSingleNotification({int id = 1,String title="Title",String body = ""})async{
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await initializeNotifications();
    print("GENERATE SINGLE NOTIFICATION");
    var androidChannel = AndroidNotificationDetails(
      id.toString(),
      title,
      body,
      importance: Importance.Max,
      priority: Priority.Max,
      icon: 'ic_launcher',
      // largeIcon: 'ic_launcher',
      // largeIconBitmapSource: BitmapSource.Drawable,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    localNotificationsPlugin.show(id, title, body, platformChannel);
    // localNotificationsPlugin.schedule(
    //     hashcode, message, subtext, datetime, platformChannel,
    //     payload: hashcode.toString());
  }
  static generateNotification({List<Reminder> listReminder})async{
    if(listReminder != null){
      print("GENERATE NOTIFICATION");
      localNotificationsPlugin.cancelAll();
      listReminder.forEach((data)async{
        if(data.reminderDate != null && data.status == "1" && DateTime.parse(data.reminderDate).isAfter(DateTime.now())){
          await singleNotification(DateTime.parse(data.reminderDate), data.reminderContent, "", int.parse(data.reminderId));
        }
      });
    }else{
      if(await Session.getHasScheduled()) return;
      
      localNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await initializeNotifications();
      try {
        print("GENERATE NOTIFICATION");
        String userId = await Session.getUserId();
        var dio = ApiProvider.init();
        Response response = await dio.get("/ReminderService/getReminder/$userId");
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "200"){
          localNotificationsPlugin.cancelAll();
          responseData.data.forEach((data)async{
            if(data['reminderDate'] != null && data['status'] == "1" && DateTime.parse(data.reminderDate).isAfter(DateTime.now())){
              await singleNotification(DateTime.parse(data['reminderDate']), data['reminderContent'], "", int.parse(data['reminderId']));
              print("Generate ${data['reminderDate']} : ${data['reminderId']}");
            }
          });
          Session.setHasScheduled(true);
          print("Success");
        }
      } catch (e) {
        print(e);
      }
    }
  }
  static Future<bool> verifyRole(GlobalKey<FormState> key,String id,String code)async{
    FocusScope.of(key.currentContext).requestFocus(FocusNode());
    bool retVal = false;
    GlobalBloc.setLoadingController(true);
    try {
      if([null,""].contains(id)){
        Toast.show("Please Choose Your Role", key.currentContext,duration: Toast.LENGTH_LONG);
        return false;
      }else if([null,""].contains(code)){
        Toast.show("Please Enter Your Role Code", key.currentContext,duration: Toast.LENGTH_LONG);
        return false;
      }
      var dio = ApiProvider.init();
      Response response = await dio.post("/UserService/verifyRole",data: {"id":id,"roleCode":code});
      ResponseData responseData = ResponseData.fromJson(response.data);
      retVal = (responseData.responseCode == "200");
      if(!retVal){
        Toast.show("Role Code is invalid", key.currentContext,duration: Toast.LENGTH_LONG);
      }
    } catch (e) {
      print(e);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
    return retVal;
  }
}