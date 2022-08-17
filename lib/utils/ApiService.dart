import 'dart:developer';
import 'package:flutter_app/Model/Drinks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {

  static String baseUrl = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=marGarita";

  Future<List<Drinks>?> getUsers() async {
    try {
      var url = Uri.parse(baseUrl);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json_data = json.decode(response.body.toString());
        List<Drinks> _model = drinksModelFromJson(json_data['drinks']);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}