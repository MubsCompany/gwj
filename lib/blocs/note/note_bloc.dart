import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/User.dart';
import 'package:template/models/Note.dart';
import 'package:template/models/ResponseData.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/bloc_provider.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/session.dart';
import 'package:rxdart/subjects.dart';
import 'package:toast/toast.dart';

class NoteBloc extends Object implements BlocBase {
  NoteBloc({isGetData = false}){
    if(isGetData) getData();
  }
  @override
  void dispose() {
    _listNoteController.close();
    _titleController.close();
    _contentController.close();
    _listHistoryNoteController.close();
    _listSelectedRoleController.close();
  }

  List<Note> listNote = [];
  BehaviorSubject<List<Note>> _listNoteController = BehaviorSubject<List<Note>>();
  Stream<List<Note>> get listNoteStream => _listNoteController.stream;

  List<Note> listHistoryNote = [];
  BehaviorSubject<List<Note>> _listHistoryNoteController = BehaviorSubject<List<Note>>();
  Stream<List<Note>> get listHistoryNoteStream => _listHistoryNoteController.stream;

  BehaviorSubject<String> _titleController = BehaviorSubject<String>();
  Function(String) get saveTitle => _titleController.sink.add;

  BehaviorSubject<String> _contentController = BehaviorSubject<String>();
  Function(String) get saveContent => _contentController.sink.add;

  List<String> listSelectedRole = [];
  BehaviorSubject<List<String>> _listSelectedRoleController = BehaviorSubject<List<String>>();
  Stream<List<String>> get listSelectedRoleStream => _listSelectedRoleController.stream;

  addSelectedRole(String id){
    listSelectedRole.add(id);
    _listSelectedRoleController.sink.add(listSelectedRole);
  }

  addAllSelectedRole(List<String> data){
    listSelectedRole = data;
    _listSelectedRoleController.sink.add(listSelectedRole);
  }

  removeSelectedRole(String id){
    listSelectedRole.remove(id);
    _listSelectedRoleController.sink.add(listSelectedRole);
  }

  getData() async {
    try {
      GlobalBloc.setLoadingController(true);
      var dio = ApiProvider.init();
      // User user = Storage.getUser();
      String companyId = await Session.getCompanyId();
      String roleId = await Session.getRoleId();
      Response response = await dio.get("/NoteService/getNote/$companyId/$roleId");
      ResponseData responseData = ResponseData.fromJson(response.data);
      if(responseData.responseCode == "200"){
        listNote.clear();
        responseData.data.forEach((data){
          listNote.add(Note.fromJson(data));
        });
        _listNoteController.sink.add(listNote);
      }
    } catch (e) {
      print(e);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }
  onSave(GlobalKey<FormState> key, Note note)async{
    FocusScope.of(key.currentContext).requestFocus(new FocusNode());
    try {
      GlobalBloc.setLoadingController(true);
      if(key.currentState.validate()){
        key.currentState.save();
        // User user = Storage.getUser();
        String companyId = await Session.getCompanyId();
        var dio = ApiProvider.init();
        Note params = Note(
          noteContent: _contentController.value,
          noteDate: GlobalFunction.formatDateTime(DateTime.now()),
          noteTitle: _titleController.value,
          companyId: companyId,
          roleDestination: jsonEncode(_listSelectedRoleController.value)
        );
        Response response;
        if(note == null){
          response = await dio.post("/NoteService/createNote",data: params.toJson());
        }else{
          response = await dio.put("/NoteService/updateNote/${note.noteId}",data: params.toJson());
        }
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          Note retVal = Note.fromJson(responseData.data);
          if(note == null){
            listNote.add(retVal);
          }else{
            int index = listNote.indexWhere((data)=>data.noteId == note.noteId);
            listNote[index] = retVal;
          }
          _listNoteController.sink.add(listNote);
          Navigator.of(key.currentContext).pop();
        }
        Toast.show(responseData.responseDesc, key.currentContext, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
    } on DioError catch (e) {
      print(e);
      Toast.show(e.message, key.currentContext, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }

  onDelete(BuildContext context, Note note)async{
    GlobalFunction.showConfirmDialog(context, ()async{
      try {
        GlobalBloc.setLoadingController(true);
        var dio = ApiProvider.init();
        Response response = await dio.delete("/NoteService/deleteNote/${note.noteId}");
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          listNote.removeWhere((data) => data.noteId == note.noteId);
          _listNoteController.sink.add(listNote);
          // Navigator.of(context).pop();
        }
        Toast.show(responseData.responseDesc, context, duration: Toast.LENGTH_LONG);
      } on DioError catch (e) {
        Toast.show(e.message, context, duration: Toast.LENGTH_LONG);
        print(e);
      } finally {
        GlobalBloc.setLoadingController(false);
      }
    });
  }
  getHistory(Note note){
    try {
      GlobalBloc.setLoadingController(true);
      var listData = jsonDecode(note.noteHistory);
      listData.forEach((data)=>listHistoryNote.add(Note.fromJson(data)));
      _listHistoryNoteController.sink.add(listHistoryNote);
    } catch (e) {
      print(e);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }
}