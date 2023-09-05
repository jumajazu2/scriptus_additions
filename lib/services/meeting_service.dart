import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/models/meeting.dart';
import 'package:scriptus/repositories/meetings_repo.dart';

final meetingsProvider = FutureProvider<List<Meeting>>((ref) async {
  print('meetingsProvider');
  final service = ref.watch(meetingServiceProvider);
  return service.getMeetings();
});

final meetingServiceProvider = Provider<MeetingService>((ref) {
  final repository = ref.watch(meetingRepositoryProvider);
  return MeetingService(repository);
});

class MeetingService {
  final MeetingRepository repository;

  MeetingService(this.repository);

  Future<List<Meeting>> getMeetings() async {
    print('getMeetings');
    // Fetch the meetings from the repository
    List<Meeting> meetings = await repository.fetchMeetings();

    // TODO: Apply any necessary business logic

    return meetings;
  }
}
