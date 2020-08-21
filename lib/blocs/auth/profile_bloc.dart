import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/ResponseData.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/bloc_provider.dart';
import 'package:template/utils/session.dart';
import 'package:template/models/User.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart';
import 'package:toast/toast.dart';

class ProfileBloc extends Object implements BlocBase {
  ProfileBloc({isGetUser = false}){
    if(isGetUser) getUser();
  }
  @override
  void dispose() {
    _nameController.close();
    _addressController.close();
    _numberController.close();
    _emailController.close();
    _userController.close();
    _roleController.close();
  }
  BehaviorSubject<String> _nameController = BehaviorSubject<String>();
  Function(String) get saveName => _nameController.sink.add;
  BehaviorSubject<String> _addressController = BehaviorSubject<String>();
  Function(String) get saveAddress => _addressController.sink.add;
  BehaviorSubject<String> _numberController = BehaviorSubject<String>();
  Function(String) get saveNumber => _numberController.sink.add;
  BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  Function(String) get saveEmail => _emailController.sink.add;
  
  BehaviorSubject<User> _userController = BehaviorSubject<User>();
  Stream<User> get userStream => _userController.stream;

  BehaviorSubject<String> _roleController = BehaviorSubject<String>();
  Stream<String> get roleStream => _roleController.stream;
  Function(String) get saveRole => _roleController.sink.add;
  String get getRole => _roleController.value;
  getUser()async{
    try {
      GlobalBloc.setLoadingController(true);
      String userId = await Session.getUserId();
      var dio = ApiProvider.init();
      Response response = await dio.get("/UserService/getUserInfo/$userId");
      ResponseData responseData = ResponseData.fromJson(response.data);
      if(responseData.responseCode == "200"){
        print(responseData.data);
        _userController.sink.add(User.fromJson(responseData.data));
        saveRole(User.fromJson(responseData.data).roleId);
      }
    } on DioError catch (e) {
      print(e);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }
  onSave(GlobalKey<FormState> key, User user, GlobalBloc globalBloc,String roleCode)async{
    FocusScope.of(key.currentContext).requestFocus(new FocusNode());
    try {
      GlobalBloc.setLoadingController(true);
      if(key.currentState.validate()){
        key.currentState.save();
        String userId = await Session.getUserId();
        var dio = ApiProvider.init(contentType: "multipart/form-data");
        User params = User(
          userAddress: _addressController.value,
          userEmail: _emailController.value,
          userName: _nameController.value,
          userNumber: _numberController.value,
          roleId: _roleController.value,
        );
        FormData formData = FormData.from(params.toJson());
        formData.add("oldUserName", user.userName);
        formData.add("oldUserEmail", user.userEmail);
        formData.add("roleCode", roleCode);
        File uploaded = globalBloc.getUploadedFile();
        if(uploaded != null){
          formData.add("userPicture", new UploadFileInfo(uploaded, basename(uploaded.path)));
        }
        print("===============");
        print(params.toJson());
        print("/UserService/updateUserInfo/$userId");
        print("===============");
        Response response = await dio.post("/UserService/updateUserInfo/$userId",data: formData);
        ResponseData responseData = ResponseData.fromJson(response.data);
        String msg = "";
        if(responseData.responseCode == "00"){
          msg = responseData.responseDesc;
          GlobalBloc.setRoleController(_roleController.value);
          Navigator.of(key.currentContext).pop();
        }else if(responseData.responseCode == "401"){
          jsonDecode(jsonEncode(responseData.responseDesc)).forEach((key,val)=>msg += val);
          print(msg);
        }else if(responseData.responseCode == "404"){
          msg = responseData.responseDesc;
        }
        Toast.show(msg, key.currentContext, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("ERROR : "+e.message, key.currentContext, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      print(e);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }
}