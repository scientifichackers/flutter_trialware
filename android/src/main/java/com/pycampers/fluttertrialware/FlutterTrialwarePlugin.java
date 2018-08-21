package com.pycampers.fluttertrialware;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterTrialwarePlugin
 */
public class FlutterTrialwarePlugin implements MethodCallHandler {
  private final Context context;

  private FlutterTrialwarePlugin(Context context) {
    this.context = context;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_trialware");
    channel.setMethodCallHandler(new FlutterTrialwarePlugin(registrar.context()));
  }

  @TargetApi(Build.VERSION_CODES.GINGERBREAD)
  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getFirstInstallTime")) {
      try {
        result.success(context.getPackageManager().getPackageInfo(context.getPackageName(), 0).firstInstallTime);
      } catch (PackageManager.NameNotFoundException e) {
        result.error("NameNotFoundException", e.getMessage(), null);
      }
    } else {
      result.notImplemented();
    }
  }
}
