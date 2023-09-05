import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/models/meeting.dart';
import 'package:scriptus/services/meeting_service.dart';

Future<Meeting?> findMeetingWithDate(WidgetRef container, String date) async {
  // Read the meetings from the provider
  final meetingsAsyncValue = container.read(meetingsProvider);

  // Wait for the meetings to load
  final meetings = meetingsAsyncValue.maybeWhen(
    data: (meetings) => meetings,
    // loading: () => null,
    // error: (_, __, ___) => [],
    orElse: () {},
  );

  // If the meetings are still loading or an error occurred, return null
  if (meetings == null) {
    return null;
  }

  // Find the meeting with the given date
  for (var meeting in meetings) {
    if (meeting.meetingStart == date) {
      return meeting;
    }
  }

  // If no meeting with the given date was found, return null
  return null;
}
