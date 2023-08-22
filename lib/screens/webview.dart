import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String url;

  MyWebView({required this.url});

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {

  late WebViewController _controller;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    print("url after: "+ widget.url);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: Text('Thanh Toán', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _controller = controller;
            },
            onPageFinished: (url) {
              setState(() {
                _isLoading = false;
              });
            },
          ),
          _isLoading ? Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
    );
  }
}