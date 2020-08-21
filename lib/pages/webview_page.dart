import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatelessWidget {
  final String url;
  final String title;
  WebViewPage(this.url,[this.title = "Browser"]);
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(title: new Text(title),),
      url: url,
      withZoom: false,
      clearCache: true,
      clearCookies: true,
    );
  }
}
