import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/blocs/note/note_bloc.dart';
import 'package:template/models/Note.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';
import 'package:template/widgets/loading_widget.dart';
class AddNotePage extends StatefulWidget {
  Note note = Note();
  NoteBloc noteBloc;
  bool isValid = false;
  AddNotePage({this.note,this.noteBloc,this.isValid});
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> with ValidationMixin{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode _titleFocusNode = FocusNode();
  FocusNode _contentFocusNode = FocusNode();

  TextEditingController titleController;
  TextEditingController contentController;

  NoteBloc noteBloc;
  @override
  void initState() {
    titleController = TextEditingController(text: widget.note?.noteTitle);
    contentController = TextEditingController(text: widget.note?.noteContent);
    noteBloc = widget.noteBloc;
    if(widget.note != null){
      List<String> current = [];
      for (var item in jsonDecode(widget.note.roleDestination)) {
        current.add(item.toString());
      }
      noteBloc.addAllSelectedRole(current);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: UIData.accentColor,
            child: Icon(Icons.save),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.isValid ? showDialog(
                context: context,
                builder: (ctxDialog){
                  return AlertDialog(
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(ctxDialog).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Ok"),
                        onPressed: () =>noteBloc.onSave(_formKey, widget.note),
                      ),
                    ],
                    title: Text("Choose Role"),
                    content: StreamBuilder(
                      // initialData: [],
                        stream: noteBloc.listSelectedRoleStream,
                        builder: (BuildContext ctxRole, AsyncSnapshot<List<String>> snapshot) {
                          // if (!snapshot.hasData) return Container();
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              generateListRole(snapshot.data, "1", "Direktur"),
                              generateListRole(snapshot.data, "2", "General Manager"),
                              generateListRole(snapshot.data, "4", "General Affair"),
                              generateListRole(snapshot.data, "5", "Staff"),
                              generateListRole(snapshot.data, "6", "Admin"),
                            ],
                          );
                        }
                    ),

                  );
                }
            ): Container();
            }
          ),
          body: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                    color: Colors.black,
                  ), onPressed: () => Navigator.pop(context)),
                  Text('Detail Notes', style: TextStyle(fontFamily: 'futura', fontWeight: FontWeight.bold, fontSize: 20),),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: UIData.containerColor,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: CustomTextFormFieldWidget(
                            readOnly: !widget.isValid,
                            contentPadding: EdgeInsets.all(10),
                            hintText: "NOTES TITLE",
                            border: InputBorder.none,
                            focusNode: _titleFocusNode,
                            nextFocusNode: _contentFocusNode,
                            textEditingController: titleController,
                            validator: validateRequired,
                            onSaved: noteBloc.saveTitle,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xeeeeeeee),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(0, 3), // changes position of shadow
                              )
                            ],
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 45,
                          child: CustomTextFormFieldWidget(
                            readOnly: !widget.isValid,
                            contentPadding: EdgeInsets.only(top:10,right:10,bottom:10,left:10),
                            hintText: "MAIN NOTES",
                            border: InputBorder.none,
                            maxLines: null,
                            focusNode: _contentFocusNode,
                            textEditingController: contentController,
                            validator: validateRequired,
                            onSaved: noteBloc.saveContent
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        StreamBuilder(
          initialData: false,
          stream: GlobalBloc.loadingStream,
          builder: (BuildContext ctxLoading, AsyncSnapshot<bool> snapshot){
            return LoadingWidget(snapshot.data);
          },
        )
      ],
    );
  }
  Widget generateListRole(List<String> data,String val,String title){
    return ListTile(
      leading: Checkbox(
        onChanged: (bool value) {
          if(value){
            noteBloc.addSelectedRole(val);
          }else{
            noteBloc.removeSelectedRole(val);
          }
        },
        value: data?.contains(val) ?? false,
      ),
      title: Text(title),
    );
  }
}