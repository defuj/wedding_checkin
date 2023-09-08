import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MemberModel {
  @JsonKey(name: 'id')
  final String? memberID;
  @JsonKey(name: 'id_reservasi')
  final String? reservationID;
  @JsonKey(name: 'panggilan')
  final String? memberNickname;
  @JsonKey(name: 'nama')
  final String? memberName;

  MemberModel({
    this.memberID,
    this.reservationID,
    this.memberNickname,
    this.memberName,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      memberID: json['id'],
      reservationID: json['id_reservasi'],
      memberNickname: json['panggilan'],
      memberName: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': memberID,
      'id_reservasi': reservationID,
      'panggilan': memberNickname,
      'nama': memberName,
    };
  }
}
