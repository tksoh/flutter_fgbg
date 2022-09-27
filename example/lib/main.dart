import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final picker = ImagePicker();

  List<String> events = [];

  void didChangeAppLifecycleState(AppLifecycleState state) {
    events.add('${DateTime.now()}: ${state.toString()}');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return FGBGNotifier(
      onEvent: (event) {
        events.add('${DateTime.now()}: ${event.toString()}');
        setState(() {});
      },
      child: MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        events.clear();
                        setState(() {});
                      },
                      child: Text("Clear"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        events.add("// Opening camera");
                        setState(() {});
                        await picker.pickImage(source: ImageSource.camera);
                      },
                      child: Text("Take Image"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        events.add("// Opening gallery");
                        setState(() {});
                        await picker.pickImage(source: ImageSource.gallery);
                      },
                      child: Text("Pick Image"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        events.add("// Prompting biometric");
                        setState(() {});
                        var auth = LocalAuthentication();

                        await auth.authenticate(
                            biometricOnly: true, localizedReason: 'Test');
                      },
                      child: Text("FaceID"),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [for (var e in events) Text(e)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
