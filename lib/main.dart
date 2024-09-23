import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:frontbrand_kyc/web_view_stack.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  await Permission.camera.request();
  await Permission.storage.request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KYC Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Redirect URL'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Add from here...
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text =
        'https://moneyinternational.sb.getid.dev/vp/getid-doc-selfie-liveness?token=eyJhbGciOiJSU0EtT0FFUC0yNTYiLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIn0.YRdKGkwgcBOotCCnL4QoQqwVslghY6sAb9_I2O4_YbOiAhBLF_9C4W_hVUn6BOxktx0yjtodt6SPtc71NtNEDR3nVyCIEDNpepT8ZFBCrH_lqTTRE7iJaA1c3lCGuQ9rsQos4ETdSATOICFvDSmm_pdoYNaND3Sk4nHingFjRCWBZ2h6fLNNx-n_hwUkWkrjFMdHhwVKXd-knsuKBfED4nxUOuCYWKHnHuWJW-hvAO7dUkn38G5MuiUldqV99sg0gdVwgapc484q7qx98elhs0_9lnS_mpKayMkmjXO_1GWpKG7H6FesAd2nY790VhZNB5SnoysgUxMGhMbYOdQXug.wydvqu0XFi04R9jrGV9_8Q.b1xN924sD9PNGOEpSM6UIx1iZDQU_IcXoYPLP_eM7tLfzpU1R1DOEZwz8HaSaoZTYhBbNBLmQNxgaFgqn2QE3uFsJzEZcCBWxSpu6SJSNO8.ds-OS7867JjlLT2qjKNLYcx8j_5BFWVqhB8fu4j6kTM';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration:
                    const InputDecoration(prefixIcon: Icon(Icons.search)),
                controller: _textEditingController,
                keyboardType: TextInputType.url,
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            ElevatedButton(
              child: const Icon(Icons.arrow_forward),
              onPressed: () async {
                var urlStr = _textEditingController.text;
                if (urlStr.isEmpty) {
                  return;
                }

                if (!["https"].contains(_textEditingController.text)) {
                  urlStr = 'https://$urlStr';
                }

                FocusScope.of(context).unfocus();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewStack(
                              url: _textEditingController.text,
                            )));
              },
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
