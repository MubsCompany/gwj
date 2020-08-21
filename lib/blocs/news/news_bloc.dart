import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/NewsExternal.dart';
import 'package:template/models/User.dart';
import 'package:template/models/News.dart';
import 'package:template/models/ResponseData.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/bloc_provider.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:template/utils/uidata.dart';
import 'package:toast/toast.dart';
import 'package:path/path.dart';

class NewsBloc extends Object implements BlocBase {
  String roleId;
  NewsBloc({bool isGetData = false,this.roleId}){
    if (isGetData) getData();
  }
  @override
  void dispose() {
    _listNewsController.close(); 
    _listNewsExternalController.close(); 
    //  _uploadedFileController.close();
    _titleController.close();
    _descriptionController.close();
    _sourceController.close();
    _urlController.close();
  }

  List<News> listNews = [];
  BehaviorSubject<List<News>> _listNewsController = BehaviorSubject<List<News>>();
  Stream<List<News>> get listNewsStream => _listNewsController.stream;

  List<NewsExternal> listNewsExternal = [];
  BehaviorSubject<List<NewsExternal>> _listNewsExternalController = BehaviorSubject<List<NewsExternal>>();
  Stream<List<NewsExternal>> get listNewsExternalStream => _listNewsExternalController.stream;

  // BehaviorSubject<File> _uploadedFileController = BehaviorSubject<File>();
  // Stream<File> get uploadedFileStream => _uploadedFileController.stream;

  BehaviorSubject<String> _titleController = BehaviorSubject<String>();
  Function(String) get saveTitle => _titleController.sink.add;
  BehaviorSubject<String> _descriptionController = BehaviorSubject<String>();
  Function(String) get saveDescription => _descriptionController.sink.add;

  BehaviorSubject<String> _sourceController = BehaviorSubject<String>();
  Function(String) get saveSource => _sourceController.sink.add;
  BehaviorSubject<String> _urlController = BehaviorSubject<String>();
  Function(String) get saveUrl => _urlController.sink.add;
  
