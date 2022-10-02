import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:hwn_mart/home/product_extend.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/insert_data.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductScreen extends StatefulWidget {
  final storeName, storeImg, storeId, address;
  ProductScreen(this.storeName, this.storeImg, this.storeId, this.address);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int size;
  bool favourit = false;
  Future<List<ProductModel>> _fetchcategory() async {
    var response = await http.post(Uri.parse(productUrl), body: {
      'id': widget.storeId,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<ProductModel> listOfUsers = items.map<ProductModel>((json) {
        return ProductModel.fromJson(json);
      }).toList();
      size = listOfUsers.length;
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProductScreen(widget.storeName,
                widget.storeImg, widget.storeId, widget.address)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OtherTopBar().getAppBar("${widget.storeName}", context),
      body: Stack(
        children: [
          Card(
            child: Hero(
              tag: '${widget.storeId}store',
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 160,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     fit: BoxFit.fill,
                //     image: NetworkImage(
                //       "$value/${widget.storeImg}",
                //     ),
                //   ),
                // ),
                child: Stack(
                  children: [
                    MyCacheImage("$value/${widget.storeImg}", double.infinity,
                        double.infinity),
                    Text(
                      "${widget.storeName}",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          color: white,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Arial'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: Padding(
              padding: const EdgeInsets.only(top: 165.0),
              child: FutureBuilder<List<ProductModel>>(
                future: _fetchcategory(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  snapshot.data.shuffle();
                  return size < 1
                      ? Center(
                          child: Text(
                            "${widget.address}\nPlease visit the store at given address above.",
                            textAlign: TextAlign.center,
                          ),
                        )
                      : StaggeredGridView.countBuilder(
                          padding: const EdgeInsets.all(2.0),
                          itemCount: snapshot.data.length,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductExtendScreen(
                                            widget.storeId,
                                            snapshot.data[index].id,
                                            snapshot.data[index].title,
                                            snapshot.data[index].likes,
                                            snapshot.data[index].views,
                                            snapshot.data[index].price,
                                            snapshot.data[index].image,
                                            snapshot.data[index].color,
                                            snapshot.data[index].size,
                                            snapshot.data[index].availab,
                                            snapshot.data[index].vendor,
                                            snapshot.data[index].sku,
                                            snapshot.data[index].category,
                                            snapshot.data[index].other,
                                            snapshot.data[index].desc,
                                            snapshot
                                                .data[index].deliveryChagres,
                                            snapshot.data[index].contact_number,
                                            snapshot.data[index].product_url,
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
                                    // Container(
                                    //   width: MediaQuery.of(context).size.width,
                                    //   height: 130,
                                    //   // decoration: BoxDecoration(
                                    //   //   image: DecorationImage(
                                    //   //     fit: BoxFit.fill,
                                    //   //     image: NetworkImage(
                                    //   //       "$value/${snapshot.data[index].image}",
                                    //   //     ),
                                    //   //   ),
                                    //   // ),
                                    //   child: CachedNetworkImage(imageUrl:  "$value/${snapshot.data[index].image}")
                                    //   //  MyCacheImage(
                                    //   //     "$value/${snapshot.data[index].image}",
                                    //   //     double.infinity,
                                    //   //     double.infinity),
                                    // ),
                                    WithoutCacheImage(
                                        "$value/${snapshot.data[index].image}"),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "${snapshot.data[index].title}",
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
                                          "Rs.${double.parse(snapshot.data[index].price).toStringAsFixed(2)}",
                                          style: TextStyle(
                                              color: red, fontSize: 12),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            http.Response imageResponse =
                                                await http.get(
                                              Uri.parse(
                                                "$value/${snapshot.data[index].image}",
                                              ),
                                            );
                                            var image = base64.encode(
                                                imageResponse.bodyBytes);

                                            wishList(
                                                snapshot.data[index].id,
                                                snapshot.data[index].title,
                                                image,
                                                snapshot.data[index].price,
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
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
