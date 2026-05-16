// ignore_for_file: avoid_print, always_specify_types, prefer_final_locals, avoid_catches_without_on_clauses
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'raid_provider.dart';

class VanguardUplinkWidget extends ConsumerWidget {
  const VanguardUplinkWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final raidState = ref.watch(raidProvider);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF00E5FF).withAlpha(100), width: 1),
      ),
      child: isMobile 
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfo(raidState, isMobile),
              const SizedBox(height: 16),
              _buildButton(ref, raidState, isMobile),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfo(raidState, isMobile),
              _buildButton(ref, raidState, isMobile),
            ],
          ),
    );
  }

  Widget _buildInfo(RaidState raidState, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RAID MATCHMAKING',
          style: GoogleFonts.orbitron(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.memory, color: Color(0xFF00E5FF), size: 16),
            const SizedBox(width: 8),
            Text(
              'SLOTS FILLED: ${raidState.slotsFilled} / 15',
              style: GoogleFonts.robotoMono(
                fontSize: 14,
                color: raidState.slotsFilled >= 15 ? const Color(0xFFFF0055) : const Color(0xFF00E5FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(WidgetRef ref, RaidState raidState, bool isMobile) {
    final bool canJoin = !raidState.joined && raidState.slotsFilled < 15;

    return GestureDetector(
      onTap: canJoin ? () => ref.read(raidProvider.notifier).joinRaid() : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: raidState.joined
              ? const Color(0xFF00FF88).withAlpha(40)
              : raidState.slotsFilled >= 15
                  ? Colors.grey.withAlpha(40)
                  : const Color(0xFF00E5FF).withAlpha(40),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: raidState.joined ? const Color(0xFF00FF88) : (raidState.slotsFilled >= 15 ? Colors.grey : const Color(0xFF00E5FF)),
            width: 1.5,
          ),
          boxShadow: raidState.joined || raidState.slotsFilled >= 15
              ? []
              : [
                  BoxShadow(color: const Color(0xFF00E5FF).withAlpha(60), blurRadius: 10, spreadRadius: 1)
                ],
        ),
        child: Text(
          raidState.joined ? 'JOINED' : 'JOIN RAID',
          style: GoogleFonts.robotoMono(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: raidState.joined ? const Color(0xFF00FF88) : (raidState.slotsFilled >= 15 ? Colors.grey : const Color(0xFF00E5FF)),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
