// ignore_for_file: avoid_print, always_specify_types, prefer_final_locals, avoid_catches_without_on_clauses
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'timer_provider.dart';

class GlobalPulseWidget extends ConsumerStatefulWidget {
  const GlobalPulseWidget({super.key});

  @override
  ConsumerState<GlobalPulseWidget> createState() => _GlobalPulseWidgetState();
}

class _GlobalPulseWidgetState extends ConsumerState<GlobalPulseWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(int milliseconds) {
    final int totalSeconds = milliseconds ~/ 1000;
    final int days = totalSeconds ~/ 86400;
    final int hours = (totalSeconds % 86400) ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;
    
    final String dStr = days.toString().padLeft(2, '0');
    final String hStr = hours.toString().padLeft(2, '0');
    final String mStr = minutes.toString().padLeft(2, '0');
    final String sStr = seconds.toString().padLeft(2, '0');

    return '$dStr D : $hStr H : $mStr M : $sStr S';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(200),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFFF0055).withAlpha(150), width: 2),
          boxShadow: [
            BoxShadow(color: const Color(0xFFFF0055).withAlpha(80), blurRadius: 20, spreadRadius: 2),
          ],
        ),
        child: Column(
          children: [
            Text(
              'WORLD BOSS SPAWNS IN',
              style: GoogleFonts.robotoMono(
                fontSize: isMobile ? 12 : 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFF0055),
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: isMobile ? 8 : 16),
            RepaintBoundary(
              child: Consumer(
                builder: (context, ref, child) {
                  final timeRemaining = ref.watch(timerProvider);
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _formatTime(timeRemaining),
                      style: GoogleFonts.orbitron(
                        fontSize: isMobile ? 24 : 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: isMobile ? 1.0 : 2.0,
                        shadows: [
                          const Shadow(color: Color(0xFFFF0055), blurRadius: 15),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
