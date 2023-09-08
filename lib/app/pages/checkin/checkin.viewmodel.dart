import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:uuid/uuid.dart';
import 'package:wedding/repositories.dart';

class CheckinViewModel extends ViewModel {
  late SweetDialog loading;
  late ApiProvider apiProvider;
  final box = GetStorage();

  String _uuid = '';
  String get uuid => _uuid;
  set uuid(String value) {
    _uuid = value;
    notifyListeners();
  }

  List<CameraDescription> _cameras =
      List<CameraDescription>.empty(growable: true);
  List<CameraDescription> get cameras => _cameras;
  set cameras(List<CameraDescription> value) {
    _cameras = value;
    notifyListeners();
  }

  List<MemberModel> _members = List<MemberModel>.empty(growable: true);
  List<MemberModel> get members => _members;
  set members(List<MemberModel> value) {
    _members = value;
    notifyListeners();
  }

  List<MemberModel> _memberAbsent = List<MemberModel>.empty(growable: true);
  List<MemberModel> get memberAbsent => _memberAbsent;
  set memberAbsent(List<MemberModel> value) {
    _memberAbsent = value;
    notifyListeners();
  }

  void deleteFromMember(MemberModel member) {
    members.removeWhere((element) => element.memberID == member.memberID);
    memberAbsent.add(member);
    notifyListeners();
  }

  void deleteFromAbsent(MemberModel member) {
    memberAbsent.removeWhere((element) => element.memberID == member.memberID);
    members.add(member);
    notifyListeners();
  }

  void memberNotFound() {
    SweetDialog(
      context: context,
      title: 'Tidak ditemukan',
      content: 'Tidak ada data anggota yang ditemukan',
      confirmText: 'Kembali',
      onConfirm: () {
        // Get.offAllNamed('/scan');
        Get.back(result: true);
      },
      barrierDismissible: false,
    ).show();
  }

  void startUpload(String imagePath) async {
    loading.show();
    final String randomName = const Uuid().v4();
    var path = XFile(imagePath).path;
    File file = File(path);

    var data = FormData({
      'uuid': uuid,
      'foto_selfie': MultipartFile(file, filename: '$randomName.jpg'),
    });
    var index = 0;
    for (var element in memberAbsent) {
      data.fields.add(MapEntry('anggota[$index]', element.memberID.toString()));
      index++;
    }

    await apiProvider.uploadPresense(formData: data).then(
      (value) {
        loading.dismiss();
        Get.toNamed('/success', arguments: 'Terimakasih');
      },
      onError: (message) {
        loading.dismiss();
        SweetDialog(
          context: context,
          title: 'Oops',
          dialogType: SweetDialogType.error,
          content: message.toString(),
          confirmText: 'Kembali',
          onConfirm: () {
            // Get.offAllNamed('/scan');
            Get.back(result: true);
          },
          barrierDismissible: false,
        ).show();
      },
    );
  }

  void savePresensi() async {
    if (members.isNotEmpty) {
      if (cameras.isNotEmpty) {
        await Get.to(CameraView(cameras: cameras));
        try {
          if (box.read('imagePath') != null) {
            log('Result: ${box.read('imagePath')}');
            startUpload(box.read('imagePath'));
          }
        } catch (e) {
          log('Error: $e', name: 'savePresensi');
        }
      } else {
        SweetDialog(
          context: context,
          title: 'Kamera tidak ditemukan',
          content: 'Tidak ada kamera yang ditemukan',
          confirmText: 'Kembali',
        ).show();
      }
    } else {
      SweetDialog(
        context: context,
        title: 'Tidak ada anggota',
        content:
            'Tidak ada anggota yang hadir, pastikan ada anggota yang hadir',
        confirmText: 'Tutup',
        cancelText: 'Scan ulang',
        onCancel: () {
          //   Get.offAllNamed('/scan');
          Get.back(result: true);
        },
      ).show();
    }
  }

  void getCameras() async {
    await availableCameras().then((value) {
      cameras = value;
    });
  }

  Future<bool> onBackPressed() async {
    SweetDialog(
      context: context,
      dialogType: SweetDialogType.warning,
      title: 'Kembali ke scan?',
      content: 'Apakah anda yakin ingin kembali ke scan?',
      confirmText: 'Iya',
      cancelText: 'Tidak',
      onConfirm: () {
        // Get.offAllNamed('/scan');
        Get.back(result: true);
      },
    ).show();

    return false;
  }

  @override
  void init() {
    loading = SweetDialog(
      context: context,
      dialogType: SweetDialogType.loading,
      barrierDismissible: false,
    );
    apiProvider = getApiProvider;

    try {
      members = Get.arguments['members'];
      uuid = Get.arguments['uuid'];

      Future.delayed(Duration.zero, () {
        getCameras();
      });
    } catch (e) {
      members = List<MemberModel>.empty(growable: true);
      Future.delayed(Duration.zero, () {
        memberNotFound();
      });
    }
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
