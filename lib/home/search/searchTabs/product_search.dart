import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hwn_mart/home/product_extend.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/insert_data.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:http/http.dart' as http;

class ProductSearch extends StatefulWidget {
  final List<SearchResultModel> productList;
  ProductSearch(this.productList);
  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  bool favourit = false;
  @override
  Widget build(BuildContext context) {
    var results = widget.productList
        .where((elem) => elem.type
            .toString()
            .toLowerCase()
            .contains('product'.toLowerCase()))
        .toList();
    return Scaffold(
      body: results.length == 0
          ? Center(
              child: Text("--No product found--"),
            )
          : StaggeredGridView.countBuilder(
              padding: const EdgeInsets.all(2.0),
              itemCount: widget.productList.length,
              crossAxisCount: 2,
              itemBuilder: (context, index) => widget.productList[index].type
                          .toString()
                          .toLowerCase() !=
                      'product'
                  ? Container()
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductExtendScreen(
                                      widget.productList[index].storeId,
                                      widget.productList[index].id,
                                      widget.productList[index].title,
                                      widget.productList[index].likes,
                                      widget.productList[index].views,
                                      widget.productList[index].price,
                                      widget.productList[index].image,
                                      widget.productList[index].color,
                                      widget.productList[index].size,
                                      widget.productList[index].availab,
                                      widget.productList[index].vendor,
                                      widget.productList[index].sku,
                                      widget.productList[index].category,
                                      widget.productList[index].other,
                                      widget.productList[index].desc,
                                      widget.productList[index].delivery,
                                      widget.productList[index].contact_number,
                                      widget.productList[index].product_url,
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
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 130,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      "$value/${widget.productList[index].image}",
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "",
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "${widget.productList[index].title}",
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
                                    "Rs.${double.parse(widget.productList[index].price).toStringAsFixed(2)}",
                                    style: TextStyle(color: red, fontSize: 12),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      http.Response imageResponse =
                                          await http.get(
                                        Uri.parse(
                                          "$value/${widget.productList[index].image}",
                                        ),
                                      );
                                      var image = base64
                                          .encode(imageResponse.bodyBytes);

                                      wishList(
                                          widget.productList[index].id,
                                          widget.productList[index].title,
                                          image,
                                          widget.productList[index].price,
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
            ),
    );
  }
}
