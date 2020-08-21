import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:template/blocs/auth/login_bloc.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/header_wave.dart';
import 'package:template/pages/contact/contact_page.dart';
import 'package:template/pages/mail/mail_page.dart';
import 'package:template/pages/news/news_page.dart';
import 'package:template/pages/note/note_page.dart';
import 'package:template/pages/reminder/reminder_page.dart';
import 'package:template/pages/schedule/schedule_page.dart';
import 'package:template/pages/tes_page.dart';
import 'package:template/pages/webview_page.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/session.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/widgets/base_container_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  LoginBloc loginBloc = LoginBloc();
  init()async{
    GlobalBloc.setRoleController(await Session.getRoleId());
  }
  @override
  Widget build(BuildContext context) {
    init();
    //Start Generate Notification
    // GlobalBloc.generateNotification();
    //End Generate Notification
    return Scaffold(
      body: Stack(
        children: <Widget>[

          HeaderWave(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[

//                BARISAN TEXT HALO DAN  TOMBOL PROFILE
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Grip', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 35, color: Color(0xffffffff), fontFamily: 'futura'),),
                        InkWell(
                          onTap: () => Navigator.of(context).pushNamed("/profile"),
                          child: Container(
                            width: 50,
                              height: 50,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              child: Icon(Icons.person)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.width * 0.1,),

//                BARISAN MENU PERTAMA
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      // card pertama
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.width * 0.37,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5,
                          color: Color(0xf0f0f0f0),
                          child: Container(
                            child: StreamBuilder(
                                initialData: "",
                                stream: GlobalBloc.roleStream,
                                builder: (BuildContext ctx, AsyncSnapshot<String> snapshot){
                                  return InkWell(
                                    onTap: (){
                                      // if(["1","2","3","4"].contains(snapshot.data)){
                                      // Navigator.of(context).pushNamed("/schedule");
                                      GlobalFunction.changePage(context, SchedulePage(roleId: snapshot.data,));
                                      // }else{
                                      // GlobalFunction.showAlertDialog(context, "You don't have access to this menu");
                                      // }
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(child: Image.asset('assets/calendar.png'), width: 70, height: 70,),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text('Schedule', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'futura'),),
                                        )
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                        ),
                      ),

                      // card kedua
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.width * 0.37,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5,
                          color: Color(0xf0f0f0f0),
                          child: Container(
                            child: StreamBuilder(
                                initialData: "",
                                stream: GlobalBloc.roleStream,
                                builder: (BuildContext ctx, AsyncSnapshot<String> snapshot){
                                  return InkWell(
                                    onTap: ()=>GlobalFunction.changePage(context, NotePage(roleId: snapshot.data,)),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      height: MediaQuery.of(context).size.width * 0.37,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset('assets/notepad.png'),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text('Notes',style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'futura'),),
                                        )
                                      ],
                                    ),
                                  )
                                  );
                                }
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

//                BARISAN MENU KEDUA
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      // card pertama
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.width * 0.37,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5,
                          color: Color(0xf0f0f0f0),
                          child: StreamBuilder(
                              initialData: "",
                              stream: GlobalBloc.roleStream,
                              builder: (BuildContext ctx, AsyncSnapshot<String> snapshot){
                                return InkWell(
                                  onTap: ()async{

                                    if(snapshot.data == UIData.sekretarisId){
                                      // Navigator.of(context).pushNamed("/news");
                                      String companyId = await Session.getCompanyId();
                                      GlobalFunction.changePage(context, MailPage(companyId));
                                      // }else{
                                      // GlobalFunction.showAlertDialog(context, "You don't have access to this menu");
                                    }else{
                                      GlobalFunction.showAlertDialog(context, "You don't have access to this menu");
                                    }
                                  },
                                  // onTap: ()=>Navigator.of(context).pushNamed("/mail"),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('assets/mail.png'),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6.0),
                                        child: Text('Mail', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'futura'),),
                                      )
                                    ],
                                  )
                                );
                              }
                          ),
                        ),
                      ),

                      // card kedua
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.width * 0.37,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5,
                          color: Color(0xf0f0f0f0),
                          child: StreamBuilder(
                              initialData: "",
                              stream: GlobalBloc.roleStream,
                              builder: (BuildContext ctx, AsyncSnapshot<String> snapshot){
                                return InkWell(
                                  onTap: (){
                                    // if(["1","2","3","4"].contains(snapshot.data)){
                                    // Navigator.of(context).pushNamed("/reminder");
                                    GlobalFunction.changePage(context, ReminderPage(roleId: snapshot.data,));
                                    // }else{
                                    // GlobalFunction.showAlertDialog(context, "You don't have access to this menu");
                                    // }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('assets/alarm.png'),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6.0),
                                        child: Text('Reminder', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'futura'),),
                                      )
                                    ],
                                  )
                                );
                              }
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

//                BARISAN MENU KETIGA
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      // card pertama
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.width * 0.37,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5,
                          color: Color(0xf0f0f0f0),
                          child: StreamBuilder(
                            initialData: "",
                            stream: GlobalBloc.roleStream,
                            builder: (BuildContext ctx, AsyncSnapshot<String> snapshot){
                              return InkWell(
                                  onTap: (){
                                    // if(["1","2","3"].contains(snapshot.data)){
                                    GlobalFunction.changePage(context, ContactPage(roleId: snapshot.data,));
                                    // Navigator.of(context).pushNamed("/contact");
                                    // }else{
                                    // GlobalFunction.showAlertDialog(context, "You don't have access to this menu");
                                    // }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('assets/contact.png'),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6.0),
                                        child: Text('Contact', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'futura'),),
                                      )
                                    ],
                                  )
                              );
                            },
                          ),
                        ),
                      ),

                      // card kedua
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.width * 0.37,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5,
                          color: Color(0xf0f0f0f0),
                          child: StreamBuilder(
                              initialData: "",
                              stream: GlobalBloc.roleStream,
                              builder: (BuildContext ctx, AsyncSnapshot<String> snapshot){
                                return InkWell(
                                  onTap: (){
                                    // if(["1","2","3","6"].contains(snapshot.data)){
                                    // Navigator.of(context).pushNamed("/news");
                                    GlobalFunction.changePage(context, NewsPage(roleId: snapshot.data,));
                                    // }else{
                                    // GlobalFunction.showAlertDialog(context, "You don't have access to this menu");
                                    // }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('assets/newspaper.png'),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6.0),
                                        child: Text('News', style: TextStyle(fontWeight: FontWeight.w800, fontFamily: 'futura'),),
                                      )
                                    ],
                                  )
                                );
                              }
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}