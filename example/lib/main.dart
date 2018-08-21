import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_trialware/flutter_trialware.dart';
import 'dart:io';

const TRIAL_DURATION = Duration(seconds: 30);

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter trialware'),
        ),
        body: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _installDuration = "", _hasExpired = "", _expireOn = "";

  @override
  void initState() {
    super.initState();
    updateStateLoop();
  }

  updateStateLoop() async {
    DateTime expireOn = await getTrialExpireDateTime(TRIAL_DURATION);
    if (mounted) setState(() => _expireOn = expireOn.toString());

    while (true) {
      Duration installDuration = await getInstallDuration();
      bool hasExpired = await checkTrialExpired(TRIAL_DURATION);

      if (!mounted) break;

      if (hasExpired) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Trial expired!'),
                actions: <Widget>[
                  SimpleDialogOption(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
        );
        exit(0);
      }

      this.setState(() {
        _hasExpired = hasExpired ? 'Yes' : 'No';
        _installDuration = installDuration.toString();
      });

      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          'Installed Duration: $_installDuration',
          'Will expire at: $_expireOn',
          'Has Expired: $_hasExpired',
          'Trial Duration: ${TRIAL_DURATION.toString()}'
        ].map((text) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
