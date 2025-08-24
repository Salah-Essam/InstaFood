import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity connectivity;

  NetworkInfo({required this.connectivity});

  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();

    // return connectivityResult[0] != ConnectivityResult.none;
    // Check all results
    final isConnected =
        connectivityResult.isNotEmpty &&
        connectivityResult.any((result) {
          return result != ConnectivityResult.none;
        });

    return isConnected;
  }
}
