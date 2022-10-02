import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';

class allProductProvider with ChangeNotifier {
  List<ProductModel> allProducts = [];

  getProductsData(context) async {
    allProducts = await getVideosData(context);
    allProducts.shuffle();
    notifyListeners();
  }

  Future<List<ProductModel>> getVideosData(context) async {
    var response = await http.get(Uri.parse(getAllProductsinMart));
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<ProductModel> listOfProducts = items.map<ProductModel>((json) {
        return ProductModel.fromJson(json);
      }).toList();
      return listOfProducts;
    } else {
      throw Exception('Failed to load internet');
    }
  }
}
