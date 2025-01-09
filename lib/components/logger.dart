// lib/components/logger.dart
import 'package:flutter/material.dart';
import 'package:gemini_multimodal_live_app/contexts/live_api_context.dart';

class Logger extends StatelessWidget {
  const Logger({super.key});

  @override
  Widget build(BuildContext context) {
    final liveAPIContext = LiveAPIContext.of(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
        color: Colors.black87,
      ),
      height: 200,
      child: ValueListenableBuilder<List<String>>(
        valueListenable: liveAPIContext.logMessages,
        builder: (context, logMessages, child) {
          return ListView.builder(
            itemCount: logMessages.length,
            itemBuilder: (context, index) {
              return Text(
                logMessages[index],
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              );
            },
          );
        },
      ),
    );
  }
}