import 'package:connectivity_plus/connectivity_plus.dart';

abstract class InternetConnectivity {
  Stream<bool> get connectivityStream;
  Future<bool> isConnected();
}

class InternetConnectivityImpl implements InternetConnectivity {
  final Connectivity _connectivity;

  InternetConnectivityImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Stream<bool> get connectivityStream => _connectivity.onConnectivityChanged
      .map((event) => event != ConnectivityResult.none);

  @override
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
