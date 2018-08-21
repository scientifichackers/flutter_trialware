import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _channel = const MethodChannel('flutter_trialware');

/// The time at which the app was first installed, in milliseconds,
/// since Epoch (midnight, January 1, 1970 UTC).
///
/// It's the exact figure returned by PackageInfo.firstInstallTime -
///
///   https://developer.android.com/reference/android/content/pm/PackageInfo.html#firstInstallTime
Future<int> getFirstInstallTime() async {
  return (await _channel.invokeMethod('getFirstInstallTime')) as int;
}

/// The time at which the app was first installed as a `DateTime` object.
Future<DateTime> getFirstInstallDateTime() async =>
    DateTime.fromMillisecondsSinceEpoch(await getFirstInstallTime());

/// The time `Duration` for which the app is installed.
///
/// Or, the difference between the time at which the app was first installed and now.
Future<Duration> getInstallDuration() async =>
    (DateTime.now()).difference(await getFirstInstallDateTime());

/// Check whether the trial period is expired.
///
/// Example:
/// checkTrialExpired(Duration(days: 365))
Future<bool> checkTrialExpired(Duration trialDuration) async =>
    (await getInstallDuration()) > trialDuration;

/// Return the `DateTime` object when the trial period will expire.
Future<DateTime> getTrialExpireDateTime(Duration trialDuration) async =>
    (await getFirstInstallDateTime()).add(trialDuration);
