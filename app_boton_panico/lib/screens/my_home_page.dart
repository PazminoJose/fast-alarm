import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NodeJS - OneSignal"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey,
      body: const Center(
        child: Text("Push Notifaction"),
      ),
    );
  }

  Future<void> initPlatform() async {
    await OneSignal.shared.setAppId('9fd9a40d-8646-450c-bd3b-d661b0e8ee42');
    await OneSignal.shared
        .getDeviceState()
        .then((value) => {print(value?.userId)});
  }
}
