// ignore_for_file: avoid_print, always_specify_types, prefer_final_locals, avoid_catches_without_on_clauses
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../features/timer/global_pulse_widget.dart';
import '../features/raid/vanguard_uplink_widget.dart';
import '../features/chat/terminal_chat_widget.dart';

class WorldEventScreen extends ConsumerWidget {
  const WorldEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final bool isMobile = screenSize.width < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF05050A),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 32.0, 
                vertical: 16.0
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Header / Title
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'A E T H E R   O V E R R I D E',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.orbitron(
                          fontSize: isMobile ? 20 : 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00E5FF),
                          letterSpacing: isMobile ? 2.0 : 4.0,
                          shadows: [
                            const Shadow(color: Color(0xFF00E5FF), blurRadius: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 32),

                  // The Global Pulse
                  const GlobalPulseWidget(),
                  SizedBox(height: isMobile ? 24 : 32),
                  
                  // The Geo-Raid
                  const VanguardUplinkWidget(),
                  SizedBox(height: isMobile ? 24 : 32),

                  // The Engagement Chat (Terminal Style)
                  SizedBox(
                    height: isMobile ? 350 : MediaQuery.sizeOf(context).height * 0.4,
                    child: const TerminalChatWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
