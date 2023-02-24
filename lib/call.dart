import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class PhoneCaller extends StatefulWidget {
  const PhoneCaller({super.key});

  @override
  State<PhoneCaller> createState() => _PhoneCallerState();
}

class _PhoneCallerState extends State<PhoneCaller> {
  final TextEditingController _numberCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _numberCtrl.text = "085921191121";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _numberCtrl,
              decoration: const InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            child: const Text("Test Call"),
            onPressed: () async {
              FlutterPhoneDirectCaller.callNumber(_numberCtrl.text);
            },
          )
        ],
      ),
    );
  }
}
