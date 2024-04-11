import 'dart:typed_data';

class EatPlace {
  int? // auto increment로 생성할 예정이고 데이터가 입력될때는 값이 없기 때문에 ?(null safty)를 붙여줌.
      seq; // primary key로 사용하기 위한 키 값.
  String name;
  String phone;
  double lat;
  double lng;
  Uint8List image;
  String review;
  String initdate;

  EatPlace(
      {this.seq,
      required this.name,
      required this.phone,
      required this.lat,
      required this.lng,
      required this.image,
      required this.review,
      required this.initdate,
  });

  // 생성되면서 함수를 넣겠다. 주로 검색할때 사용.
  // 생성자를 생성하면서 메소드를 실행하기 위해서 factory를 사용.
  // 생성되면서 map형식으로 바꿔줌.
  factory EatPlace.fromMap(Map<String, dynamic> res) {
    return EatPlace(
        seq: res['seq'],
        name: res['name'],
        phone: res['phone'],
        lat: res['lat'],
        lng: res['lng'],
        image: res['image'],
        review: res['review'],
        initdate: res['inidate'],
    );
  }
}
