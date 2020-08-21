import 'dart:io';

import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/blocs/schedule/schedule_bloc.dart';
import 'package:template/models/Schedule.dart';
import 'package:template/pages/schedule/add_schedule_page.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/widgets/loading_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatefulWidget {
  String roleId;

  SchedulePage({this.roleId});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  validRole() {
    return widget.roleId == UIData.sekretarisId;
  }

  ScheduleBloc scheduleBloc = ScheduleBloc();
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scheduleBloc.getData(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: UIData.accentColor,
            onPressed: () => validRole() ? GlobalFunction.popAndChangePage(
                context,
                AddSchedulePage(
                  schedule: Schedule(
                      scheduleDate:
                      _calendarController.selectedDay.toString()),
                )): Container(),
            child: Icon(Icons.add),
          ),
          body: ListView(
            shrinkWrap: true,
            children: <Widget>[

              // tulisan schedule yg di atas bersama jajaranya
              Row(
                children: <Widget>[
                  IconButton(icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                    color: Colors.black,
                  ), onPressed: () => Navigator.pop(context)),
                  Text('Schedule', style: TextStyle(fontFamily: 'futura', fontWeight: FontWeight.bold, fontSize: 20),),
                ],
              ),

              // calendar
              Container(
                child: StreamBuilder(
                  stream: scheduleBloc.mapScheduleStream,
                  builder: (BuildContext mapCtx,
                      AsyncSnapshot<Map<String, List<Schedule>>> snapshot) {
                    Map<DateTime, List<Schedule>> mapevents = {};
                    if (snapshot.hasData) {
                      snapshot.data.forEach((index, list) {
                        Map<DateTime, List<Schedule>> temp = {
                          DateTime.parse(index): list
                        };
                        mapevents.addAll(temp);
                      });
                      return TableCalendar(
                        onDaySelected: scheduleBloc.daySelected,
                        locale: "en_US",
                        calendarController: _calendarController,
                        events: mapevents,
                        builders: CalendarBuilders(
                            markersBuilder: (ctx, date, events, holidays) {
                              final children = <Widget>[];
                              if (events.isNotEmpty) {
                                var count = events.length;
                                children.add(
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    width: 10,
                                    height: 10,
                                    child: Center(
                                        child: Text(
                                          "${count < 10 ? count : "9+"}",
                                          style: TextStyle(
                                              fontSize: 5, color: Colors.white),
                                        )),
                                  ),
                                );
                              }
                              return children;
                            }),
                      );
                    }
                    return Container();
                  },
                ),
              ),

              // tulisan schedule di bawah
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: UIData.accentColor,
//                        border: Border(
//                          top: BorderSide(color: Colors.black,width: 1),
//                          bottom: BorderSide(color: Colors.black,width: 1),
//                        )
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: StreamBuilder(
                          initialData: "",
                          stream: scheduleBloc.dateScheduleTodayStream,
                          builder: (BuildContext ctxDate,
                              AsyncSnapshot<String> snapshot) {
                            return Column(
                              children: <Widget>[
                                Text(
                                  "Schedule",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Colors.white),
                                ),
                                Text("(${snapshot.data})",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ],
                            );
                          },
                        )),
                    StreamBuilder(
                      stream: scheduleBloc.listScheduleTodayStream,
                      builder: (BuildContext ctxList,
                          AsyncSnapshot<List<Schedule>> snapshot) {
                        if (!snapshot.hasData || snapshot.data.isEmpty) {
                          return Container();
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            Schedule data = snapshot.data.elementAt(index);
                            return ListTile(
                              title: Text(data.scheduleContent),
                              trailing: validRole()
                                  ? Container(
                                width: 60,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () =>
                                          GlobalFunction.popAndChangePage(
                                              context,
                                              AddSchedulePage(
                                                schedule: data,
                                              )),
                                      child: Icon(Icons.edit),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () => scheduleBloc.onDelete(
                                          context, data),
                                      child: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              )
                                  : Container(
                                width: 60,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        StreamBuilder(
          initialData: true,
          stream: GlobalBloc.loadingStream,
          builder: (ctxLoading, snapshot) {
            return LoadingWidget(snapshot.data);
          },
        )
      ],
    );
  }
}

