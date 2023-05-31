// To parse this JSON data, do
//
//     final categoriesAll = categoriesAllFromJson(jsonString);

import 'dart:convert';

CategoriesAll categoriesAllFromJson(String str) =>
    CategoriesAll.fromJson(json.decode(str));

String categoriesAllToJson(CategoriesAll data) => json.encode(data.toJson());

class CategoriesAll {
  List<Item>? items;
  String? token;

  CategoriesAll({
    this.items,
    this.token,
  });

  factory CategoriesAll.fromJson(Map<String, dynamic> json) => CategoriesAll(
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        token: json["token"],
      );

  get categories => null;

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "token": token,
      };
}

class Item {
  String? itemId;
  String? amphoe;
  String? district;
  String? email;
  Features? features;
  List<String>? img;
  double? lat;
  double? lng;
  double? price;
  String? province;
  String? zipcode;

  Item({
    this.itemId,
    this.amphoe,
    this.district,
    this.email,
    this.features,
    this.img,
    this.lat,
    this.lng,
    this.price,
    this.province,
    this.zipcode,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemId: json["item_id"],
        amphoe: json["amphoe"],
        district: json["district"],
        email: json["email"],
        features: json["features"] == null
            ? null
            : Features.fromJson(json["features"]),
        img: json["img"] == null
            ? []
            : List<String>.from(json["img"]!.map((x) => x)),
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
        price: json["price"] is int
            ? (json["price"] as int).toDouble()
            : json["price"],
        province: json["province"],
        zipcode: json["zipcode"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "amphoe": amphoe,
        "district": district,
        "email": email,
        "features": features?.toJson(),
        "img": img == null ? [] : List<dynamic>.from(img!.map((x) => x)),
        "lat": lat,
        "lng": lng,
        "price": price,
        "province": province,
        "zipcode": zipcode,
      };
}

class Features {
  String? type;
  double? area;
  int? bedroom;
  int? bathroom;
  int? living;
  int? kitchen;
  int? dining;
  int? parking;

  Features({
    this.type,
    this.area,
    this.bedroom,
    this.bathroom,
    this.living,
    this.kitchen,
    this.dining,
    this.parking,
  });

  factory Features.fromJson(Map<String, dynamic> json) => Features(
        type: json["type"],
        area: json["area"] is int
            ? (json["area"] as int).toDouble()
            : json["area"],
        bedroom: json["bedroom"],
        bathroom: json["bathroom"],
        living: json["living"],
        kitchen: json["kitchen"],
        dining: json["dining"],
        parking: json["parking"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "area": area,
        "bedroom": bedroom,
        "bathroom": bathroom,
        "living": living,
        "kitchen": kitchen,
        "dining": dining,
        "parking": parking,
      };
}
