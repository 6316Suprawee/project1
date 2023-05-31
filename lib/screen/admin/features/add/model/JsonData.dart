class AddressData {
  String? district;
  String? amphoe;
  String? province;
  String? zipcode;

  AddressData({this.district, this.amphoe, this.province, this.zipcode});

  AddressData.fromJson(Map<String, dynamic> json) {
    district = json['district'];
    amphoe = json['amphoe'];
    province = json['province'];
    zipcode = json['zipcode']?.toString();
  }
  String? getDistrict() {
    return district;
  }

  String? getAmphoe() {
    return amphoe;
  }

  String? getProvince() {
    return province;
  }

  String? getZipcode() {
    return zipcode;
  }
}
