
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/Mail.dart';
import 'package:template/models/ResponseData.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/bloc_provider.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/session.dart';
import 'package:toast/toast.dart';

class MailBloc extends Object implements BlocBase {
  @override
  void dispose() {
    _listTemplateController.close();
    _urlController.close();
  }

  List<Mail> _listTemplate = [];
  BehaviorSubject<List<Mail>> _listTemplateController = BehaviorSubject<List<Mail>>();
  Stream<List<Mail>> get listTemplateStream => _listTemplateController.stream;
  
  BehaviorSubject<String> _urlController = BehaviorSubject<String>();
  Stream<String> get urlStream => _urlController.stream;
  Function(String) get updateUrl => _urlController.sink.add;

  getData()async{
    try {
      GlobalBloc.setLoadingController(true);
      String companyId = await Session.getCompanyId();
      var dio = ApiProvider.init();
      Response response = await dio.get("/MailService/getMail/$companyId");
      ResponseData responseData = ResponseData.fromJson(response.data);
      if(responseData.responseCode == "200"){
        _listTemplate.clear();
        responseData.data.forEach((data){
          _listTemplate.add(Mail.fromJson(data));
        });
        _listTemplateController.sink.add(_listTemplate);
      }
    } catch (e) {
      print(e);
    }finally{
      GlobalBloc.setLoadingController(false);
    }
  }

  doAction(BuildContext context,String action, Mail mail)async{
    if(action == "delete"){
      GlobalFunction.showConfirmDialog(context, ()async{
        try {
          GlobalBloc.setLoadingController(true);
          var dio = ApiProvider.init();
          Response response = await dio.delete("/MailService/deleteMail/${mail.id}");
          ResponseData responseData = ResponseData.fromJson(response.data);
          if(responseData.responseCode == "00"){
            _listTemplate.removeWhere((data) => data.id == mail.id);
            _listTemplateController.sink.add(_listTemplate);
          }
          Toast.show(responseData.responseDesc, context, duration: Toast.LENGTH_LONG);
        } on DioError catch (e) {
          Toast.show(e.message, context, duration: Toast.LENGTH_LONG);
          print(e);
        } finally {
          GlobalBloc.setLoadingController(false);
        }
      });
    }else if(action == "send"){
      Directory dirApp = await getExternalStorageDirectory();
      dirApp = Directory(dirApp.path+"/pdf");
      if(!dirApp.existsSync()){
        dirApp.create();
      }
      dirApp.listSync().forEach((data){
        data.deleteSync();
      });
      var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(mail.content, dirApp.path, mail.name);
      print(generatedPdfFile.path);
      final MailOptions mailOptions = MailOptions(
        // body: 'a long body for the email <br> with a subset of HTML',
        subject: "",
        // recipients: ['example@example.com'],
        // isHTML: true,
        // bccRecipients: ['other@example.com'],
        // ccRecipients: ['third@example.com'],
        attachments: [ generatedPdfFile.path, ],
      );
      await FlutterMailer.send(mailOptions);
    }
  }

}