import 'dart:convert';
import 'dart:developer';
import 'package:wedding/repositories.dart';

class ApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.followRedirects = true;
    httpClient.baseUrl = ApiConfig.baseUrl;
    httpClient.defaultContentType = 'application/x-www-form-urlencoded';
    httpClient.timeout = const Duration(seconds: 60);
    httpClient.addRequestModifier<dynamic>((request) {
      final token =
          'Basic ${base64.encode(utf8.encode('${ApiConfig.username}:${ApiConfig.password}'))}';
      request.headers['Authorization'] = token;
      request.headers['Accept'] = '*/*';
      request.headers['Access-Control-Allow-Origin'] = '*';
      request.headers['Access-Control-Allow-Methods'] = '*';
      return request;
    });

    httpClient.maxAuthRetries = 3;
  }

  Future<String> uploadPresense({required formData}) async {
    try {
      final response = await post(
        ApiEndPoints.submitCheckin,
        formData,
      );
      if (response.status.hasError) {
        return Future.error(
            response.statusText ?? 'Terjadi kesalahan saat mengirim data');
      } else {
        if (response.body['status'] == false) {
          return Future.error(
              response.body['message'] ?? 'Gagal mengirim kehadiran');
        } else {
          return Future.value(response.body['message']);
        }
      }
    } catch (e) {
      return Future.error('Error: $e');
    }
  }

  Future<String> checkCheckin({required String code}) async {
    try {
      final data = FormData({'uuid': code});
      final response = await post(
        ApiEndPoints.checkCheckin,
        data,
      );
      if (response.status.hasError) {
        return Future.error(response.statusText ??
            'Tidak dapat mengambil data, silahkan coba lagi');
      } else {
        if (response.body['status'] == false) {
          return Future.error(
              response.body['message'] ?? 'Sudah melakukan reservasi');
        } else {
          return Future.value(response.body['message']);
        }
      }
    } catch (e) {
      return Future.error('Error: $e');
    }
  }

  Future<List<MemberModel>> getMemberByUUID({required String code}) async {
    try {
      final data = FormData({'uuid': code});
      final response = await post(
        ApiEndPoints.getMemberByUUID,
        data,
      );
      if (response.status.hasError) {
        return Future.error(response.statusText ??
            'Tidak dapat mengambil data, silahkan coba lagi');
      } else {
        if (response.body['status'] == false) {
          return Future.error(
              response.body['message'] ?? 'Belum melakukan reservasi');
        } else {
          final members = response.body['anggota'] as List;
          return members.map((e) => MemberModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      return Future.error('Error: $e');
    }
  }

  Future<String> sendComment({
    required String name,
    required String comment,
  }) async {
    final data = {
      'full_name': name,
      'comment': comment,
    };
    try {
      final response = await request(
        ApiEndPoints.submitComment,
        'POST',
        contentType: 'application/json',
        body: data,
      );
      log('result: ${response.body}');
      log('result: ${response.statusCode}');
      if (response.status.hasError) {
        return Future.error(
            response.statusText ?? 'Terjadi kesalahan saat mengirim komentar');
      } else {
        if (response.body['status'] == false) {
          return Future.error(response.body['message']);
        } else {
          return Future.value(response.body['message']);
        }
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<Map<String, dynamic>> checkPhoneNumber(
      {required String phoneNumber}) async {
    var phone = modifyPhoneNumber(phoneNumber);

    try {
      final data = FormData({'nomor_wa': phone});
      final response = await post(
        ApiEndPoints.checkWhatsApp,
        data,
      );
      log('result: ${response.body}');
      if (response.status.hasError) {
        return Future.error(response.statusText ??
            'Terjadi kesalahan saat memeriksa nomor telepon');
      } else {
        if (response.body['status'] == false) {
          return Future.error(response.body['message']);
        } else {
          var result = {
            'userName': response.body['nama'] ?? '',
            'reservasionID': response.body['id_reservasi'] ?? 0,
            'sessionID': response.body['id_sesi'] ?? 0,
            'invitationID': response.body['id_undangan'],
          };
          return Future.value(result);
        }
      }
    } catch (e) {
      return Future.error('Error: $e');
    }
  }

  Future<int> createReservasion({
    required String name,
    required String phoneNumber,
    required int id,
  }) async {
    var phone = modifyPhoneNumber(phoneNumber);
    final data = FormData({
      'nama': name,
      'nomor_wa': phone,
      'force': 0,
      'panggilan': '',
      'id_undangan': id,
    });
    log(phone);

    try {
      final response = await post(ApiEndPoints.submitReservasion, data);
      log('result: ${response.body}');
      if (response.status.hasError) {
        return Future.error(response.statusText ??
            'Terjadi kesalahan saat mengambil data sesi');
      } else {
        if (response.body['status'] == false) {
          return Future.error(
              response.body['message'] ?? 'Gagal membuat reservasi');
        } else {
          return Future.value(response.body['id_reservasi'] ?? 0);
        }
      }
    } catch (e) {
      return Future.error('Error: $e');
    }
  }

  Future<List<MemberModel>> getMember({required String reservasionID}) async {
    try {
      final response =
          await get(ApiEndPoints().getMember(reservasionID: reservasionID));
      if (response.status.hasError) {
        return Future.error(response.statusText ??
            'Terjadi kesalahan saat mengambil data menu');
      } else {
        if (response.body['status'] == false) {
          return Future.error(response.body['message'] ?? 'Tidak ada member');
        } else {
          final members = response.body['data'] as List;
          return members.map((e) => MemberModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      return Future.error('Error: $e');
    }
  }
}
