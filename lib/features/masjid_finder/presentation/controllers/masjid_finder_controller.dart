import 'package:get/get.dart';

import '../../../../core/services/location_service.dart';
import '../../data/repositories/masjid_repository.dart';
import '../../domain/entities/masjid.dart';

enum MasjidView { list, map }

class MasjidFinderController extends GetxController {
  MasjidFinderController(this._repo, this._location);
  final MasjidRepository _repo;
  final LocationService _location;

  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();
  final RxList<Masjid> masjids = <Masjid>[].obs;
  final Rxn<({double lat, double lon})> origin =
      Rxn<({double lat, double lon})>();
  final Rx<MasjidView> view = MasjidView.list.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool forceRefresh = false}) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      var lat = origin.value?.lat;
      var lon = origin.value?.lon;
      if (lat == null || lon == null) {
        final cached = _location.loadCachedLocation();
        if (cached != null) {
          lat = cached.lat;
          lon = cached.lon;
        }
      }
      try {
        final pos = await _location.requestCurrentLocation();
        lat = pos.latitude;
        lon = pos.longitude;
        await _location.cacheLocation(pos.latitude, pos.longitude);
      } on LocationException catch (e) {
        if (lat == null || lon == null) {
          errorMessage.value = e.message;
          isLoading.value = false;
          return;
        }
      }

      origin.value = (lat: lat, lon: lon);
      masjids.value = await _repo.findNearby(
        lat: lat,
        lon: lon,
        forceRefresh: forceRefresh,
      );
    } catch (e) {
      errorMessage.value = 'Failed to fetch nearby mosques: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void toggleView() {
    view.value = view.value == MasjidView.list
        ? MasjidView.map
        : MasjidView.list;
  }
}
