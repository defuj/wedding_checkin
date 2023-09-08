import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:code_scan/code_scan.dart';
import 'package:wedding/repositories.dart';

class ScanViewModel extends ViewModel {
  late SweetDialog loading;
  late ApiProvider apiProvider;

//   CameraController? _controller = CameraController(
//     const CameraDescription(
//       name: '0',
//       lensDirection: CameraLensDirection.front,
//       sensorOrientation: 0,
//     ),
//     ResolutionPreset.veryHigh,
//   );
//   CameraController? get controller => _controller;
//   set controller(CameraController? value) {
//     _controller = value;
//     notifyListeners();
//   }

//   CodeScannerCameraListener? _listener;
//   CodeScannerCameraListener? get listener => _listener;
//   set listener(CodeScannerCameraListener? value) {
//     _listener = value;
//     notifyListeners();
//   }

  late CodeScannerCameraListener listener;

  bool _isInitializeDone = false;
  bool get isInitializeDone => _isInitializeDone;
  set isInitializeDone(bool value) {
    _isInitializeDone = value;
    notifyListeners();
  }

  bool _isChecking = false;
  bool get isChecking => _isChecking;
  set isChecking(bool value) {
    _isChecking = value;
    notifyListeners();
  }

  void startCheckin(List<MemberModel> value, String code) async {
    controller.pausePreview();
    log('start checkin');
    await Get.toNamed(
      '/checkin',
      arguments: {
        'members': value,
        'uuid': code,
      },
    );

    // prepareCamera();
    log('resume preview');
    await controller.resumePreview().then((value) {
      log('resume preview done');

      isInitializeDone = false;
      listener.dispose();
      prepareCamera();
    });
  }

  void getMember(String code) async {
    await apiProvider.getMemberByUUID(code: code).then(
      (value) {
        loading.dismiss();
        isChecking = false;
        startCheckin(value, code);
      },
      onError: (e) {
        loading.dismiss();
        isChecking = false;
        SweetDialog(
          context: context,
          title: 'Oops',
          content: e.toString(),
          onConfirm: () {
            isChecking = false;
          },
          barrierDismissible: false,
        ).show();
      },
    );
  }

  void checkQR(String code) async {
    loading.show();
    await apiProvider.checkCheckin(code: code).then(
      (message) {
        getMember(code);
      },
      onError: (message) {
        loading.dismiss();
        isChecking = false;
        SweetDialog(
          context: context,
          title: 'Oops',
          content: message.toString(),
          onConfirm: () {
            isChecking = false;
          },
        ).show();
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
        });
      },
    );
  }

  CameraController controller = CameraController(
    const CameraDescription(
      name: '1',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 0,
    ),
    ResolutionPreset.ultraHigh,
  );

  void prepareCamera() async {
    try {
      controller = controller;
      controller.initialize().then((value) {
        log('camera initialized');
        isChecking = false;

        listener = CodeScannerCameraListener(
          controller,
          onScan: (code, details, listener) {
            log('Code: $code', name: 'onScan');
            if (!isChecking) {
              isChecking = true;
              checkQR(code!);
            }
          },
          formats: const [BarcodeFormat.qrCode],
          onError: (object, cameraListener) {
            log(object.toString());
          },
          onScanAll: (codes, controller) {
            log('Codes: ${codes.map((code) => code.rawValue)}',
                name: 'onScanAll');
          },
        );
        controller.addListener(() => listener);
        isInitializeDone = true;
      }, onError: (e) {
        log(e.toString());
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void init() {
    loading = SweetDialog(
      context: context,
      dialogType: SweetDialogType.loading,
      barrierDismissible: false,
    );
    apiProvider = getApiProvider;

    prepareCamera();
  }

  @override
  void onDependenciesChange() {
    log('onDependenciesChange');
  }

  @override
  void onBuild() {
    try {
      //   isInitializeDone = false;
      //   prepareCamera();
    } catch (e) {
      log(e.toString());
    }
    log('onBuild');
  }

  @override
  void onMount() {
    try {
      if (isInitializeDone) {
        controller.resumePreview();
      }
    } catch (e) {
      log(e.toString());
    }
    log('onMount');
  }

  @override
  void onUnmount() {
    try {
      isInitializeDone = false;
    } catch (e) {
      log(e.toString());
    }

    try {
      controller.dispose();
    } catch (e) {
      log(e.toString());
    }

    log('onUnmount');
  }

  @override
  void onResume() {
    try {
      if (isInitializeDone) {
        controller.resumePreview();
      }
    } catch (e) {
      log(e.toString());
    }
    log('onResume');
  }

  @override
  void onPause() {
    try {
      controller.pausePreview();
    } catch (e) {
      log(e.toString());
    }
    log('onPause');
  }

  @override
  void onInactive() {
    try {
      controller.pausePreview();
    } catch (e) {
      log(e.toString());
    }
    log('onInactive');
  }

  @override
  void onDetach() {
    try {
      controller.pausePreview();
    } catch (e) {
      log(e.toString());
    }
    log('onDetached');
  }
}
