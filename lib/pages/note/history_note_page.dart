import 'dart:io';

import 'package:flutter/material.dart';
import 'package:template/blocs/note/note_bloc.dart';
import 'package:template/models/Note.dart';
import 'package:template/pages/note/widget/card_widget.dart';
class HistoryNotePage extends StatelessWidget {
  Note note;
  HistoryNotePage(this.note);
  NoteBloc noteBloc = NoteBloc();
  @override
  Widget build(BuildContext context) {
    noteBloc.getHistory(this.note);
    return Scaffold(
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
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder(
              stream: noteBloc.listHistoryNoteStream,
              builder: (BuildContext ctx, AsyncSnapshot<List<Note>> snapshot) {
                if(!snapshot.hasData) return Container();
                return ListView.separated(
                  separatorBuilder: (BuildContext ctxsp, int index) => SizedBox(height: 10,),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext ctxbuild, int index)=>CardWidget(note: snapshot.data[index],),
                );
              },
            )
          ),
        ],
      ),
    );
  }
}