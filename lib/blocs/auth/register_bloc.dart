import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/ResponseData.dart';
import 'package:template/models/User.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/bloc_provider.dart';
import 'package:template/utils/session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

class RegisterBloc extends Object implements BlocBase {
  @override
  void dispose() {
    _showPasswordController.close();
    _nameController.close();
    _addressController.close();
    _numberController.close();
    _emailController.close();
    _passwordController.close();
    _roleController.close();
  }
  // final _loadingController = BehaviorSubject<bool>();
  // Stream<bool> get loadingStream => _loadingController.stream;
  final _nameController = BehaviorSubject<String>();
  final _addressController = BehaviorSubject<String>();
  final _numberController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(String) get saveName => _nameController.sink.add;
  Function(String) get saveAddress => _addressController.sink.add;
  Function(String) get saveNumber => _numberController.sink.add;
  Function(String) get saveEmail => _emailController.sink.add;
  Function(String) get savePassword => _passwordController.sink.add;

  BehaviorSubject<bool> _showPasswordController = BehaviorSubject<bool>();
  Stream<bool> get showPasswordStream => _showPasswordController.stream;

  BehaviorSubject<String> _roleController = BehaviorSubject<String>();
  Stream<String> get roleStream => _roleController.stream;
  Function(String) get saveRole => _roleController.sink.add;
  String get getRole => _roleController.value;

  changeVisibility(bool value){
    _showPasswordController.sink.add(!value);
  }

  doRegister(GlobalKey<FormState> key, GlobalBloc globalBloc)async{
    FocusScope.of(key.currentContext).requestFocus(new FocusNode());
    if(key.currentState.validate()){
      key.currentState.save();
      // if(_roleController.value == null){
      //   Toast.show("Please Choose your role", key.currentContext,duration: Toast.LENGTH_LONG);
      //   return;
      // }
      try {
      GlobalBloc.setLoadingController(true);
        var dio = ApiProvider.init(contentType: "multipart/form-data");
        var body = {
          "userName" : _nameController.value,
          "userEmail" : _emailController.value,
          "userNumber" : _numberController.value,
          "userAddress" : _addressController.value,
          "userPassword" : _passwordController.value,
          "roleId" : _roleController.value,
        };
        FormData params = new FormData.from(body);
        File uploaded = globalBloc.getUploadedFile();
        if(uploaded != null){
          params.add("userPicture", new UploadFileInfo(uploaded, basename(uploaded.path)));
        }
        Response response = await dio.post("/UserService/register",data: params);
        ResponseData responseData = ResponseData.fromJson(response.data);
        String msg = "";
        if(responseData.responseCode == "201"){
          User user = User.fromJson(responseData.data);
          Session.setIsLogin(true);
          Session.setUserId(user.userId);
          Session.setRoleId(user.roleId);
          GlobalBloc.setRoleController(user.roleId);
          msg = responseData.responseDesc;
          Navigator.of(key.currentContext).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        }else{
          jsonDecode(jsonEncode(responseData.responseDesc)).forEach((key,val)=>msg += val);
        }
        Toast.show(msg, key.currentContext, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      } catch (e) {
        print(e);
      } finally {
        GlobalBloc.setLoadingController(false);
      }
    }
  }
}