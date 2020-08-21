import 'dart:io';

import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/blocs/note/note_bloc.dart';
import 'package:template/models/Note.dart';
import 'package:template/pages/note/add_note_page.dart';
import 'package:template/pages/note/history_note_page.dart';
import 'package:template/pages/note/widget/card_widget.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/widgets/base_container_widget.dart';
import 'package:template/widgets/loading_widget.dart';

class NotePage extends StatefulWidget {
  String roleId;
  NotePage({this.roleId});
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> with SingleTickerProviderStateMixin{
  validRole(){
    return widget.roleId == UIData.sekretarisId;
  }
  TabController _tabController;
  NoteBloc noteBloc;
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
    noteBloc = NoteBloc(isGetData: true);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => validRole() ? GlobalFunction.changePage(context, AddNotePage(noteBloc: this.noteBloc,isValid: validRole(),)):Container(),
            child: Icon(Icons.add),
            backgroundColor: UIData.accentColor,
          ),
          body: Stack(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: <Widget>[
                    IconButton(icon: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                      color: Colors.black,
                    ), onPressed: () => Navigator.pop(context)),
                    Text('Notes', style: TextStyle(fontFamily: 'futura', fontWeight: FontWeight.bold, fontSize: 20),),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 5,
                  color: UIData.accentColor,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: UIData.bcContactColor,
                    tabs: <Widget>[
                      Tab(child: Text("Main Note",textAlign: TextAlign.center,),),
                      Tab(child: Text("History",textAlign: TextAlign.center,),),
                    ],
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 120),
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    StreamBuilder(
                      stream: noteBloc.listNoteStream,
                      builder: (BuildContext ctxStream, AsyncSnapshot<List<Note>> snapshot){
                        if(!snapshot.hasData) return Container();
                        var data = snapshot.data;
                        return ListView.separated(
                          itemCount: data.length,
                          padding: EdgeInsets.all(10),
                          itemBuilder: (BuildContext ctxList, int index){
                            return CardWidget(note: data[index],onTap:() => GlobalFunction.changePage(context, AddNotePage(note: data[index],noteBloc: this.noteBloc,isValid: validRole(),)),noteBloc: this.noteBloc,isValidRole: validRole(),);
                          }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10,),
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: noteBloc.listNoteStream,
                      builder: (BuildContext ctxStream, AsyncSnapshot<List<Note>> snapshot){
                        if(!snapshot.hasData) return Container();
                        var data = snapshot.data;
                        return ListView.separated(
                          itemCount: data.length,
                          padding: EdgeInsets.all(10),
                          itemBuilder: (BuildContext ctxList, int index){
                            return CardWidget(note:data[index],onTap: () => GlobalFunction.changePage(context, HistoryNotePage(data[index])),isValidRole: validRole());
                          }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10,),
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
          builder: (ctxLoading,snapshot){
            return LoadingWidget(snapshot.data);
          },
        ),

      ],
    );
  }
}