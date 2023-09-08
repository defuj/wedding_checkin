import 'package:wedding/repositories.dart';

class SuccessViewModel extends ViewModel {
  String _userName = 'John Doe';
  String get userName => _userName;
  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  @override
  void init() {
    try {
      userName = Get.arguments;
    } catch (e) {
      userName = 'John Doe';
    }

    Future.delayed(const Duration(seconds: 3), () {
      //   Get.offAllNamed('/scan');
      Get.back();
      Get.back();
      Get.back();
    });
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
