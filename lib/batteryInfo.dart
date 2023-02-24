import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryInfo extends StatefulWidget {
  const BatteryInfo({super.key});

  @override
  State<BatteryInfo> createState() => _BatteryInfoState();
}

class _BatteryInfoState extends State<BatteryInfo> {
  final Battery _battery = Battery();

  BatteryState? _batteryState;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  @override
  void initState() {
    super.initState();
    _battery.batteryState.then(_updateBatteryState);
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen(_updateBatteryState);
  }

  void _updateBatteryState(BatteryState state) {
    if (_batteryState == state) return;
    setState(() {
      _batteryState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$_batteryState'),
            ElevatedButton(
              onPressed: () async {
                final batteryLevel = await _battery.batteryLevel;
                // ignore: unawaited_futures
                showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text('Battery: $batteryLevel%'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      )
                    ],
                  ),
                );
              },
              child: const Text('Get battery level'),
            ),
            ElevatedButton(
                onPressed: () async {
                  final isInPowerSaveMode = await _battery.isInBatterySaveMode;
                  // ignore: unawaited_futures
                  showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text('Is on low power mode: $isInPowerSaveMode'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                },
                child: const Text('Is on low power mode'))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
  }
}
