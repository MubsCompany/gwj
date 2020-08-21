import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/ResponseData.dart';
import 'package:template/models/Schedule.dart';
import 'package:template/models/User.dart';
import 'package:template/pages/schedule/schedule_page.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/bloc_provider.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/session.dart';
import 'package:rxdart/subjects.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class ScheduleBloc extends Object implements BlocBase {
  @override
  void dispose() {
    _listScheduleTodayController.close();
    _mapScheduleController.close();
    _dateScheduleTodayController.close();
    _dateController.close();
    _contentController.close();
  }
  List<Schedule> listScheduleToday = [];
  String dateScheduleToday = "";
  BehaviorSubject<List<Schedule>> _listScheduleTodayController = BehaviorSubject<List<Schedule>>();
  Stream<List<Schedule>> get listScheduleTodayStream => _listScheduleTodayController.stream;
  BehaviorSubject<String> _dateScheduleTodayController = BehaviorSubject<String>();
  Stream<String> get dateScheduleTodayStream => _dateScheduleTodayController.stream;

  Map<String,List<Schedule>> mapSchedule = {};
  BehaviorSubject<Map<String,List<Schedule>>> _mapScheduleController = BehaviorSubject<Map<String,List<Schedule>>>();
  Stream<Map<String,List<Schedule>>> get mapScheduleStream => _mapScheduleController.stream;
  
  BehaviorSubject<DateTime> _dateController = BehaviorSubject<DateTime>();
  Function(DateTime) get saveDate => _dateController.sink.add;

  BehaviorSubject<String> _contentController = BehaviorSubject<String>();
  Function(String) get saveContent => _contentController.sink.add;

  getData(BuildContext context)async{
    try {
      GlobalBloc.setLoadingController(true);
      var dio = ApiProvider.init();
      // User user = Storage.getUser();
      String companyId = await Session.getCompanyId();
      Response response = await dio.get("/ScheduleService/getSchedule/$companyId");
      ResponseData responseData = ResponseData.fromJson(response.data);
      if(responseData.responseCode == "200"){
        mapSchedule.clear();
        responseData.data.forEach((data){
          Schedule schedule = Schedule.fromJson(data);
          if(mapSchedule.containsKey(schedule.scheduleDate)){
            mapSchedule[schedule.scheduleDate].add(schedule);
          }else{
            Map<String,List<Schedule>> temp = { schedule.scheduleDate : [schedule] };
            mapSchedule.addAll(temp);
          }
        });
        _mapScheduleController.sink.add(mapSchedule);

        listScheduleToday = mapSchedule[GlobalFunction.formatDate(DateTime.now())];
        _listScheduleTodayController.sink.add(listScheduleToday);

        _dateScheduleTodayController.sink.add(GlobalFunction.formatDate(DateTime.now()));
      }
    } on DioError catch (e) {
      print(e);
      Scaffold.of(context).showSnackBar( SnackBar(
        content: Text(e.message),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.yellow,
          onPressed: () => getData(context),
        ),
      ));
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }

  daySelected(DateTime dateTime,List<dynamic> list){
    _dateScheduleTodayController.sink.add(GlobalFunction.formatDate(dateTime));
    if(list.isNotEmpty){
      _listScheduleTodayController.sink.add(list);
    }else{
      _listScheduleTodayController.sink.add(<Schedule>[]);
    }
  }

  onSave(GlobalKey<FormState> key, Schedule schedule)async{
    FocusScope.of(key.currentContext).requestFocus(new FocusNode());
    try {
      GlobalBloc.setLoadingController(true);
      if(key.currentState.validate()){
        key.currentState.save();
        var dio = ApiProvider.init();
        // User user = Storage.getUser();
        String companyId = await Session.getCompanyId();
        String roleId = await Session.getRoleId();
        Schedule params = Schedule(
          scheduleDate: GlobalFunction.formatDate(_dateController.value),
          companyId: companyId,
          scheduleContent: _contentController.value
        );
        Response response;
        if(schedule?.scheduleId == null){
          response = await dio.post("/ScheduleService/createSchedule",data: params.toJson());
        }else{
          response = await dio.put("/ScheduleService/updateSchedule/${schedule.scheduleId}",data: params.toJson());
        }
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          GlobalFunction.changePage(key.currentContext, SchedulePage(roleId: roleId,));
          Navigator.of(key.currentContext).pop();
          // Navigator.of(key.currentContext).popAndPushNamed("/schedule");
        }
        Toast.show(responseData.responseDesc, key.currentContext,duration: Toast.LENGTH_LONG);
      }
    } on DioError catch (e) {
      print(e.message);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }

  onDelete(BuildContext context, Schedule schedule)async{
    GlobalFunction.showConfirmDialog(context, ()async{
      try {
        GlobalBloc.setLoadingController(true);
        var dio = ApiProvider.init();
        Response response = await dio.delete("/ScheduleService/deleteSchedule/${schedule.scheduleId}");
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          Navigator.of(context).popAndPushNamed("/schedule");
        }
        Toast.show(responseData.responseDesc, context, duration: Toast.LENGTH_LONG);
      } on DioError catch (e) {
        print(e);
      } finally {
        GlobalBloc.setLoadingController(false);
      }
    });
  }
}