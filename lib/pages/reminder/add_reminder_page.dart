import 'dart:io';

import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/blocs/reminder/reminder_bloc.dart';
import 'package:template/models/Reminder.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';
import 'package:template/widgets/loading_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddReminderPage extends StatelessWidget with ValidationMixin{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Reminder reminder;
  ReminderBloc reminderBloc;
  bool validRole = false;
  AddReminderPage({this.reminder,this.reminderBloc,this.validRole});
  @override
  Widget build(BuildContext context) {
    reminderBloc.saveBell(reminder.status == "1");
    if(reminder.reminderDate == null){
      reminderBloc.saveDate(null);
      reminderBloc.saveTime(null);
    }else{
      reminderBloc.saveDate(GlobalFunction.formatDate(DateTime.parse(reminder.reminderDate)));
      reminderBloc.saveTime(GlobalFunction.formatTime(DateTime.parse(reminder.reminderDate))+":00");
    }
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  color: UIData.accentColor,
                  width: double.infinity,
                  height: 150,
                  child: Column(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: <Widget>[
                            IconButton(icon: Icon(
                              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                              color: Colors.black,
                            ), onPressed: () => Navigator.pop(context)),
                            Text('Reminder', style: TextStyle(fontFamily: 'futura', fontWeight: FontWeight.bold, fontSize: 20),),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 100,right: 30),
                        child: Form(
                          key: _formKey,
                          child: Center(
                            child: CustomTextFormFieldWidget(
                              labelText: "REMINDER TITLE",
                              initialValue: reminder.reminderContent,
                              validator: validateRequired,
                              onSaved: reminderBloc.saveContent,
                              readOnly: !validRole,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Positioned(
                  top: 150,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 240,
                    child: ListView(
                      padding: EdgeInsets.only(top: 20),
                      children: <Widget>[
                        ListTile(
                          title: Text("Details", style: TextStyle(fontFamily: 'futura'),),
                        ),
                        ListTile(
                          onTap: ()async{
                            if(validRole){
                              DateTime dateTime = await showDatePicker(
                                context: context,
                                initialDate: (DateTime.parse(reminder.reminderDate ?? DateTime.now().toString())),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100)
                              );
                              if(dateTime != null){
                                reminderBloc.saveDate(GlobalFunction.formatDate(dateTime));
                              }
                            }
                          },
                          leading: Icon(Icons.today,size: 30,),
                          title: Text("Date", style: TextStyle(fontFamily: 'futura'),),
                          subtitle: StreamBuilder(
                            initialData: reminder.reminderDate == null ? "" : GlobalFunction.formatDate(DateTime.parse(reminder.reminderDate)),
                            stream: reminderBloc.dateStream,
                            builder: (BuildContext ctx, AsyncSnapshot<String> snapshot){
                              return Text(snapshot.data);
                            },
                          ),
                        ),
                        ListTile(
                          onTap: ()async{
                            if(validRole){
                              TimeOfDay timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(DateTime.parse(reminder.reminderDate ?? DateTime.now().toString()))
                              );
                              if(timeOfDay != null){
                                String hour = timeOfDay.hour.toString();
                                String minutes = timeOfDay.minute.toString();
                                if(hour.length == 1){
                                  hour = "0"+hour;
                                }
                                if(minutes.length == 1){
                                  minutes = "0"+minutes;
                                }
                                reminderBloc.saveTime("$hour:$minutes:00");
                              }
                            }
                            
                          },
                          leading: Icon(FontAwesomeIcons.clock,size: 30,),
                          title: Text("Time", style: TextStyle(fontFamily: 'futura'),),
                          subtitle: StreamBuilder(
                            initialData: reminder.reminderDate == null ? "" : GlobalFunction.formatTime(DateTime.parse(reminder.reminderDate))+":00",
                            stream: reminderBloc.timeStream,
                            builder: (BuildContext ctx, AsyncSnapshot<String> snapshot){
                              return Text(snapshot.data);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[

                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                onPressed: ()=> validRole ? reminderBloc.onSave(_formKey, reminder):Container(),
                                color: Color(0xff3bc60b),
                                minWidth: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  "Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xffffffff), fontFamily: 'futura', fontSize: 17),
                                ),
                              ),

                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                onPressed: ()=> validRole ? reminderBloc.onDelete(context, reminder): Container(),
                                color: UIData.darkPrimaryColor,
                                minWidth: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  "Delete",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xffffffff), fontFamily: 'futura', fontSize: 17),
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 120,
                  child: StreamBuilder(
                    initialData: reminder.status == "1",
                    stream: reminderBloc.bellStream,
                    builder: (BuildContext ctx, AsyncSnapshot<bool> snapshot){
                      return FloatingActionButton(
                        onPressed: ()=> validRole ? reminderBloc.saveBell(!snapshot.data) : {},
                        child: Icon( snapshot.data ?FontAwesomeIcons.bell : FontAwesomeIcons.bellSlash,size: 20,)
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        StreamBuilder(
          initialData: true,
          stream: GlobalBloc.loadingStream,
          builder: (ctxLoad, AsyncSnapshot<bool> snapLoad){
            return LoadingWidget(snapLoad.data);
          },
        ),
      ],
    );
  }
}