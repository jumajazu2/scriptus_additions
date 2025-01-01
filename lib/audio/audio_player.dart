// import 'dart:js_interop';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scriptus/models/meeting.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/providers/meeting_provider.dart';
import 'common.dart';
import 'package:rxdart/rxdart.dart';

// void main() => runApp(const AudioPlayerWidget());
class AudioPlayerController extends StateNotifier<AudioPlayer> {
  AudioPlayerController() : super(AudioPlayer());

  Future<void> seek(Duration position) async {
    await state.seek(position);
  }
}

final audioPlayerControllerProvider =
    StateNotifierProvider<AudioPlayerController, AudioPlayer>(
        (ref) => AudioPlayerController());

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = ref.watch(audioPlayerControllerProvider.notifier).state;
  return player;
});
// StateNotifierProvider<AudioPlayer, AudioPlayer>(
//     (ref) => AudioPlayer());

class AudioPlayerWidget extends ConsumerStatefulWidget {
  const AudioPlayerWidget({Key? key}) : super(key: key);

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends ConsumerState<AudioPlayerWidget>
    with WidgetsBindingObserver {
  // final _player = AudioPlayer();
  late final AudioPlayer _player;
  late final String _sermon;
  late Meeting _meeting;

  // @override
  // void initState() {
  //   super.initState();
  //   ambiguate(WidgetsBinding.instance)!.addObserver(this);
  //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //     statusBarColor: Colors.black,
  //   ));
  //   _init();
  // }

  @override
  void initState() {
    super.initState();
    _player = ref.read(audioPlayerControllerProvider.notifier).state;
    _sermon = ref.read(selectedMeetingProvider).miroDate;
    _meeting = ref.read(selectedMeetingProvider);
    _init();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      if (_meeting.mp3LinkBase != '') {
        String l = ref.watch(currentTranscriptProvider).mp3Language;
        print("INIT:: ${_meeting.mp3LinkBase}-$l.mp3");
        await _player.setAudioSource(
            AudioSource.uri(Uri.parse("${_meeting.mp3LinkBase}-$l.mp3")));
        // await _player.setAudioSource(AudioSource.file(
        //     '/Users/miro/Documents/Ewald Frank/_Transcriptions/1981-08-30-1400-Zürich-deutsch.mp3 large-ANE/1981-08-30-1400-Zürich-deutsch.mp3-56kbps.mp3'));
      }
    } catch (e) {
      print("AudioPlayerWidget >> _init - Error loading audio source: $e");
      // Dispose of the player if it fails to load a source.
      _player.dispose();
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        // Display play/pause button and volume/speed sliders.
        ControlButtons(_player);
    // Display seek bar. Using StreamBuilder, this widget rebuilds
    // each time the position, buffered position or duration changes.
    // StreamBuilder<PositionData>(
    //   stream: _positionDataStream,
    //   builder: (context, snapshot) {
    //     final positionData = snapshot.data;
    //     return SeekBar(
    //       duration: positionData?.duration ?? Duration.zero,
    //       position: positionData?.position ?? Duration.zero,
    //       bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
    //       onChangeEnd: _player.seek,
    //     );
    // },
    // ),
    // ],
    // );
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 50,
                height: 40,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                  // constraints: BoxConstraints.tight(Size.square(10)),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 40,
                  color: Colors.red,
                  onPressed: () {
                    print(player.audioSource);
                    print(player.duration);
                    // print(player.position);
                    // print(player.bufferedPosition);
                    print(player.processingState);
                    // print(player.play();
                    player.play();
                  });
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 40,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 40,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            iconSize: 35,
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14.0)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 3,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),

        StreamBuilder<Duration>(
          stream: player.positionStream,
          builder: (context, snapshot) {
            final currentPosition = snapshot.data ?? Duration.zero;
            final totalDuration = player.duration ?? Duration.zero;
            final remainingTime = totalDuration - currentPosition;
            // var l = snapshot.data.isNull ? 0 : snapshot.data?.toString().length;
            // var o = l >= 7 ? l : l;
            // Helper function to format Duration as MM:SS
            String formatDuration(Duration duration) {
              final minutes =
                  duration.inMinutes.remainder(60).toString().padLeft(2, '0');
              final seconds =
                  duration.inSeconds.remainder(60).toString().padLeft(2, '0');
              return "$minutes:$seconds";
            }

            return currentPosition != null
                ? IconButton(
                    iconSize: 60,
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Display remaining time in MM:SS
                        Text(
                          "-${formatDuration(currentPosition)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(width: 10), // Space between texts
                        // Display current position in MM:SS
                        Text(
                          formatDuration(remainingTime),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Adjust Position",
                              textAlign: TextAlign.center),
                          content: StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data;
                              return SizedBox(
                                height: 90,
                                child: SeekBar(
                                  duration:
                                      positionData?.duration ?? Duration.zero,
                                  position:
                                      positionData?.position ?? Duration.zero,
                                  bufferedPosition:
                                      positionData?.bufferedPosition ??
                                          Duration.zero,
                                  onChangeEnd: player.seek,
                                ),
                              );
                            },
                          ),

                          // StreamBuilder<Duration>(
                          //   stream: player.positionStream,
                          //   builder: (context, snapshot) => SizedBox(
                          //     height: 100.0,
                          //     child: Column(
                          //       children: [
                          //         Text('${snapshot.data?.toString()}',
                          //             style: const TextStyle(
                          //                 fontFamily: 'Fixed',
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 24.0)),
                          //         Slider(
                          //           divisions: divisions,
                          //           min: min,
                          //           max: max,
                          //           value: snapshot.data ?? value,
                          //           onChanged: onChanged,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ),
                      );
                    },
                  )
                : const Text('no data');
          },
        ),
      ],
    );
  }
}
