import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:wedding/repositories.dart';

class CameraViewModel extends ViewModel {
  final List<CameraDescription> cameras;
  CameraViewModel(this.cameras);

  final box = GetStorage();
  bool _isCapturing = false;

  bool get isCapturing => _isCapturing;
  set isCapturing(bool value) {
    _isCapturing = value;
    notifyListeners();
  }

  String _capturing = 'Ambil foto';
  String get capturing => _capturing;
  set capturing(String value) {
    _capturing = value;
    notifyListeners();
  }

  CameraController? _controller;
  CameraController? get controller => _controller;
  set controller(CameraController? value) {
    _controller = value;
    notifyListeners();
  }

  XFile? _imagePath;
  XFile? get imagePath => _imagePath;
  set imagePath(XFile? value) {
    _imagePath = value;
    notifyListeners();
  }

  bool _isCameraReady = false;
  bool get isCameraReady => _isCameraReady;
  set isCameraReady(bool value) {
    _isCameraReady = value;
    notifyListeners();
  }

  void initializeCamera(CameraDescription cameraDescription) {
    controller = CameraController(cameraDescription, ResolutionPreset.max);
    initializeController();
  }

  void initializeController() async {
    if (!isCameraReady) {
      await controller?.initialize().then((value) {
        isCameraReady = true;
      });
      //   notifyListeners();
      //   if (imagePath == null) {
      //     takePicture();
      //   }
    }
  }

  void tryInitializeCamera() {
    try {
      initializeCamera(cameras[1]);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak ada kamera yang terdeteksi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<XFile?> takingPicture() async {
    if (!isCameraReady) {
      return null;
    }

    if (controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile? file = await controller?.takePicture();
      return file;
    } catch (e) {
      return null;
    }
  }

  void takePicture() async {
    if (imagePath != null) {
      imagePath = null;
      isCapturing = false;
    } else {
      if (isCameraReady) {
        isCapturing = true;
        // capturing = 'Mengambil foto dalam 3 detik';
        capturing = '5';
        // count down 3 seconds
        for (var i = 5; i > 0; i--) {
          capturing = '$i';
          await Future.delayed(const Duration(seconds: 1));
        }
        takingPicture().then((imageFile) async {
          imagePath = imageFile;
          log('Image Path: ${imagePath!.path}');
          capturing = 'Ambil foto';
          isCapturing = false;

          //   SweetDialog(
          //     barrierDismissible: false,
          //     context: context,
          //     dialogType: SweetDialogType.normal,
          //     title: 'Upload foto ini?',
          //     content:
          //         'Apakah Anda ingin mengupload foto ini? Jika tidak, foto akan dihapus dan Anda bisa mengambil ulang foto',
          //     confirmText: 'Ya, upload foto',
          //     cancelText: 'Tidak, ambil ulang',
          //     onConfirm: () async {
          //       await box.write('imagePath', imagePath!.path);
          //       Get.back();
          //     },
          //     onCancel: () {
          //       Get.back();
          //       imagePath = null;
          //       takePicture();
          //     },
          //   ).show();
          await box.write('imagePath', imagePath!.path);
          Get.back(result: imagePath!.path);
        });
      } else {
        tryInitializeCamera();
      }
    }
  }

  @override
  void init() {
    box.remove('imagePath');
    tryInitializeCamera();
  }

  @override
  void onDependenciesChange() {}

  @override
  void onBuild() {}

  @override
  void onMount() {}

  @override
  void onUnmount() {
    if (isCameraReady) {
      //   controller?.dispose();
      try {
        controller?.pausePreview();
      } catch (e) {
        log(e.toString());
      }
      isCameraReady = false;
    }
  }

  @override
  void onResume() {
    if (!isCameraReady) {
      tryInitializeCamera();
    }
  }

  @override
  void onPause() {
    if (isCameraReady) {
      //   controller?.dispose();
      try {
        controller?.pausePreview();
      } catch (e) {
        log(e.toString());
      }
      isCameraReady = false;
    }
  }

  @override
  void onInactive() {
    if (isCameraReady) {
      //   controller?.dispose();
      try {
        controller?.pausePreview();
      } catch (e) {
        log(e.toString());
      }
      isCameraReady = false;
    }
  }

  @override
  void onDetach() {}
}
