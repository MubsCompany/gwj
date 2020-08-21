import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/blocs/news/news_bloc.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';
class ChatPage extends StatefulWidget {
  NewsBloc newsBloc;
  String roleId;
  ChatPage({this.newsBloc,this.roleId});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with ValidationMixin{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  NewsBloc newsBloc;
  GlobalBloc globalBloc;
  validRole(){
    return widget.roleId == UIData.sekretarisId;
  }
  isGA(){
    return widget.roleId == UIData.generalAffairId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                Text('Contact Detail', style: TextStyle(fontFamily: 'futura', fontWeight: FontWeight.bold, fontSize: 20),),
              ],
            ),
          ),



        ],
      ),
    );
  }
}