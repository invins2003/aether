// ignore_for_file: avoid_print, always_specify_types, prefer_final_locals, avoid_catches_without_on_clauses
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../raid_service.dart';
import '../../core/firestore_provider.dart';
import '../chat/chat_provider.dart';

final raidServiceProvider = Provider<RaidService>((ref) {
  return RaidService(firestore: ref.watch(firestoreProvider));
});

class RaidState {
  final int slotsFilled;
  final bool joined;
  final String? error;

  RaidState({this.slotsFilled = 0, this.joined = false, this.error});

  RaidState copyWith({int? slotsFilled, bool? joined, String? error}) {
    return RaidState(
      slotsFilled: slotsFilled ?? this.slotsFilled,
      joined: joined ?? this.joined,
      error: error,
    );
  }
}

class RaidNotifier extends Notifier<RaidState> {
  StreamSubscription? _sub;

  @override
  RaidState build() {
    final firestore = ref.watch(firestoreProvider);
    _listenToRaid(firestore);
    
    ref.onDispose(() {
      _sub?.cancel();
    });

    return RaidState();
  }

  void _listenToRaid(FirebaseFirestore firestore) {
    _sub = firestore.collection('events').doc('dragon_raid').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          final slots = (data['slots_filled'] as num?)?.toInt() ?? 0;
          state = state.copyWith(slotsFilled: slots);
        }
      }
    });
  }

  Future<bool> joinRaid() async {
    if (state.joined) return false;
    
    final raidService = ref.read(raidServiceProvider);
    final chat = ref.read(chatProvider.notifier);

    try {
      final success = await raidService.joinRaid(userId: 'usr_${DateTime.now().millisecondsSinceEpoch}');
      if (success) {
        state = state.copyWith(joined: true, error: null);
        chat.addMessage("[SYSTEM]: YOU HAVE JOINED THE RAID PARTY.");
        return true;
      } else {
        state = state.copyWith(error: "RAID FULL");
        chat.addMessage("[SYSTEM]: RAID IS FULL.");
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      chat.addMessage("[ERR]: EXCEPTION: $e");
      return false;
    }
  }
}

final raidProvider = NotifierProvider<RaidNotifier, RaidState>(() {
  return RaidNotifier();
});
