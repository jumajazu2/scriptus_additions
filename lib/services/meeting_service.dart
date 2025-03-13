import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/models/meeting.dart';
import 'package:scriptus/repositories/meetings_repo.dart';

final meetingsProvider = FutureProvider<List<Meeting>>((ref) async {
  print('meetingsProvider');
  final service = ref.watch(meetingServiceProvider);
  return service.getMeetings();
});

final meetingByDateProvider =
    FutureProvider.family<Meeting, DateTime>((ref, date) async {
  print('meetingByDateProvider');
  final service = ref.watch(meetingServiceProvider);
  return service.getMeetingByDate(date);
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

  Future<Meeting> getMeetingByDate(DateTime date) async {
    print('getMeetingByDate');
    // Fetch the meetings from the repository
    Meeting meeting = await repository.fetchMeetingByDate(date);

    // TODO: Apply any necessary business logic

    return meeting;
  }
}
