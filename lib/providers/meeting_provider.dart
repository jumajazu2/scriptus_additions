// import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scriptus/models/meeting.dart';

part 'meeting_provider.g.dart';

@riverpod
class SelectedMeeting extends _$SelectedMeeting {
  @override
  Meeting build() {
    return Meeting();
  }

  // Let's allow the UI to set meeting
  void setMeeting(Meeting meeting) {
    state = meeting;
  }
}


// final meetingProvider =
//     NotifierProvider.autoDispose<MeetingNotifier, Meeting>(() {
//   return MeetingNotifier();
// });

// class MeetingNotifier extends AutoDisposeNotifier<Meeting> {
//   @override
//   Meeting build() {
//     return Meeting();
//   }

//   void updateText(String newText) {
//     print('updateText: $newText');
//     state = state.updateText(newText);
//   }

// }