// ignore_for_file: avoid_print, always_specify_types, prefer_final_locals, avoid_catches_without_on_clauses
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerNotifier extends Notifier<int> {
  Timer? _timer;

  @override
  int build() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (state > 0) {
        state = state - 100;
      }
    });

    ref.onDispose(() {
      _timer?.cancel();
    });

    return 105610000;
  }
}

final timerProvider = NotifierProvider<TimerNotifier, int>(() {
  return TimerNotifier();
});
