import 'dart:io';

import 'package:flutter/material.dart';
import 'package:template/blocs/contact/contact_bloc.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/Contact.dart';
import 'package:template/pages/contact/add_contact_page.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/session.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/widgets/loading_widget.dart';

class ContactPage extends StatelessWidget {
  ContactBloc contactBloc = ContactBloc(isGetData: true);
  String roleId;
  ContactPage({this.roleId});
  bool validRole(){
    return roleId == UIData.sekretarisId;
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: <Widget>[
                    IconButton(icon: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                      color: Colors.black,
                    ), onPressed: () => Navigator.pop(context)),
                    Text('Contact', style: TextStyle(fontFamily: 'futura', fontWeight: FontWeight.bold, fontSize: 20),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: StreamBuilder(
                  stream: contactBloc.listContactStream,
                  builder: (BuildContext ctxStream, AsyncSnapshot<List<Contact>> snapshot) {
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (ctxLv,i){
                          Contact data = snapshot.data.elementAt(i);
                          return ListTile(
                            onTap: ()=> GlobalFunction.changePage(context, AddContactPage(contact: data,contactBloc: contactBloc,isValid: validRole(),)),
                            title: Container(
                              width: double.infinity,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 25),
                                    padding: EdgeInsets.only(left: 35,top: 10,bottom: 10,right: 50),
                                    color: UIData.accentColor,
                                    child: Text(data.contactName,maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontFamily: 'futura'),)
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xffebecf1),
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                    child: Icon(Icons.person,color: Colors.white,size: 35,),
                                  ),
                                  validRole() ?Positioned(
                                    right: 0,
                                    child: PopupMenuButton(
                                      onSelected: (val) => contactBloc.onDelete(context, val),
                                      icon: Icon(Icons.more_vert,color: UIData.bcContactColor,),
                                      itemBuilder: (BuildContext popUpContext) {
                                        return [
                                          PopupMenuItem(
                                            value: data,
                                            child: Text("Delete"),
                                          )
                                        ];
                                      },
                                    ),
                                  ):Container()
                                ],
                              ),
                            ),
                            // trailing: Container(
                            //   color: UIData.containerColor,
                            //   child: ,
                            // ),
                          );
                        },
                        padding: EdgeInsets.all(10),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: validRole() ? FloatingActionButton(
            onPressed: ()=> GlobalFunction.changePage(context, AddContactPage(contactBloc: contactBloc,isValid: validRole(),)),
            backgroundColor: UIData.accentColor,
            child: Text("+",style: TextStyle(fontSize: 28,fontWeight: FontWeight.normal),),
          ):null,
        ),
        StreamBuilder(
          initialData: true,
          stream: GlobalBloc.loadingStream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return LoadingWidget(snapshot.data);
          },
        ),
      ],
    );
  }
}