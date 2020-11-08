import 'package:cupizz_app/src/packages/object_mapper/object_mapper.dart';
import 'package:cupizz_app/src/models/index.dart';
import 'package:flutter_test/flutter_test.dart';

final Map<String, dynamic> json = {
  "id": "0297e451-e1d0-4cb6-b4f4-26aa78d9e20e",
  "data": {
    "nickName": "Aylin",
    "avatar": {
      "id": "ckh6dj70c2390ayqsc22q0c9c",
      "type": "image",
      "url": "https://s3.amazonaws.com/uifaces/faces/twitter/her_ruu/128.jpg",
      "thumbnail":
          "https://s3.amazonaws.com/uifaces/faces/twitter/her_ruu/128.jpg"
    },
    "age": 39,
    "birthday": "1981-07-13T19:26:53.313Z",
    "introduction": "Quia deleniti neque occaecati.",
    "gender": "male",
    "hobbies": [
      {"id": "ckh6dj2ik00179mqs4kx5g560", "value": "Mua sắm"},
      {
        "id": "ckh6dj2jr00929mqsf6150qrb",
        "value": "Đọc sách, báo, tiểu thuyết"
      },
      {"id": "ckh6dj2jr00939mqsdvh7s92r", "value": "Vẽ tranh, Điêu khắc"},
      {
        "id": "ckh6dj2jy01089mqstlhrd2uu",
        "value": "Cho ăn và quan sát các loài chim địa phương"
      },
      {"id": "ckh6dj2kg01409mqs98yyevm3", "value": "Sưu tầm"}
    ],
    "phoneNumber": "466-370-7134 x205",
    "job": "Customer Communications Engineer",
    "height": 183,
    "minAgePrefer": 51,
    "maxAgePrefer": 67,
    "genderPrefer": ["male", "other"],
    "distancePrefer": 322,
    "friendType": {"status": "me"},
    "onlineStatus": "offline",
    "lastOnline": "2020-11-07T16:34:53.931Z",
    "settings": {"allowMatching": true, "isPrivate": false, "showActive": false}
  }
};

void main() {
  setUp(objectMapping);

  group('Test User Model', () {
    test("Test from json", () {
      var mapper = Mapper.fromJson(json);
      final info = mapper.toObject<User>();

      expect(info.id, json['id']);
      expect(info.nickName, json['data']['nickName']);
      expect(info.age, json['data']['age']);
      expect(info.introduction, json['data']['introduction']);
      expect(info.gender.rawValue, json['data']['gender']);
      expect(info.hobbies.map((e) => e.toJson()).toList(),
          json['data']['hobbies']);
      expect(info.phoneNumber, json['data']['phoneNumber']);
      expect(info.job, json['data']['job']);
      expect(info.height, json['data']['height']);
      expect(info.avatar.toJson(), json['data']['avatar']);
      expect(info.onlineStatus.rawValue, json['data']['onlineStatus']);
      expect(info.lastOnline, DateTime.tryParse(json['data']['lastOnline']));

      expect(info.birthday, DateTime.tryParse(json['data']['birthday']));
      expect(info.minAgePrefer, json['data']['minAgePrefer']);
      expect(info.maxAgePrefer, json['data']['maxAgePrefer']);
      expect(info.distancePrefer, json['data']['distancePrefer']);
      expect(info.genderPrefer.map((e) => e.rawValue).toList(),
          json['data']['genderPrefer']);
      expect(info.friendType.rawValue, json['data']['friendType']['status']);
      expect(info.allowMatching, json['data']['settings']['allowMatching']);
      expect(info.isPrivate, json['data']['settings']['isPrivate']);
      expect(info.showActive, json['data']['settings']['showActive']);
    });

    test('Test to json', () {
      var mapper = Mapper.fromJson(json);
      final info = mapper.toObject<User>();
      final currentJson = info.toJson();

      expect(currentJson, json);
    });
  });
}