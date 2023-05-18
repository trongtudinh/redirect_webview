import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.url, super.key}); // MODIFY

  final String url; // ADD

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0.0;
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

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
                initialUrlRequest: URLRequest(
                  url: Uri.parse(widget.url),
                ),
                initialOptions: options,
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    loadingPercentage = progress / 100;
                  });
                },
                onLoadHttpError: (controller, url, statusCode, description) {
                  showAlertDialog(context, description);
                },
                onLoadError: (controller, url, code, message) {
                  showAlertDialog(context, message);
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
