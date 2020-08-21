import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/ResponseData.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/bloc_provider.dart';
import 'package:template/models/User.dart';
import 'package:template/utils/session.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class NewPasswordBloc extends Object implements BlocBase {
  @override
  void dispose() {
    _showPasswordController.close();
    _showConfirmPasswordController.close();
    _passwordController.close();
    _confirmPasswordController.close();
  }
  
  BehaviorSubject<bool> _showPasswordController = BehaviorSubject<bool>();
  Stream<bool> get showPasswordStream => _showPasswordController.stream;
  BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  Function(String) get savePassword => _passwordController.sink.add;
  changeVisibility(bool value){
    _showPasswordController.sink.add(!value);
  }
  
  BehaviorSubject<bool> _showConfirmPasswordController = BehaviorSubject<bool>();
  Stream<bool> get showConfirmPasswordStream => _showConfirmPasswordController.stream;
  BehaviorSubject<String> _confirmPasswordController = BehaviorSubject<String>();
  Function(String) get saveConfirmPassword => _confirmPasswordController.sink.add;
  changeConfirmVisibility(bool value){
    _showConfirmPasswordController.sink.add(!value);
  }

  onSave(GlobalKey<FormState> key,User user) async {
    FocusScope.of(key.currentContext).requestFocus(FocusNode());
    try {
      GlobalBloc.setLoadingController(true);
      if(key.currentState.validate()){
        key.currentState.save();
        User params = User(
          userId: user.userId,
          userPassword: _passwordController.value
        );
        var dio = ApiProvider.init();
        Response response = await dio.post("/UserService/setNewPassword",data: params.toJson());
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "200"){
          User retVal = User.fromJson(responseData.data);
          Session.setIsLogin(true);
          Session.setUserId(retVal.userId);
          Navigator.of(key.currentContext).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        }
        Toast.show(responseData.responseDesc, key.currentContext,duration: Toast.LENGTH_LONG);
      }
    } catch (e) {
      print(e);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }
}