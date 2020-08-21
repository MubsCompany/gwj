import 'dart:io';

import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/blocs/schedule/schedule_bloc.dart';
import 'package:template/models/Schedule.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';
import 'package:template/widgets/date_picker_widget.dart';
import 'package:template/widgets/loading_widget.dart';
class AddSchedulePage extends StatefulWidget {
  Schedule schedule;
  AddSchedulePage({this.schedule});
  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> with ValidationMixin{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ScheduleBloc scheduleBloc;

  TextEditingController _contentController;
  @override
  void initState() {
    _contentController = TextEditingController(text: widget.schedule?.scheduleContent);
    
    scheduleBloc = ScheduleBloc();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  color: Colors.black,
                ), onPressed: () => Navigator.pop(context)),
                Text('Contact Detail', style: TextStyle(fontFamily: 'futura', fontWeight: FontWeight.bold, fontSize: 20),),
              ],
            ),
          ),

          Card(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)),
            color: Color(0xeeeeeeee),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    DatePickerWidget(
                      onSave: scheduleBloc.saveDate,
                      validator: validateDate,
                      initialValue: widget.schedule == null ? null : DateTime.parse(widget.schedule.scheduleDate),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          border: Border.all(
                              color: Color(0x9f9f9f9f), width: 1),
                          borderRadius:
                          BorderRadius.all(Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CustomTextFormFieldWidget(
                            border: InputBorder.none,
                            labelText: "Content",
                            onSaved: scheduleBloc.saveContent,
                            validator: validateRequired,
                            textEditingController: _contentController,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                        minWidth: double.infinity,
                        color: UIData.accentColor,
                        onPressed: ()=>scheduleBloc.onSave(_formKey,widget.schedule),
                        child: Text("Save", style: TextStyle(color: Colors.white, fontFamily: 'futura', fontSize: 17),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}