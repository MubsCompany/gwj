import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:template/blocs/mail/mail_bloc.dart';
import 'package:template/pages/mail/list_mail_page.dart';
import 'package:template/utils/api.dart';
import 'package:template/utils/global_function.dart';
import 'package:template/utils/uidata.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MailPage extends StatelessWidget {
                // createPopUpItem(0, Icons.restore, "Reset"),
                // createPopUpItem(1, Icons.save, "Save as Template"),
                // createPopUpItem(2, Icons.save, "Save as Pdf"),
                // createPopUpItem(3, FontAwesomeIcons.folderOpen, "Open Template"),
                // createPopUpItem(4, Icons.send, "Send Pdf"),
  String companyId;
  MailPage(this.companyId);
  MailBloc mailBloc = MailBloc();
  WebViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => GlobalFunction.changePage(context, ListMailPage(mailBloc,companyId)),
        child: Icon(Icons.save),
        backgroundColor: UIData.accentColor,
      ),
//      appBar: AppBar(
//        title: new Text("Mail"),
//        actions: <Widget>[
//          InkWell(
//            // onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>ListMailPage(mailBloc))),
//            onTap: () => GlobalFunction.changePage(context, ListMailPage(mailBloc,companyId)),
//            child: Padding(
//              padding: const EdgeInsets.symmetric(horizontal:15.0),
//              child: Icon(FontAwesomeIcons.folderOpen),
//            ),
//          ),
//        ],
//      ),
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
                Text('Mail', style: TextStyle(fontFamily: 'futura', fontWeight: FontWeight.bold, fontSize: 20),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: StreamBuilder(
              initialData: ApiProvider.CORE_URL+"/mail?companyId=$companyId",
              stream: mailBloc.urlStream,
              builder: (BuildContext ctx, AsyncSnapshot<String> snapshot){
                print(snapshot.data);
                if (controller != null && ![null,""].contains(snapshot.data)) {
                  controller.loadUrl(snapshot.data);
                  print(snapshot.data);
                }
                return WebView(
                  onWebViewCreated: (WebViewController webViewController) {
                    controller = webViewController;
                  },
                  initialUrl: snapshot.data,
                  javascriptMode: JavascriptMode.unrestricted,
                );
              },
            ),
          ),
        ],
      ),
    );
    // return WebviewScaffold(
    //   appBar: AppBar(
    //     title: new Text("Mail"),
    //     actions: <Widget>[
    //       InkWell(
    //         // onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>ListMailPage(mailBloc))),
    //         onTap: () => GlobalFunction.changePage(context, ListMailPage(mailBloc)),
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal:15.0),
    //           child: Icon(FontAwesomeIcons.folderOpen),
    //         ),
    //       ),
    //     ],
    //   ),
    //   url: ApiProvider.CORE_URL+"/mail?companyId=$companyId",
    //   // withZoom: false,
    //   // clearCache: true,
    //   // clearCookies: true,
    // );
  }
}
