// ignore_for_file: avoid_print, always_specify_types, prefer_final_locals, avoid_catches_without_on_clauses
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [
      "[SERVER]: WORLD BOSS 'MECHA-DRAGON' DETECTED.",
      "[SERVER]: PREPARE FOR RAID. 15 SLOTS AVAILABLE."
    ];
  }

  void addMessage(String message) {
    state = [message, ...state];
  }
}

final chatProvider = NotifierProvider<ChatNotifier, List<String>>(() {
  return ChatNotifier();
});
