import 'package:flutter/material.dart';
import 'games/game_lobby_widget.dart';
import 'games/word_defense_widget.dart';
import 'games/dialogue_quest_widget.dart';

enum GameModeType {
  lobby,
  wordDefense,
  dialogueQuest,
}

class Mode4Widget extends StatefulWidget {
  final Key? gameStartButtonKey;
  final Key? gameSpeedKey;
  final Key? gameDirectionKey;

  const Mode4Widget({
    super.key,
    this.gameStartButtonKey,
    this.gameSpeedKey,
    this.gameDirectionKey,
  });

  @override
  State<Mode4Widget> createState() => _Mode4WidgetState();
}

class _Mode4WidgetState extends State<Mode4Widget> {
  GameModeType _currentMode = GameModeType.lobby;

  void _goToLobby() {
    setState(() {
      _currentMode = GameModeType.lobby;
    });
  }

  void _startWordDefense() {
    setState(() {
      _currentMode = GameModeType.wordDefense;
    });
  }

  void _startDialogueQuest() {
    setState(() {
      _currentMode = GameModeType.dialogueQuest;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentMode) {
      case GameModeType.lobby:
        return GameLobbyWidget(
          onStartDefense: _startWordDefense,
          onStartDialogue: _startDialogueQuest,
        );
      case GameModeType.wordDefense:
        return WordDefenseWidget(
          onQuit: _goToLobby,
        );
      case GameModeType.dialogueQuest:
        return DialogueQuestWidget(
          onQuit: _goToLobby,
        );
    }
  }
}
