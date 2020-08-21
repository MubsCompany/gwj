import 'package:flutter/material.dart';
import 'package:template/blocs/note/note_bloc.dart';
import 'package:template/models/Note.dart';
import 'package:template/utils/uidata.dart';
class CardWidget extends StatelessWidget {
  Note note;
  Function() onTap;
  NoteBloc noteBloc;
  bool isValidRole;
  CardWidget({this.note,this.onTap,this.noteBloc,this.isValidRole = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      // onTap: () => GlobalFunction.changePage(ctx, AddNotePage(note: note,)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: UIData.containerColor,
            ),
            width: double.infinity,
            height: 130,
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(note.noteTitle,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
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
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Text(note.noteContent,overflow: TextOverflow.ellipsis,maxLines: 2,),
                    noteBloc != null ?Positioned(
                      right: 0,
                      bottom: 0,
                      child: isValidRole ? InkWell(
                        onTap: ()=>noteBloc.onDelete(context, note),
                        child: Icon(Icons.delete,color: UIData.bcContactColor,)
                      ):Container(),
                      // child: PopupMenuButton(
                      //   onSelected: (val) => noteBloc.onDelete(context, val),
                      //   icon: Icon(Icons.more_vert,color: UIData.bcContactColor,),
                      //   itemBuilder: (BuildContext popUpContext) {
                      //     return [
                      //       PopupMenuItem(
                      //         value: note,
                      //         child: Text("Delete"),
                      //       )
                      //     ];
                      //   },
                      // ),
                    ) : Container()
                  ],
                ),
              ),

            ],
          )

        ],
      ),
    );
  }
}