import 'dart:io';

import 'package:flutter/material.dart';
import 'package:template/blocs/global_bloc.dart';
import 'package:template/blocs/news/news_bloc.dart';
import 'package:template/models/News.dart';
import 'package:template/models/NewsExternal.dart';
import 'package:template/pages/news/add_news_page.dart';
import 'package:template/pages/news/view_news_page.dart';
import 'package:template/pages/webview_page.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/uidata.dart';
import 'package:template/utils/validator.dart';
import 'package:template/widgets/base_container_widget.dart';
import 'package:template/widgets/custom_text_form_field_widget.dart';
import 'package:template/widgets/loading_widget.dart';
class NewsPage extends StatefulWidget {
  String roleId;
  NewsPage({this.roleId});
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with SingleTickerProviderStateMixin,ValidationMixin{
  GlobalBloc globalBloc;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  validRole(){
    return widget.roleId == UIData.sekretarisId;
  }
  isGA(){
    return widget.roleId == UIData.generalAffairId;
  }
  NewsBloc newsBloc;
  TabController _tabController;
  List<String> titleEksternal = ["Ekonomi","Bola","Teknologi","Sains","Entertainment","Otomotif"];
  
  List<List<String>> urlEksternal = [
    ["https://ekonomi.kompas.com/", "https://www.liputan6.com/bisnis/ekonomi", "https://economy.okezone.com/topic/1809/ekonomi-ri"],
    ["https://bola.kompas.com/", "https://www.liputan6.com/bola", "https://bola.okezone.com/ "],
    ["https://tekno.kompas.com/", "https://www.liputan6.com/tekno", "https://techno.okezone.com/"],
    ["https://sains.kompas.com/", "https://www.liputan6.com/global/sains", "https://techno.okezone.com/science"],
    ["https://entertainment.kompas.com/", "https://www.liputan6.com/showbiz", "https://celebrity.okezone.com/"],
    ["https://otomotif.kompas.com/", "https://www.liputan6.com/otomotif", "https://otomotif.okezone.com/"]
  ];
  @override
  void initState() {
    setStateTab();
    newsBloc = NewsBloc(isGetData: true,roleId: widget.roleId);
    globalBloc = GlobalBloc();
    globalBloc.generateFocusNode(2);
    super.initState();
  }
  void setStateTab(){
    _tabController = new TabController(vsync: this, length: 2);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: <Widget>[
                    IconButton(icon: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                      color: Colors.black,
                    ), onPressed: () => Navigator.pop(context)),
                    Text('News', style: TextStyle(fontFamily: 'futura', fontWeight: FontWeight.bold, fontSize: 20),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Card(
                  color: UIData.accentColor,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: UIData.bcContactColor,
                    tabs: <Widget>[
                      Tab(child: Text("INTERNAL",textAlign: TextAlign.center,),),
                      Tab(child: Text("EXTERNAL",textAlign: TextAlign.center,),),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 120),
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        StreamBuilder(
                          stream: newsBloc.listNewsStream,
                          builder: (BuildContext ctxList, AsyncSnapshot<List<News>> snapshot){
                            if(snapshot.hasData){
                              return ListView.separated(
                                itemCount: snapshot.data.length,
                                padding: EdgeInsets.all(10),
                                itemBuilder: (BuildContext ctxList, int index){
                                  return InkWell(
                                    onTap: () => GlobalFunction.changePage(context, ViewNewsPage(snapshot.data[index])),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(0, 3), // changes position of shadow
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xff10b780),
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 15,right: 50,bottom: 15,left: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(snapshot.data[index].newsTitle,textAlign: TextAlign.left,overflow: TextOverflow.ellipsis,maxLines: 1, style: TextStyle(color: Colors.white, fontFamily: 'futura', fontWeight: FontWeight.bold),),
                                                (validRole() || isGA()) && snapshot.data[index].isApprove == "0" ? SizedBox(height: 5,):Container(),
                                                (validRole() || isGA()) && snapshot.data[index].isApprove == "0" ? Text("(Waiting For Approval)",textAlign: TextAlign.left,style: TextStyle(fontSize: 12,color: Colors.grey, fontFamily: 'futura'),):Container()
                                              ],
                                            ),
                                          ),
                                          (validRole() || isGA()) ?Align(
                                            alignment: FractionalOffset.centerRight,
                                            child: PopupMenuButton(
                                              onSelected: (val){
                                                if(val == 1){
                                                  newsBloc.approve(context, snapshot.data[index]);
                                                }else{
                                                  newsBloc.onDelete(context, snapshot.data[index]);
                                                }
                                              },
                                              icon: Icon(Icons.more_vert,color: Colors.white,),
                                              itemBuilder: (BuildContext popUpContext) {
                                                return [
                                                  isGA() && snapshot.data[index].isApprove == "0" ? PopupMenuItem(
                                                    value: 1,
                                                    child: Text("Approve"),
                                                  ):null,
                                                  PopupMenuItem(
                                                    value: 2,
                                                    child: Text("Delete"),
                                                  )
                                                ];
                                              },
                                            ),
                                          ):Container()
                                        ],
                                      ),
                                    ),
                                  );
                                }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 20,),
                              );
                            }
                            return Container();
                          },
                        ),
                        Positioned(
                          right: 20,
                          bottom: 20,
                          child: (validRole() || isGA()) ? FloatingActionButton(
                            onPressed: ()=>GlobalFunction.changePage(context, AddNewsPage(newsBloc: newsBloc,roleId: widget.roleId, )),
                            backgroundColor: UIData.accentColor,
                            child: Text("+",style: TextStyle(fontSize: 28,fontWeight: FontWeight.normal,),)
                          ):Container(),
                        )
                      ],
                    ),
                    ListView.separated(
                      padding: EdgeInsets.all(10),
                      itemBuilder: (BuildContext ctxList, int index) {
                        return MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: (){
                            newsBloc.getNewsExternal(titleEksternal.elementAt(index));
                            showDialog(
                              context: ctxList,
                              builder: (BuildContext ctxDialog){
                                return AlertDialog(
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(ctxDialog).pop();
                                      },
                                    ),
                                  ],
                                  title: Text("Choose Source ${titleEksternal.elementAt(index)}"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      StreamBuilder(
                                        stream: newsBloc.listNewsExternalStream,
                                        builder: (ctxStream, AsyncSnapshot<List<NewsExternal>> snapshot) {
                                          return !snapshot.hasData ? Container() : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (ctxList,i){
                                              NewsExternal data = snapshot.data[i];
                                              return  ListTile(
                                                onTap: ()=>GlobalFunction.changePage(context, WebViewPage(data.url,data.source)),
                                                title: Container(child: Text(data.source)),
                                                trailing:(validRole() || isGA()) ? PopupMenuButton(
                                                  onSelected: (val){
                                                    if(val == 1){
                                                      showDialog(
                                                        context: ctxDialog,
                                                        builder: (ctxDialog2){
                                                          return generateDialogInput(id:data.id,category:titleEksternal.elementAt(index),source: data.source,url: data.url);
                                                        }
                                                      );
                                                      // newsBloc.approve(context, snapshot.data[index]);
                                                    }else{
                                                      newsBloc.deleteNewsExternal(context, NewsExternal(id: data.id));
                                                      // newsBloc.onDelete(context, snapshot.data[index]);
                                                    }
                                                  },
                                                  icon: Icon(Icons.more_vert,color: UIData.bcContactColor,),
                                                  itemBuilder: (BuildContext popUpContext) {
                                                    return [
                                                      PopupMenuItem(
                                                        value: 1,
                                                        child: Text("Edit"),
                                                      ),
                                                      PopupMenuItem(
                                                        value: 2,
                                                        child: Text("Delete"),
                                                      )
                                                    ];
                                                  },
                                                ):null,
                                              );
                                            },
                                            // children: <Widget>[
                                              // ListTile(
                                              //   onTap: ()=>GlobalFunction.changePage(context, WebViewPage(urlEksternal.elementAt(index).elementAt(0),titleEksternal.elementAt(index))),
                                              //   title: Text("Kompas"),
                                              // ),
                                              // ListTile(
                                              //   onTap: ()=>GlobalFunction.changePage(context, WebViewPage(urlEksternal.elementAt(index).elementAt(1),titleEksternal.elementAt(index))),
                                              //   title: Text("Liputan 6"),
                                              // ),
                                              // ListTile(
                                              //   onTap: ()=>GlobalFunction.changePage(context, WebViewPage(urlEksternal.elementAt(index).elementAt(2),titleEksternal.elementAt(index))),
                                              //   title: Text("Okezone"),
                                              // ),
                                            // ],
                                          );
                                        }
                                      ),
                                      validRole() || isGA() ? MaterialButton(
                                        minWidth: double.infinity,
                                        color: UIData.darkPrimaryColor,
                                        child: Text("+",style: TextStyle(color: Colors.white,fontSize: 24),),
                                        onPressed: ()=>showDialog(
                                          context: ctxDialog,
                                          builder: (ctxDialog2){
                                            return generateDialogInput(category:titleEksternal.elementAt(index));
                                          }
                                        ),
                                      ):Container()
                                    ],
                                  ),
                                );
                              }
                            );
                          },
                          color: Color(0xff10b780),
                          padding: EdgeInsets.all(20),
                          child: Text(titleEksternal.elementAt(index),textAlign: TextAlign.center,style: TextStyle(fontSize: 20, fontFamily: 'futura',color: Colors.white),),
                        );
                      },
                      itemCount: titleEksternal.length,
                      separatorBuilder: (BuildContext context, int index) =>SizedBox(height: 10,),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        StreamBuilder(
          initialData: true,
          stream: GlobalBloc.loadingStream, 
          builder: (BuildContext ctxLoading, AsyncSnapshot<bool> snapshot) {
            return LoadingWidget(snapshot.data);
          },
        )
      ],
    );
  }
  Widget generateDialogInput({String id, String category, String source = "", String url = ""}){
    // TextEditingController _sourceController = TextEditingController();
    // TextEditingController _urlController = TextEditingController();
    NewsExternal newsExternal = NewsExternal(category: category,id: id);
    return AlertDialog(
      title: Text("Add News External"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextFormFieldWidget(
              initialValue: source,
              labelText: "Source",
              validator: validateRequired,
              focusNode: globalBloc.generateFocusNode(0),
              nextFocusNode: globalBloc.generateFocusNode(1),
              onSaved: newsBloc.saveSource,
            ),
            CustomTextFormFieldWidget(
              initialValue: url,
              labelText: "Url",
              validator: validateRequired,
              focusNode: globalBloc.generateFocusNode(1),
              onSaved: newsBloc.saveUrl,
            ),
            MaterialButton(
              onPressed: ()=>newsBloc.onSaveNewsExternal(_formKey, newsExternal),
              minWidth: double.infinity,
              color: UIData.darkPrimaryColor,
              child: Text("Save",style: TextStyle(color: Colors.white,fontSize: 24),),
            )
          ],
        ),
      ),
    );
  }
}