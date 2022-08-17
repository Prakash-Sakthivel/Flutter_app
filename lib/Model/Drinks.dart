import 'dart:convert';

List<Drinks> drinksModelFromJson(String str) =>
    List<Drinks>.from(json.decode(str).map((x) => Drinks.fromJson(x)));

String drinksModelToJson(List<Drinks> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Drinks {
  Drinks({
    required this.id,
    required this.name,
    required this.category,
  });

  int id;
  String name;
  String category;

  factory Drinks.fromJson(Map<String, dynamic> json) => Drinks(
    id: json["idDrink"],
    name: json["strDrink"],
    category: json["strCategory"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category": category,
  };
}