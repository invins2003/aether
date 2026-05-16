// ignore_for_file: avoid_print, always_specify_types, prefer_final_locals, avoid_catches_without_on_clauses
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_provider.dart';

class TerminalChatWidget extends ConsumerStatefulWidget {
  const TerminalChatWidget({super.key});

  @override
  ConsumerState<TerminalChatWidget> createState() => _TerminalChatWidgetState();
}

class _TerminalChatWidgetState extends ConsumerState<TerminalChatWidget> {
  final TextEditingController _chatController = TextEditingController();

  void _sendMessage() {
    if (_chatController.text.trim().isNotEmpty) {
      ref.read(chatProvider.notifier).addMessage("USR_${DateTime.now().millisecond}: ${_chatController.text.trim()}");
      _chatController.clear();
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = ref.watch(chatProvider);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF020205),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF00E5FF).withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF0A0A15),
              border: Border(bottom: BorderSide(color: Color(0xFF00E5FF), width: 1)),
            ),
            child: Text(
              'WORLD CHAT [GLOBAL]',
              style: GoogleFonts.robotoMono(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00E5FF),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              reverse: true,
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final msg = chatMessages[index];
                final isSys = msg.startsWith('[SERVER]') || msg.startsWith('[SYSTEM]');
                final isErr = msg.startsWith('[ERR');
                Color msgColor = Colors.white70;
                if (isSys) msgColor = const Color(0xFFFFD700);
                if (isErr) msgColor = const Color(0xFFFF0055);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    msg,
                    style: GoogleFonts.robotoMono(
                      fontSize: isMobile ? 12 : 13,
                      color: msgColor,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF05050A),
              border: Border(top: BorderSide(color: Color(0xFF00E5FF), width: 0.5)),
            ),
            child: Row(
              children: [
                Text(
                  '>',
                  style: GoogleFonts.robotoMono(color: const Color(0xFF00E5FF), fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: GoogleFonts.robotoMono(fontSize: isMobile ? 12 : 13, color: const Color(0xFF00E5FF)),
                    cursorColor: const Color(0xFF00E5FF),
                    decoration: InputDecoration(
                      hintText: 'Type message...',
                      hintStyle: GoogleFonts.robotoMono(color: const Color(0xFF00E5FF).withAlpha(100)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: isMobile ? 10 : 14),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  onPressed: _sendMessage,
                  color: const Color(0xFF00E5FF),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
