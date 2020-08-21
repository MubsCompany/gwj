import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/blocs/news/news_bloc.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';
class AddNewsPage extends StatefulWidget {
  NewsBloc newsBloc;
  String roleId;
  AddNewsPage({this.newsBloc,this.roleId});
  @override
  _AddNewsPageState createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> with ValidationMixin{
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
  void initState() {
    // TODO: implement initState
    super.initState();
    newsBloc  = widget.newsBloc;
    globalBloc = GlobalBloc();
  }
  @override
  Widget build(BuildContext context) {
    globalBloc.generateFocusNode(2);
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

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () => globalBloc.uploadFile(),
                    child: DottedBorder(
                      radius: Radius.circular(50),
                      color: Colors.grey,
                      strokeWidth: 3,
                      dashPattern: [10],
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Center(
                          child: StreamBuilder(
                            stream: globalBloc.uploadedFileStream,
                            builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                              if(snapshot.hasData){
                                return Image(image: FileImage(snapshot.data),fit: BoxFit.fitHeight,height: double.infinity,);
                              } 
                              return Icon(Icons.image);
                            },
                          ),
                        )
                      ),
                    ),
                  ),
                  CustomTextFormFieldWidget(
                    labelText: "Title",
                    validator: validateRequired,
                    onSaved: newsBloc.saveTitle,
                    focusNode: globalBloc.getFocusNode(0),
                    nextFocusNode: globalBloc.getFocusNode(1),
                  ),
                  CustomTextFormFieldWidget(
                    labelText: "Description",
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    validator: validateRequired,
                    onSaved: newsBloc.saveDescription,
                    focusNode: globalBloc.getFocusNode(1),
                    nextFocusNode: new FocusNode(),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                onPressed: ()=> newsBloc.onSave(_formKey, null,globalBloc),
                color: Color(0xff3bc60b),
                minWidth: double.infinity,
                child: Text(
                  "Save",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xffffffff), fontFamily: 'futura', fontSize: 17),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}