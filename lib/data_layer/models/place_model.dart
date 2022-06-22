/// PlacesID : "1"
/// Lat : "30.0459"
/// Longt : "31.2243"
/// PlaceName : "Cairo Tower"
/// description : "Cairo Tower the best tower inEgypt"
/// Photo : "https://sae-marketing.com/mlbet/photo/-152879.png"

class PlaceModel {
  PlaceModel({
    String? placesID,
    String? lat,
    String? longt,
    String? placeName,
    String? description,
    String? photo,
  }) {
    _placesID = placesID;
    _lat = lat;
    _longt = longt;
    _placeName = placeName;
    _description = description;
    _photo = photo;
  }

  PlaceModel.fromJson(dynamic json) {
    _placesID = json['PlacesID'];
    _lat = json['Lat'];
    _longt = json['Longt'];
    _placeName = json['PlaceName'];
    _description = json['description'];
    _photo = json['Photo'];
  }
  String? _placesID;
  String? _lat;
  String? _longt;
  String? _placeName;
  String? _description;
  String? _photo;

  String? get placesID => _placesID;
  String? get lat => _lat;
  String? get longt => _longt;
  String? get placeName => _placeName;
  String? get description => _description;
  String? get photo => _photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PlacesID'] = _placesID;
    map['Lat'] = _lat;
    map['Longt'] = _longt;
    map['PlaceName'] = _placeName;
    map['description'] = _description;
    map['Photo'] = _photo;
    return map;
  }
}
