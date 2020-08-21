import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/User.dart';
import 'package:template/models/Contact.dart';
import 'package:template/models/ResponseData.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/bloc_provider.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/session.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class ContactBloc extends Object implements BlocBase {
  @override
  void dispose() {
    GlobalBloc.setLoadingController(false);
    _listContactController.close();
    _nameController.close();
    _companyController.close();
    _positionController.close();
    _addressController.close();
    _phoneController.close();
    _emailController.close();
  }
  List<Contact> listContact = [];
  BehaviorSubject<List<Contact>> _listContactController = BehaviorSubject<List<Contact>>();
  Stream<List<Contact>> get listContactStream => _listContactController.stream;

  BehaviorSubject<String> _nameController = BehaviorSubject<String>();
  BehaviorSubject<String> _companyController = BehaviorSubject<String>();
  BehaviorSubject<String> _positionController = BehaviorSubject<String>();
  BehaviorSubject<String> _addressController = BehaviorSubject<String>();
  BehaviorSubject<String> _phoneController = BehaviorSubject<String>();
  BehaviorSubject<String> _emailController = BehaviorSubject<String>();

  Function(String) get saveName => _nameController.sink.add;
  Function(String) get saveCompany => _companyController.sink.add;
  Function(String) get savePosition => _positionController.sink.add;
  Function(String) get saveAddress => _addressController.sink.add;
  Function(String) get savePhone => _phoneController.sink.add;
  Function(String) get saveEmail => _emailController.sink.add;

  ContactBloc({isGetData = false}){
    if(isGetData) getData();
  }

  getData() async {
    try {
      GlobalBloc.setLoadingController(true);
      // User user = Storage.getUser();
      String companyId = await Session.getCompanyId();
      var dio = ApiProvider.init();
      Response response = await dio.get("/ContactService/getContact/$companyId");
      ResponseData responseData = ResponseData.fromJson(response.data);
      if(responseData.responseCode == "200"){
        listContact.clear();
        responseData.data.forEach((data){
          listContact.add(Contact.fromJson(data));
        });
        _listContactController.sink.add(listContact);
      }
    } on DioError catch (e) {
      print(e);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }

  onSave(GlobalKey<FormState> key, Contact contact)async{
    FocusScope.of(key.currentContext).requestFocus(new FocusNode());
    try {
      GlobalBloc.setLoadingController(true);
      if(key.currentState.validate()){
        key.currentState.save();
        // User user = Storage.getUser();
        String companyId = await Session.getCompanyId();
        var dio = ApiProvider.init();
        Contact params = Contact(
          companyId: companyId,
          contactAddress: _addressController.value,
          contactCompany: _companyController.value,
          contactDivision: _positionController.value,
          contactEmail: _emailController.value,
          contactName: _nameController.value,
          contactNumber: _phoneController.value
        );
        Response response;
        if(contact == null){
          response = await dio.post("/ContactService/createContact",data: params.toJson());
        }else{
          response = await dio.put("/ContactService/updateContact/${contact.contactId}",data: params.toJson());
        }
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          Contact retVal = Contact.fromJson(responseData.data);
          print(contact);
          print(retVal.toJson());
          if(contact == null){
            listContact.add(retVal);
          }else{
            int index = listContact.indexWhere((data)=>data.contactId == contact.contactId);
            listContact[index] = retVal;
          }
          _listContactController.sink.add(listContact);
          Navigator.of(key.currentContext).pop();
        }
        Toast.show(responseData.responseDesc, key.currentContext, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
    } on DioError catch (e) {
      Toast.show(e.message, key.currentContext, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      print(e);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }

  onDelete(BuildContext context, Contact contact)async{
    GlobalFunction.showConfirmDialog(context, ()async{
      try {
        GlobalBloc.setLoadingController(true);
        var dio = ApiProvider.init();
        Response response = await dio.delete("/ContactService/deleteContact/${contact.contactId}");
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          listContact.removeWhere((data) => data.contactId == contact.contactId);
          _listContactController.sink.add(listContact);
        }
        Toast.show(responseData.responseDesc, context, duration: Toast.LENGTH_LONG);
      } on DioError catch (e) {
        Toast.show(e.message, context, duration: Toast.LENGTH_LONG);
        print(e);
      } finally {
        GlobalBloc.setLoadingController(false);
      }
    });
  }
}