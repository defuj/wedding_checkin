import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:wedding/repositories.dart';

class SplashViewModel extends ViewModel {
  void checkPermission() async {
    try {
      var result = await [
        Permission.camera,
        Permission.phone,
        Permission.photos,
        Permission.storage,
        Permission.microphone,
        Permission.videos,
      ].request();

      Future.delayed(const Duration(seconds: 2), () {
        if (result[Permission.camera] == PermissionStatus.granted) {
          Get.offAllNamed('/scan');
        } else {
          checkPermission();
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void init() {
    checkPermission();
  }

  @override
  void onDependenciesChange() {}

  @override
  void onBuild() {}

  @override
  void onMount() {}

  @override
  void onUnmount() {}

  @override
  void onResume() {}

  @override
  void onPause() {}

  @override
  void onInactive() {}

  @override
  void onDetach() {}
}