  getData()async{
    try {
      GlobalBloc.setLoadingController(true);
      var dio = ApiProvider.init();
      // User user = Storage.getUser();
      String companyId = await Session.getCompanyId();
      // if(user?.companyId == null) return;
      Response response = await dio.get("/NewsService/getNews/$companyId");
      ResponseData responseData = ResponseData.fromJson(response.data);
      if(responseData.responseCode == "200"){
        print(responseData.data);
        listNews.clear();
        responseData.data.forEach((data){
          News addData = News.fromJson(data);
          if (addData.isApprove == "1" ||([UIData.sekretarisId,UIData.generalAffairId].contains(this.roleId)))
            listNews.add(News.fromJson(data));
        });
        _listNewsController.sink.add(listNews);
      }
    } on DioError catch (e) {
      print(e);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }

  onSave(GlobalKey<FormState> key, News news, GlobalBloc globalBloc)async{
    FocusScope.of(key.currentContext).requestFocus(new FocusNode());
    try {
      GlobalBloc.setLoadingController(true);
      if(key.currentState.validate()){
        key.currentState.save();
        String companyId = await Session.getCompanyId();
        String roleId = await Session.getRoleId();
        var dio = ApiProvider.init(contentType: "multipart/form-data");
        News params = News(
          companyId: companyId,
          newsDate: GlobalFunction.formatDate(DateTime.now()),
          newsStatus: "1",
          newsText: _descriptionController.value,
          newsTitle: _titleController.value,
          isApprove: roleId == UIData.generalAffairId ? "1" : "0"
        );
        FormData formData = FormData.from(params.toJson());
        File uploaded = globalBloc.getUploadedFile();
        if(uploaded != null){
          formData.add("newsImage", new UploadFileInfo(uploaded, basename(uploaded.path)));
        }
        Response response;
        if(news == null){
          response = await dio.post("/NewsService/createNews",data: formData);
        }else{
          response = await dio.put("/NewsService/updateNews/${news.newsId}",data: formData);
        }
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          listNews.add(News.fromJson(responseData.data));
          _listNewsController.sink.add(listNews);
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
  onDelete(BuildContext context, News news)async{
    GlobalFunction.showConfirmDialog(context, ()async{
      try {
        GlobalBloc.setLoadingController(true);
        var dio = ApiProvider.init();
        Response response = await dio.delete("/NewsService/deleteNews/${news.newsId}");
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          listNews.removeWhere((data) => data.newsId == news.newsId);
          _listNewsController.sink.add(listNews);
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
  approve(BuildContext context, News news)async{
    GlobalFunction.showConfirmDialog(context, ()async{
      try {
        GlobalBloc.setLoadingController(true);
        var dio = ApiProvider.init();
        Response response = await dio.put("/NewsService/approveNews/${news.newsId}");
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          News retVal = News.fromJson(responseData.data);
          int index = listNews.indexWhere((data)=>data.newsId == news.newsId);
          listNews[index] = retVal;
          _listNewsController.sink.add(listNews);
        }
        Toast.show(responseData.responseDesc, context, duration: Toast.LENGTH_LONG);
      } on DioError catch (e) {
        Toast.show(e.message, context, duration: Toast.LENGTH_LONG);
        print(e);
      } finally {
        GlobalBloc.setLoadingController(false);
      }
    },content: "Are you sure want to approve this news ?");
  }

  getNewsExternal(String category)async{
    try {
      GlobalBloc.setLoadingController(true);
      var dio = ApiProvider.init();
      // User user = Storage.getUser();
      String companyId = await Session.getCompanyId();
      // if(user?.companyId == null) return;
      Response response = await dio.get("/NewsExternalService/getNewsExternalByCategory/$category/$companyId");
      ResponseData responseData = ResponseData.fromJson(response.data);
      if(responseData.responseCode == "200"){
        print(responseData.data);
        listNewsExternal.clear();
        responseData.data.forEach((data){
          listNewsExternal.add(NewsExternal.fromJson(data));
        });
        _listNewsExternalController.sink.add(listNewsExternal);
      }
    } on DioError catch (e) {
      print(e);
    } finally {
      GlobalBloc.setLoadingController(false);
    }
  }

  onSaveNewsExternal(GlobalKey<FormState> key, NewsExternal newsExternal)async{
    FocusScope.of(key.currentContext).requestFocus(new FocusNode());
    try {
      GlobalBloc.setLoadingController(true);
      if(key.currentState.validate()){
        key.currentState.save();
        String companyId = await Session.getCompanyId();
        String roleId = await Session.getRoleId();
        var dio = ApiProvider.init();
        NewsExternal params = NewsExternal(
          companyId: companyId,
          category: newsExternal.category,
          source:_sourceController.value,
          url:_urlController.value,
        );
        Response response;
        if(newsExternal.id == null){
          response = await dio.post("/NewsExternalService/createNewsExternal",data: params.toJson());
        }else{
          response = await dio.put("/NewsExternalService/updateNewsExternal/${newsExternal.id}",data: params.toJson());
        }
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          NewsExternal retVal = NewsExternal.fromJson(responseData.data);
          if(newsExternal.id == null){
            listNewsExternal.add(retVal);
          }else{
            int index = listNewsExternal.indexWhere((data)=>data.id == newsExternal.id);
            listNewsExternal[index] = retVal;
          }
          _listNewsExternalController.sink.add(listNewsExternal);
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

  deleteNewsExternal(BuildContext context, NewsExternal newsExternal)async{
    GlobalFunction.showConfirmDialog(context, ()async{
      try {
        GlobalBloc.setLoadingController(true);
        var dio = ApiProvider.init();
        Response response = await dio.delete("/NewsExternalService/deleteNewsExternal/${newsExternal.id}");
        ResponseData responseData = ResponseData.fromJson(response.data);
        if(responseData.responseCode == "00"){
          listNewsExternal.removeWhere((data) => data.id == newsExternal.id);
          _listNewsExternalController.sink.add(listNewsExternal);
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