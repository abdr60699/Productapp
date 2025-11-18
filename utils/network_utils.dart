// lib/src/network_utils.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  NetworkUtils._();

  static Future<bool> isConnected() async =>
      (await Connectivity().checkConnectivity()) != ConnectivityResult.none;

  static Future<bool> isWifi() async =>
      (await Connectivity().checkConnectivity()) == ConnectivityResult.wifi;

  static Future<bool> isMobileData() async =>
      (await Connectivity().checkConnectivity()) == ConnectivityResult.mobile;

  static Future<T> retry<T>(Future<T> Function() fn,
      {int retries = 3, Duration delay = const Duration(seconds: 1)}) async {
    int attempt = 0;
    while (true) {
      try {
        return await fn();
      } catch (_) {
        attempt++;
        if (attempt >= retries) rethrow;
        await Future.delayed(delay);
      }
    }
  }

  static Function() debounce(Function() fn, Duration wait) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(wait, () => fn());
    };
  }

  static Function() throttle(Function() fn, Duration duration) {
    bool ready = true;
    return () {
      if (!ready) return;
      ready = false;
      fn();
      Timer(duration, () => ready = true);
    };
  }
}
