import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.url, super.key}); // MODIFY

  final String url; // ADD

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  // final GlobalKey webViewKey = GlobalKey();
  var loadingPercentage = 0.0;
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    // useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    useOnDownloadStart: true,
    javaScriptEnabled: true,
    javaScriptCanOpenWindowsAutomatically: true,
    supportZoom: false,
    useHybridComposition: true,
    alwaysBounceVertical: true,
    allowsInlineMediaPlayback: true,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Center(
              child: Text(
            'KYC',
            style: TextStyle(color: Colors.white),
          )),
        ),
        body: Column(
          children: [
            Expanded(
                child: Stack(children: [
              InAppWebView(
                // key: webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                initialSettings: settings,
                // initialUserScripts: UnmodifiableListView<UserScript>([]),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onPermissionRequest: (controller, permission) async {
                  return PermissionResponse(
                      action: PermissionResponseAction.GRANT);
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    loadingPercentage = progress / 100;
                  });
                },
                onLoadStart: (controller, url) {
                  print("On start");
                },
                onReceivedHttpError: (controller, request, response) {
                  showAlertDialog(context, response.toString());
                },
                onReceivedError: (controller, request, error) {
                  showAlertDialog(context, error.description);
                },
                onConsoleMessage: (controller, message) {
                  print(message);
                },
              ),
              if (loadingPercentage < 1.0)
                LinearProgressIndicator(
                  value: loadingPercentage,
                ),
            ]))
          ],
        ));
  }

  showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Error message"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
