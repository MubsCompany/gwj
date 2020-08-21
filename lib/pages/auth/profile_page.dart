import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template/blocs/auth/login_bloc.dart';
import 'package:template/blocs/auth/profile_bloc.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/session.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/models/User.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';
import 'package:template/widgets/loading_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with ValidationMixin{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalBloc globalBloc = GlobalBloc();
  LoginBloc loginBloc = LoginBloc();

  User user;
  Map<String,String> listRole = {
    "1":"Direktur",
    "2":"General manager",
    "3":"Sekretaris",
    "4":"General Affair",
    "5":"Staff",
    "6":"Admin",
  };
  TextEditingController _roleCodeController = TextEditingController();
  ProfileBloc profileBloc;
  @override
  void initState() {
    // TODO: implement initState
    profileBloc = ProfileBloc(isGetUser: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: ListView(
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Row(
                    children: <Widget>[
                      IconButton(icon: Icon(
                        Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                        color: Colors.black,
                      ), onPressed: () => Navigator.pop(context)),
                      Text('Profile', style: TextStyle(fontFamily: 'futura', fontWeight: FontWeight.bold, fontSize: 20),),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: ()=>Navigator.of(context).pushNamed("/intro"),
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Icon(FontAwesomeIcons.question)
                      ),
                    ),
                  ),

                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: StreamBuilder(
                    stream: globalBloc.uploadedFileStream,
                    builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                      Widget child;
                      if(snapshot.hasData){
                        child = ClipRRect(
                          borderRadius: BorderRadius.circular(120),
                          child: Image(image: FileImage(snapshot.data),fit: BoxFit.cover,)
                        );
                      }else{
                        child = StreamBuilder(
                          stream: profileBloc.userStream,
                          builder: (BuildContext ctxUser,AsyncSnapshot<User> userData){
                            if(!userData.hasData) return Container();
                            this.user = userData.data;
                            return CachedNetworkImage(
                                imageUrl: "${UIData.uploadDir}/user/${userData.data.userPicture}",
                                imageBuilder: (context, imageProvider) => ClipRRect(
                                  borderRadius: BorderRadius.circular(120),
                                  child: Image(
                                    image: imageProvider,
                                    fit: BoxFit.cover
                                  ),
                                ),
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Center(child: Icon(Icons.person,color: Colors.white,size: 90,)),
                            );
                          },
                        );
                      }
                      return Center(
                        child: InkWell(
                          // onTap: () => globalBloc.uploadFile(),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(120)
                            ),
                            child: child,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Color(0xf0f0f0f0),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: StreamBuilder(
                        stream: profileBloc.userStream,
                        builder: (BuildContext ctxUser, AsyncSnapshot<User> userData){
                          if(!userData.hasData) return Container();
                          return Column(
                            children: <Widget>[

                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                elevation: 2,
                                child: Container(
                                  height:60,
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
                                      readOnly: true,
                                      labelText: "Name",
                                      initialValue: userData.data.userName,
                                    ),
                                  ),
                                ),
                              ),

                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                elevation: 2,
                                child: Container(
                                  height:60,
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
                                      readOnly: true,
                                      labelText: "Address",
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      initialValue: userData.data.userAddress,
                                    ),
                                  ),
                                ),
                              ),

                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                elevation: 2,
                                child: Container(
                                  height:60,
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
                                      readOnly: true,
                                      labelText: "Number",
                                      keyboardType: TextInputType.number,
                                      initialValue: userData.data.userNumber,
                                    ),
                                  ),
                                ),
                              ),

                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                elevation: 2,
                                child: Container(
                                  height:60,
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
                                      readOnly: true,
                                      labelText: "Email",
                                      keyboardType: TextInputType.emailAddress,
                                      initialValue: userData.data.userEmail,
                                    ),
                                  ),
                                ),
                              ),

                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                elevation: 2,
                                child: Container(
                                  height:60,
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
                                      readOnly: true,
                                      labelText: "Role",
                                      keyboardType: TextInputType.emailAddress,
                                      initialValue: listRole[userData.data.roleId],
                                    ),
                                  ),
                                ),
                              ),

                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                elevation: 2,
                                child: Container(
                                  height:60,
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
                                      readOnly: true,
                                      labelText: "User Code",
                                      initialValue: userData.data.userCode,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // tombol logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  onPressed: ()=>loginBloc.doLogout(context),
                  color: UIData.darkPrimaryColor,
                  minWidth: double.infinity,
                  child: Text(
                    "Log Out",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xffffffff), fontSize: 17),
                  ),
                ),
              ),

            ],
          ),
        ),
        StreamBuilder(
          initialData: true,
          stream: GlobalBloc.loadingStream,
          builder: (ctx,isLoad){
            return LoadingWidget(isLoad.data);
          },
        )
      ],
    );
  }
}