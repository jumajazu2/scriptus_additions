import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/models/place.dart';
import 'package:scriptus/repositories/places_repo.dart';

final placeRepositoryProvider =
    Provider<PlaceRepository>((ref) => PlaceRepository());

final placesProvider =
    StateNotifierProvider<PlacesNotifier, AsyncValue<List<Place>>>((ref) {
  final placeRepository = ref.watch(placeRepositoryProvider);
  return PlacesNotifier(placeRepository);
});

class PlacesNotifier extends StateNotifier<AsyncValue<List<Place>>> {
  final PlaceRepository _placeRepository;

  PlacesNotifier(this._placeRepository) : super(const AsyncValue.loading()) {
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    try {
      final places = await _placeRepository.getPlaces();
      state = AsyncValue.data(places);
    } catch (e) {
      var stackTrace = StackTrace.current;
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Similarly, you can define methods for creating, updating, and deleting places
}
