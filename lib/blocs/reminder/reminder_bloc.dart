import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/Reminder.dart';
import 'package:template/models/ResponseData.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/bloc_provider.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/session.dart';
import 'package:rxdart/subjects.dart';
import 'package:toast/toast.dart';

class ReminderBloc extends Object implements BlocBase {
  ReminderBloc({bool isGetData = false}){
    if(isGetData) getData();
  }
  @override
  void dispose() {
    _listReminderController.close();
    _contentController.close();
    _bellController.close();
    _dateController.close();
    _timeController.close();
  }
  
  List<Reminder> listReminder = [];
  BehaviorSubject<List<Reminder>> _listReminderController = BehaviorSubject<List<Reminder>>();
  Stream<List<Reminder>> get listReminderStream => _listReminderController.stream;

  BehaviorSubject<String> _contentController = BehaviorSubject<String>();
  // Stream<String> get contentStream => _contentController.stream;
  Function(String) get saveContent => _contentController.sink.add;

  BehaviorSubject<bool> _bellController = BehaviorSubject<bool>();
  Stream<bool> get bellStream => _bellController.stream;
  Function(bool) get saveBell => _bellController.sink.add;

  BehaviorSubject<String> _dateController = BehaviorSubject<String>();
  Stream<String> get dateStream => _dateController.stream;
  Function(String) get saveDate => _dateController.sink.add;

  BehaviorSubject<String> _timeController = BehaviorSubject<String>();
  Stream<String> get timeStream => _timeController.stream;
  Function(String) get saveTime => _timeController.sink.add;

  

  getData()async{
    try {
      GlobalBloc.setLoadingController(true);
      String companyId = await Session.getCompanyId();
      var dio = ApiProvider.init();
      Response response = await dio.get("/ReminderService/getReminder/$companyId");
      ResponseData responseData = ResponseData.fromJson(response.data);
      if(responseData.responseCode == "200"){
        listReminder.clear();
        responseData.data.forEach((data) => listReminder.add(Reminder.fromJson(data)));
        _listReminderController.sink.add(listReminder);
        // GlobalBloc.generateNotification(listReminder: listReminder);
      }
    } on DioError catch (e) {
      print(e);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }
  onSave(GlobalKey<FormState> key, Reminder reminder)async{
    FocusScope.of(key.currentContext).requestFocus(new FocusNode());
    try {
      GlobalBloc.setLoadingController(true);
      if(key.currentState.validate()){
        key.currentState.save();
        String companyId = await Session.getCompanyId();
        var dio = ApiProvider.init();
        Response response;
        if(reminder == null){
          Reminder params = Reminder(
            status: "0",
            companyId: companyId,
            reminderContent: _contentController.value,
          );
          response = await dio.post("/ReminderService/createReminder",data: params);
        }else{
          if(_dateController.value == null || _timeController.value == null){
            GlobalBloc.setLoadingController(false);
            Toast.show("Please Complete The Form", key.currentContext, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
            return;
          }
          Reminder params = Reminder(
            status: _bellController.value ? "1" : "0",
            companyId: companyId,
            reminderContent: _contentController.value,
            reminderDate: _dateController.value + " " + _timeController.value
          );
          print(params.toJson());
          response = await dio.put("/ReminderService/updateReminder/${reminder.reminderId}",data: params);
        }
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          Reminder retVal = Reminder.fromJson(responseData.data);
          if(reminder == null){
            listReminder.add(retVal);
          }else{
            int index = listReminder.indexWhere((data)=>data.reminderId == reminder.reminderId);
            listReminder[index] = retVal;
            // Start Generate Notification
            await GlobalBloc.singleNotification(DateTime.parse(retVal.reminderDate), retVal.reminderContent, "", int.parse(retVal.reminderId));
            // End Generate Notification
          }
          _listReminderController.sink.add(listReminder);
          Navigator.of(key.currentContext).pop();
        }
        Toast.show(responseData.responseDesc, key.currentContext, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
    } catch (e){
      print(e);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }

  onDelete(BuildContext context, Reminder reminder)async{
    GlobalFunction.showConfirmDialog(context, ()async{
      try {
        GlobalBloc.setLoadingController(true);
        var dio = ApiProvider.init();
        Response response = await dio.delete("/ReminderService/deleteReminder/${reminder.reminderId}");
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          listReminder.removeWhere((data) => data.reminderId == reminder.reminderId);
          _listReminderController.sink.add(listReminder);
          // Start Remove Notification
          GlobalBloc.localNotificationsPlugin.cancel(int.parse(reminder.reminderId));
          // End Remove Notification
        }
        Toast.show(responseData.responseDesc, context, duration: Toast.LENGTH_LONG);
        Navigator.of(context).pop();
      } on DioError catch (e) {
        Toast.show(e.message, context, duration: Toast.LENGTH_LONG);
        print(e);
      } finally {
        GlobalBloc.setLoadingController(false);
      }
    });
  }
}