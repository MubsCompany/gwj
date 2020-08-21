import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/models/News.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/widgets/loading_widget.dart';
class ViewNewsPage extends StatelessWidget {
  News news;
  ViewNewsPage(this.news);
  @override
  Widget build(BuildContext context) {
    print("${UIData.uploadDir}/news/${news?.newsImage}");
    return Stack(
      children: <Widget>[
        Scaffold(
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: <Widget>[
                    IconButton(icon: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                      color: Colors.black,
                    ), onPressed: () => Navigator.pop(context)),
                    Text('Contact Detail', style: TextStyle(fontFamily: 'futura', fontWeight: FontWeight.bold, fontSize: 20),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Text(news?.newsTitle ?? "", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'futura'),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: CachedNetworkImage(
                  imageUrl: "${UIData.uploadDir}/news/${news?.newsImage}",
                  imageBuilder: (context, imageProvider) => Container(
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.contain
                    ),
                  ),
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset("assets/no_image.png",fit: BoxFit.contain,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(news?.newsText ?? "", style: TextStyle(fontFamily: 'futura'),),
              )
            ],
          ),
        ),
        StreamBuilder(
          initialData: true,
          stream: GlobalBloc.loadingStream,
          builder: (BuildContext ctxLoading, AsyncSnapshot<bool> snapshot){
            return LoadingWidget(snapshot.data);
          },
        )
      ],
    );
  }
}