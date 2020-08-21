import 'dart:io';

import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/blocs/reminder/reminder_bloc.dart';
import 'package:template/models/Reminder.dart';
import 'package:template/pages/reminder/add_reminder_page.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';
import 'package:template/widgets/loading_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReminderPage extends StatelessWidget with ValidationMixin{
  String roleId;
  ReminderPage({this.roleId});
  validRole(){
    return roleId == UIData.sekretarisId;
  }
  ReminderBloc reminderBloc = ReminderBloc(isGetData: true);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Click On Reminder Title To Set Alarm",
                  style: TextStyle(color: UIData.bcContactColor, fontFamily: 'futura')
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height - 143,
                child: StreamBuilder(
                  stream: reminderBloc.listReminderStream,
                  builder: (BuildContext ctxStream, AsyncSnapshot<List<Reminder>> snapshot){
                    if(!snapshot.hasData) return Container();
                    return ListView.separated(
                      separatorBuilder: (ctxSeparated,i) => SizedBox(height: 10,),
                      padding: EdgeInsets.all(10),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext ctxList, int i){
                        Reminder data = snapshot.data[i];
                        return InkWell(
                          onTap: ()=> GlobalFunction.changePage(context, AddReminderPage(reminder: data,reminderBloc: reminderBloc,validRole: validRole(),)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff5f79be),
                                ),
                                child: Center(child: Text(data.reminderContent[0],style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius:BorderRadius.circular(5),
                                    color: UIData.accentColor
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(data.reminderContent,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: Colors.white),),
                                      SizedBox(height: 5,),
                                      Text(data.reminderDate ?? "Date Not Set", style: TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                ),
                              ),
                              data.status == "1" ? Icon(FontAwesomeIcons.bell) : Icon(FontAwesomeIcons.bellSlash),
                              SizedBox(width: 20,)
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              )

            ],
          ),
          floatingActionButton: validRole() ? FloatingActionButton(
            onPressed: ()=> showDialogReminderTitle(context),
            backgroundColor: UIData.accentColor,
            child: Text("+",style: TextStyle(fontSize: 28,fontWeight: FontWeight.normal),),
          ):null,
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

  showDialogReminderTitle(BuildContext context){
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Reminder Title'),
          content: Form(
            key: _formKey,
            child: CustomTextFormFieldWidget(
              hintText: "Reminder Title",
              onSaved: reminderBloc.saveContent,
              validator: validateRequired,
              // controller: _textFieldController,
              // decoration: InputDecoration(hintText: "Reminder Title"),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () => reminderBloc.onSave(_formKey, null),
            ),
          ],
        );
      });
  }
}