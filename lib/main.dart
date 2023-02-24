import 'dart:async';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:control_center/control_center.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:torch/batteryInfo.dart';
import 'package:torch/call.dart';
import 'package:torch/contact.dart';
import 'package:torch/deviceInfo.dart';
import 'package:torch/folder.dart';
import 'package:torch/settings.dart';
import 'package:torch/volume.dart';
import 'package:torch/wifiScan.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controlCenterPlugin = ControlCenter();

  String _platformVersion = 'Unknown';
  int _batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    _subscription = InternetConnectionCheckerPlus().onStatusChange.listen(
      (status) {
        setState(() {
          _connectionStatus = status;
        });
      },
    );
    initData();
  }

  InternetConnectionStatus? _connectionStatus;
  late StreamSubscription<InternetConnectionStatus> _subscription;

  Future<void> initData() async {
    String platformVersion;
    int batteryLevel;
    bool? switchBool = await _controlCenterPlugin.openOrCloseFlashlight();

    try {
      platformVersion = await _controlCenterPlugin.getPlatformVersion() ??
          'Unknown platform version';
      batteryLevel = await _controlCenterPlugin.getBatteryLevel() ?? 0;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      batteryLevel = 0;
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          GestureDetector(
            onTap: (() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BatteryInfo(),
                ),
              );
            }),
            child: Icon(Icons.battery_2_bar),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Android Version:  $_platformVersion\n'),
            Text('Battery Level:  $_batteryLevel %\n'),
            TextButton(
              child: Text('torch'),
              onPressed: () async {
                await _controlCenterPlugin.openOrCloseFlashlight();
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Your internet connection status is:',
                ),
                Text(
                  _connectionStatus?.toString() ?? 'Unknown',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PhoneSettings(),
                  ),
                );
              }),
              child: Text("Go to settings"),
            ),
            SizedBox(
              height: 55,
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FlutterContactsExample(),
                  ),
                );
              }),
              child: Text("Contacts"),
            ),
            SizedBox(
              height: 55,
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DeviceInfo(),
                  ),
                );
              }),
              child: Text("Device"),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () async {
                if (await ConnectivityWrapper.instance.isConnected) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Internet connection is here!"),
                      content: const Text("There is Internet"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            color: Colors.green,
                            padding: const EdgeInsets.all(14),
                            child: const Text("okay"),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: const Text("No Internet connection"),
                            content: const Text("There is No Internet"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  color: Colors.green,
                                  padding: const EdgeInsets.all(14),
                                  child: const Text("okay"),
                                ),
                              ),
                            ],
                          ));
                }
              },
              child: Text('Connect'),
            ),
            SizedBox(
              height: 55,
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DeviceFolder()),
                );
              }),
              child: Text("Folder"),
            ),
            SizedBox(
              height: 55,
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WifiScan()),
                );
              }),
              child: Text("WifiScan"),
            ),
            SizedBox(
              height: 55,
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PhoneCaller()),
                );
              }),
              child: Text("Caller"),
            ),
            SizedBox(
              height: 55,
            ),
            GestureDetector(
              onTap: (() {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => VolumeTerminal()),
                );
              }),
              child: Text("Volume"),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
