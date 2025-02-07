import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/audio/audio_player.dart';

// Define custom intents
class NewFileIntent extends Intent {}

class SaveFileIntent extends Intent {}

class PlayerIntent extends Intent {}

class KeyboardShortcuts extends ConsumerStatefulWidget {
  final Widget child;
  const KeyboardShortcuts({super.key, required this.child});

  @override
  _KeyboardShortcutsState createState() => _KeyboardShortcutsState();
}

class _KeyboardShortcutsState extends ConsumerState<KeyboardShortcuts> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  void _toggleAudioPlayer() {
    debugPrint("Toggling audio player...");
    try {
      final audioPlayer = ref.read(audioPlayerProvider);
      audioPlayer.playing ? audioPlayer.pause() : audioPlayer.play();
    } catch (e, stack) {
      debugPrint("Error toggling player: $e\n$stack");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
              NewFileIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              SaveFileIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): PlayerIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            NewFileIntent: CallbackAction<NewFileIntent>(
              onInvoke: (intent) {
                debugPrint("CTRL + N Pressed: Creating a new file");
                return null;
              },
            ),
            SaveFileIntent: CallbackAction<SaveFileIntent>(
              onInvoke: (intent) {
                debugPrint("CTRL + S Pressed: Saving file");
                return null;
              },
            ),
            PlayerIntent: CallbackAction<PlayerIntent>(
              onInvoke: (intent) {
                _toggleAudioPlayer();
                return null;
              },
            ),
          },
          child: widget.child,
        ),
      ),
    );
  }
}
