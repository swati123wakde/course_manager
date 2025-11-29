import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/connectivity_service.dart';

class ConnectivityProvider with ChangeNotifier {
  final ConnectivityService _connectivityService = ConnectivityService();

  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  // Initialize and start listening to connectivity changes
  Future<void> initialize() async {
    _isOnline = await _connectivityService.isConnected();
    notifyListeners();

    _connectivitySubscription = _connectivityService.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        _isOnline = !results.contains(ConnectivityResult.none);
        notifyListeners();
      },
    );
  }

  // Check connectivity status
  Future<void> checkConnectivity() async {
    _isOnline = await _connectivityService.isConnected();
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}