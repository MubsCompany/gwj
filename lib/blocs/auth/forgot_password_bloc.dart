import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/ResponseData.dart';
import 'package:template/models/User.dart';
import 'package:template/pages/auth/new_password_page.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/bloc_provider.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/session.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class ForgotPasswordBloc extends Object implements BlocBase {
  @override
  void dispose() {
    _emailController.close();
    _nameController.close();
    _numberController.close();
  }
  BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  Function(String) get saveEmail => _emailController.sink.add;

  BehaviorSubject<String> _nameController = BehaviorSubject<String>();
  Function(String) get saveName => _nameController.sink.add;

  BehaviorSubject<String> _numberController = BehaviorSubject<String>();
  Function(String) get saveNumber => _numberController.sink.add;

  onNext(GlobalKey<FormState> key) async {
    FocusScope.of(key.currentContext).requestFocus(FocusNode());
    try {
      GlobalBloc.setLoadingController(true);
      if(key.currentState.validate()){
        key.currentState.save();
        User user = User(
          userEmail: _emailController.value,
          userName: _nameController.value,
          userNumber: _numberController.value,
        );
        var dio = ApiProvider.init();
        Response response = await dio.post("/UserService/verifyData",data: user.toJson());
        ResponseData responseData = ResponseData.fromJson(response.data);
        String msg = responseData.responseDesc;
        print(responseData.responseDesc);
        if(responseData.responseCode == "200"){
          // Navigator.of(key.currentContext).pushNamed("/new_password");
          User retVal = User.fromJson(responseData.data);
          GlobalFunction.changePage(key.currentContext, NewPasswordPage(user: retVal,));
        }else if(responseData.responseCode == "401"){
          responseData.responseDesc.foreach((k,v)=> msg +=v);
        }
        Toast.show(msg, key.currentContext,duration:Toast.LENGTH_LONG);
      }
    } catch (e) {
      print(e);
    } finally {
      GlobalBloc.setLoadingController(true);
    }

  }
}