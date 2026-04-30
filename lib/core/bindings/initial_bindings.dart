import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Register app-wide singletons here as features come online, e.g.:
    //   Get.put<LocationService>(LocationService(), permanent: true);
    //   Get.put<DbService>(DbService(), permanent: true);
  }
}
