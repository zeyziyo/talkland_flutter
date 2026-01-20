import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class GameLobbyWidget extends StatelessWidget {
  final VoidCallback onStartDefense;
  final VoidCallback onStartDialogue;

  const GameLobbyWidget({
    super.key,
    required this.onStartDefense,
    required this.onStartDialogue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.gameModeTitle,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                l10n.gameModeDesc,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Game 1: Word Defense
              _buildGameCard(
                context,
                title: "🛡️ ${l10n.wordDefenseTitle}",
                desc: l10n.wordDefenseDesc,
                color: Colors.red[100]!,
                icon: Icons.shield,
                onTap: onStartDefense,
              ),
              
              const SizedBox(height: 20),

              // Game 2: Dialogue Quest
              _buildGameCard(
                context,
                title: "🗣️ ${l10n.dialogueQuestTitle}",
                desc: l10n.dialogueQuestDesc,
                color: Colors.blue[100]!,
                icon: Icons.forum,
                onTap: onStartDialogue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required String desc,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: Colors.black54),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
