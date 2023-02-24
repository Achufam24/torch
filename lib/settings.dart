import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class PhoneSettings extends StatefulWidget {
  const PhoneSettings({super.key});

  @override
  State<PhoneSettings> createState() => _PhoneSettingsState();
}

class _PhoneSettingsState extends State<PhoneSettings> {
  @override
  void initState() {
    /// Call out to intialize platform state.
    initPlatformState();
    super.initState();
  }

  /// Initialize platform state.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: (() {
                    AppSettings.openWIFISettings();
                  }),
                  child: Text("Wifi")),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                  onTap: (() {
                    AppSettings.openBluetoothSettings();
                  }),
                  child: Text("Bluetooth")),
              SizedBox(
                height: 70,
              ),
              GestureDetector(
                  onTap: (() async {
                    await AppSettings.openHotspotSettings(
                      asAnotherTask: true,
                    );
                  }),
                  child: Text("Hotspot")),
              SizedBox(
                height: 70,
              ),
              GestureDetector(
                  onTap: (() async {
                    await AppSettings.openDeviceSettings(
                      asAnotherTask: true,
                    );
                  }),
                  child: Text("Device settings")),
              SizedBox(
                height: 70,
              ),
              GestureDetector(
                  onTap: (() async {
                    await AppSettings.openLockAndPasswordSettings();
                  }),
                  child: Text("Password")),
            ],
          ),
        ),
      ),
    );
  }
}
