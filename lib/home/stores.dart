import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hwn_mart/Provider/GetAllProducts.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:hwn_mart/home/product_extend.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/insert_data.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StoresScreen extends StatefulWidget {
  final catName, catId;
  StoresScreen(this.catName, this.catId);
  @override
  _StoresScreenState createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  int size;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => StoresScreen(widget.catName, widget.catId)));
  }

  bool favourit = false;
  @override
  void initState() {
    var allProducts = context.read<allProductProvider>().allProducts;
    getProductsOfCategory(widget.catName, allProducts);
    // TODO: implement initState
    super.initState();
  }

  List<ProductModel> allProductsOfCat = [];
  getProductsOfCategory(catName, allProducts) async {
    for (int i = 0; i < allProducts.length; i++) {
      if (allProducts[i].category.toLowerCase() ==
          catName.toString().toLowerCase()) {
        allProductsOfCat.add(allProducts[i]);
        allProductsOfCat.shuffle();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: OtherTopBar().getAppBar("${widget.catName}", context),
        body: SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: Stack(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Text("Products of ${widget.catName}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: _onRefresh,
                    icon: Image.asset(
                      "assets/images/refresh-button.png",
                      height: 18,
                      width: 18,
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: allProductsOfCat.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : StaggeredGridView.countBuilder(
                          padding: const EdgeInsets.all(2.0),
                          itemCount: allProductsOfCat.length,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductExtendScreen(
                                            allProductsOfCat[index].id,
                                            allProductsOfCat[index].id,
                                            allProductsOfCat[index].title,
                                            allProductsOfCat[index].likes,
                                            allProductsOfCat[index].views,
                                            allProductsOfCat[index].price,
                                            allProductsOfCat[index].image,
                                            allProductsOfCat[index].color,
                                            allProductsOfCat[index].size,
                                            allProductsOfCat[index].availab,
                                            allProductsOfCat[index].vendor,
                                            allProductsOfCat[index].sku,
                                            allProductsOfCat[index].category,
                                            allProductsOfCat[index].other,
                                            allProductsOfCat[index].desc,
                                            allProductsOfCat[index]
                                                .deliveryChagres,
                                            allProductsOfCat[index]
                                                .contact_number,
                                            allProductsOfCat[index].product_url,
                                          )));
                            },
                            child: Card(
                              elevation: 0,
                              color: Color(0xFFeaeaea),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    WithoutCacheImage(
                                        "$value/${allProductsOfCat[index].image}"),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "${allProductsOfCat[index].title}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Rs.${double.parse(allProductsOfCat[index].price).toStringAsFixed(2)}",
                                          style: TextStyle(
                                              color: red, fontSize: 12),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            http.Response imageResponse =
                                                await http.get(
                                              Uri.parse(
                                                "$value/${allProductsOfCat[index].image}",
                                              ),
                                            );
                                            var image = base64.encode(
                                                imageResponse.bodyBytes);
                                            wishList(
                                                allProductsOfCat[index].id,
                                                allProductsOfCat[index].title,
                                                image,
                                                allProductsOfCat[index].price,
                                                DateTime.now());
                                          },
                                          child: Icon(
                                            favourit
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: red,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                        ))
            ],
          ),
        ));
  }
}
