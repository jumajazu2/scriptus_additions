import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scriptus/services/meeting_service.dart';

class LoadMeetingsButton extends ConsumerWidget {
  const LoadMeetingsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingsAsyncValue = ref.watch(meetingsProvider);

    return ElevatedButton(
      onPressed: meetingsAsyncValue is AsyncLoading
          ? null
          : () {
              print('test');
              final _ = ref.refresh(meetingsProvider);
            },
      child: meetingsAsyncValue.when(
        data: (meetings) => Text('Load Meetings (${meetings.length})'),
        error: (Object error, StackTrace stackTrace) {
          return const Text('Error Loading Meetings');
        },
        loading: () {
          return const CircularProgressIndicator();
        },

        // loading: (_) => const CircularProgressIndicator(),
        // error: (_, __, ___) => const Text('Load Meetings'),
      ),
    );
  }
}
