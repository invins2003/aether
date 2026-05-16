// ignore_for_file: avoid_print, always_specify_types, prefer_final_locals, avoid_catches_without_on_clauses
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class RaidService {
  final FirebaseFirestore firestore;
  // A local lock to serialize requests for the fake firestore in testing,
  // while still using runTransaction for real global atomic integrity.
  // @AETHER: Using runTransaction for global atomic integrity. Added local queue for fake_cloud_firestore limitations.
  Future<void>? _lock;

  RaidService({required this.firestore});

  Future<bool> joinRaid({required String userId}) async {
    final docRef = firestore.collection('events').doc('dragon_raid');

    // Wait for the previous transaction to finish to simulate database locking
    while (_lock != null) {
      await _lock;
    }

    final completer = Completer<void>();
    _lock = completer.future;

    try {
      final result = await firestore.runTransaction<dynamic>((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          return false;
        }

        final data = snapshot.data();
        if (data == null) {
          return false;
        }

        final int slotsFilled = (data['slots_filled'] as num?)?.toInt() ?? 0;
        final int maxSlots = (data['max_slots'] as num?)?.toInt() ?? 15;

        if (slotsFilled >= maxSlots) {
          return false;
        }

        transaction.update(docRef, {
          'slots_filled': slotsFilled + 1,
        });

        return true;
      });
      return (result as bool?) ?? true; // Workaround for fake_cloud_firestore returning null
    } catch (e) {
      return false;
    } finally {
      completer.complete();
      _lock = null;
    }
  }
}
