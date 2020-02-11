// To parse this JSON data, do
//
//     final placesModel = placesModelFromJson(jsonString);

import 'dart:convert';

List<PlacesModel> placesModelFromJson(String str) => List<PlacesModel>.from(json.decode(str).map((x) => PlacesModel.fromMap(x)));

String placesModelToJson(List<PlacesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class PlacesModel {
    final String zipCode;
    final String city;
    final String state;
    final String country;

    PlacesModel({
        this.zipCode,
        this.city,
        this.state,
        this.country,
    });

    PlacesModel copyWith({
        String zipCode,
        String city,
        String state,
        String country,
    }) => 
        PlacesModel(
            zipCode: zipCode ?? this.zipCode,
            city: city ?? this.city,
            state: state ?? this.state,
            country: country ?? this.country,
        );

    factory PlacesModel.fromMap(Map<String, dynamic> json) => PlacesModel(
        zipCode: json["zip_code"] == null ? null : json["zip_code"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        country: json["country"] == null ? null : json["country"],
    );

    Map<String, dynamic> toMap() => {
        "zip_code": zipCode == null ? null : zipCode,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "country": country == null ? null : country,
    };
}
