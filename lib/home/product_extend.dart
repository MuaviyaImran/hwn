// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hwn_mart/Provider/GetAllProducts.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/insert_data.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ProductExtendScreen extends StatefulWidget {
  final storeId, prodId, title, price, image, likes, views;
  final color,
      size,
      availab,
      vendor,
      sku,
      category,
      other,
      desc,
      deliveryChagres,
      contactNum,
      product_url;
  ProductExtendScreen(
      this.storeId,
      this.prodId,
      this.title,
      this.likes,
      this.views,
      this.price,
      this.image,
      this.color,
      this.size,
      this.availab,
      this.vendor,
      this.sku,
      this.category,
      this.other,
      this.desc,
      this.deliveryChagres,
      this.contactNum,
      this.product_url);
  @override
  _ProductExtendScreenState createState() => _ProductExtendScreenState();
}

class _ProductExtendScreenState extends State<ProductExtendScreen> {
  bool favourit = false;
  int size;
  int liked = 0;
  //List<RatingModel> productReview = [];
  List<ProductImageModel> productImages = [];
  List<String> prodImages = [];
  String loggedInUserID;

  void _showErrorDialogue(String msg) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Login Required",
                textAlign: TextAlign.center,
              ),
              content: Text(msg),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/account', (Route<dynamic> route) => false);
                  },
                )
              ],
            ));
  }

  Future<bool> _getPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedInUserID = prefs.getString("userID");
  }

  launchWhatsApp() async {
    final link = WhatsAppUnilink(
      phoneNumber: widget.contactNum,
      text: "Hey!",
    );
    await launch('$link');
  }

  List prodImage;
  Future<List<ProductImageModel>> _fetchProdImage() async {
    var response = await http.post(Uri.parse(productImageUrl), body: {
      'id': widget.prodId,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<ProductImageModel> listOfUsers =
          items.map<ProductImageModel>((json) {
        return ProductImageModel.fromJson(json);
      }).toList();
      size = listOfUsers.length;
      if (mounted) {
        setState(() {
          productImages = listOfUsers;
        });
      }
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  // Future<List<RatingModel>> _fetchReview() async {
  //   var response = await http.post(Uri.parse(fetchreviewUrl), body: {
  //     "id": widget.prodId,
  //   });
  //   if (response.statusCode == 200) {
  //     final items = json.decode(response.body).cast<Map<String, dynamic>>();
  //     List<RatingModel> listOfUsers = items.map<RatingModel>((json) {
  //       return RatingModel.fromJson(json);
  //     }).toList();
  //     if (mounted) {
  //       setState(() {
  //         productReview = listOfUsers;
  //       });
  //     }
  //     print(productReview);
  //     return listOfUsers;
  //   } else {
  //     throw Exception('Failed to load internet');
  //   }
  // }

  // List newColor = [], newSize = [];
  // makeList() async {
  //   print(widget.color);
  //   List newColorList = widget.color
  //       .split('،')
  //       .toString()
  //       .split(',')
  //       .map((String text) =>
  //           text.toString().replaceFirst("[", "").replaceAll("]", ""))
  //       .toList();

  //   List newSizeList = widget.size
  //       .split('،')
  //       .toString()
  //       .split(',')
  //       .map((String text) =>
  //           text.toString().replaceFirst("[", "").replaceAll("]", ""))
  //       .toList();
  //   if (mounted) {
  //     setState(() {
  //       newColor = newColorList;
  //       newSize = newSizeList;
  //     });
  //   }
  //   print(newColor);
  // }

  saveViews() async {
    final response = await http.post(Uri.parse(deleteAddressUrl), body: {
      "id": widget.prodId,
      "type": 'view',
    });
    if (response.statusCode == 200) {}
  }

  @override
  void initState() {
    super.initState();
    _fetchProdImage();
    _getPreference();
    //makeList();
    //_fetchReview();

    var allProducts = context.read<allProductProvider>().allProducts;
    getProductsOfCategory(widget.category, allProducts);
    saveViews();
  }

  List<ProductModel> allProductsOfRelevent = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProductExtendScreen(
                widget.storeId,
                widget.prodId,
                widget.title,
                widget.likes,
                widget.views,
                widget.price,
                widget.image,
                widget.color,
                widget.size,
                widget.availab,
                widget.vendor,
                widget.sku,
                widget.category,
                widget.other,
                widget.desc,
                widget.deliveryChagres,
                widget.contactNum,
                widget.product_url)));
  }

  getProductsOfCategory(catName, allProducts) async {
    for (int i = 0; i < allProducts.length; i++) {
      if (allProducts[i].category.toLowerCase() ==
          catName.toString().toLowerCase()) {
        allProductsOfRelevent.add(allProducts[i]);
        allProductsOfRelevent.shuffle();
      }
    }
    int b = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OtherTopBar().getAppBar("Product Details", context),
      body: SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              productImages.length == 0
                                  ? Container(
                                      // height: 220,
                                      alignment: Alignment.center,
                                      // color: primary,
                                      child: CircularProgressIndicator(),
                                      //  GestureDetector(
                                      //   onTap: () {
                                      //     imagePopup("$value/${widget.image}");
                                      //   },
                                      //   child:
                                      //       ImageCard("$value/${widget.image}"),
                                      // ),
                                    )
                                  : CarouselSlider(
                                      items: productImages
                                          .map(
                                            (item) => Builder(
                                              builder: (context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    print(
                                                        "$value/${item.image}");
                                                    imagePopup(
                                                        "$value/${item.image}");
                                                  },
                                                  child: ImageCard(
                                                      "$value/${item.image}"),
                                                );
                                              },
                                            ),
                                          )
                                          .toList(),
                                      options: CarouselOptions(
                                        // height: 230.0,
                                        enableInfiniteScroll: false,
                                        reverse: false,
                                        autoPlay: false,
                                        viewportFraction: 0.77,
                                        enlargeCenterPage: true,
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        favourit
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 40,
                                        color: primary,
                                      ),
                                      onPressed: () async {
                                        if (favourit) {
                                          myToast("Already added to wishlist");
                                        } else {
                                          http.Response imageResponse =
                                              await http.get(
                                            Uri.parse(
                                              "$value/${widget.image}",
                                            ),
                                          );
                                          var image = base64
                                              .encode(imageResponse.bodyBytes);
                                          wishList(
                                              widget.prodId,
                                              widget.title,
                                              image,
                                              widget.price,
                                              DateTime.now());
                                          setState(() {
                                            favourit = true;
                                            liked = 1;
                                          });
                                        }
                                      },
                                    ),
                                    Text(
                                      widget.likes == null || widget.likes == ''
                                          ? (0 + liked)
                                          : "${int.parse(widget.likes) + liked}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.title == null || widget.title == ''
                          ? ""
                          : "${widget.title}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 20,
                          color: green8,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.views}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: green8,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rs.${double.parse(widget.price).toStringAsFixed(2)}",
                          style: TextStyle(
                            color: primary,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Image.asset(
                                "assets/images/share.png",
                              ),
                              onPressed: () {
                                print("shared Clicked");
                                FlutterShare.share(
                                    linkUrl: widget.product_url,
                                    title: "ProductUrl");
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                if (loggedInUserID != null) {
                                  launchWhatsApp();
                                } else {
                                  var error_message = "Please Login First";
                                  _showErrorDialogue(error_message);
                                }
                                print("Whatsapp Clicked");
                              },
                              icon: Image.asset(
                                "assets/images/whatsapp.png",
                              ),
                            ),
                          ],
                        )

                        // ElevatedButton(
                        //   onPressed: () {
                        //     //  cart(widget.id, widget.quantity, color, size)();
                        //     shareModalBottomSheet(context);
                        //   },
                        //   child: Text(
                        //     "Add to cart",
                        //     style: TextStyle(
                        //       color: white,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFFeaeaea),
                  child: Column(
                    children: [
                      Row(children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Description",
                            softWrap: true,
                            style: TextStyle(fontSize: 20, color: primary),
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "${widget.desc}",
                  softWrap: true,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              // Container(
              //   child: DefaultTabController(
              //     length: 1,
              //     initialIndex: 0,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: <Widget>[
              //         Container(
              //           color: Color(0xFFeaeaea),
              //           child: TabBar(
              //             // isScrollable: true,
              //             labelColor: primary,
              //             indicatorColor: transparent,
              //             unselectedLabelColor: black.withOpacity(0.7),
              //             tabs: [
              //               Tab(text: 'Description'),
              //               // Tab(text: 'Details'),
              //               // Tab(text: 'Reviews'),
              //             ],
              //           ),
              //         ),
              //         Container(
              //           // height: 150,
              //           child: TabBarView(
              //             children: <Widget>[
              //               Container(
              //                 child: Text(
              //                   "$widget.desc",
              //                   softWrap: true,
              //                   style: TextStyle(fontSize: 16),
              //                 ),
              //               ),
              //               // DescriptionScreen(
              //               //     widget.desc, widget.deliveryChagres),
              //               // DetailScreen(
              //               //     widget.availab,
              //               //     widget.price,
              //               //     widget.sku,
              //               //     widget.color,
              //               //     widget.size,
              //               //     widget.vendor,
              //               //     widget.category,
              //               //     widget.other),
              //               // ReviewScreen(productReview),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Relevant Product",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 00.0),
                  child: allProductsOfRelevent.isEmpty
                      ? CircularProgressIndicator()
                      : StaggeredGridView.countBuilder(
                          padding: const EdgeInsets.all(2.0),
                          itemCount: allProductsOfRelevent.length,
                          crossAxisCount: 2,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductExtendScreen(
                                            allProductsOfRelevent[index].vendor,
                                            allProductsOfRelevent[index].id,
                                            allProductsOfRelevent[index].title,
                                            allProductsOfRelevent[index].likes,
                                            allProductsOfRelevent[index].views,
                                            allProductsOfRelevent[index].price,
                                            allProductsOfRelevent[index].image,
                                            allProductsOfRelevent[index].color,
                                            allProductsOfRelevent[index].size,
                                            allProductsOfRelevent[index]
                                                .availab,
                                            allProductsOfRelevent[index].vendor,
                                            allProductsOfRelevent[index].sku,
                                            allProductsOfRelevent[index]
                                                .category,
                                            allProductsOfRelevent[index].other,
                                            allProductsOfRelevent[index].desc,
                                            allProductsOfRelevent[index]
                                                .deliveryChagres,
                                            allProductsOfRelevent[index]
                                                .contact_number,
                                            allProductsOfRelevent[index]
                                                .product_url,
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
                                        "$value/${allProductsOfRelevent[index].image}"),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "${allProductsOfRelevent[index].title}",
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
                                          "Rs.${double.parse(allProductsOfRelevent[index].price).toStringAsFixed(2)}",
                                          style: TextStyle(
                                              color: red, fontSize: 12),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            http.Response imageResponse =
                                                await http.get(
                                              Uri.parse(
                                                "$value/${allProductsOfRelevent[index].image}",
                                              ),
                                            );
                                            var image = base64.encode(
                                                imageResponse.bodyBytes);
                                            wishList(
                                                allProductsOfRelevent[index].id,
                                                allProductsOfRelevent[index]
                                                    .title,
                                                image,
                                                allProductsOfRelevent[index]
                                                    .price,
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
                        )),
            ],
          ),
        ),
      ),
    );
  }

//   int quantity = 001;
//   double rating = 0;
//   String _mySelection, _sizeSelection;
//   void shareModalBottomSheet(context) {
//     showModalBottomSheet(
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(5.0))),
//       // backgroundColor: Colors.black,
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 0),
//         child: Container(
//           height: 320,
//           child: StatefulBuilder(
//               builder: (BuildContext context, StateSetter setState) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Center(
//                   child: Icon(
//                     Icons.linear_scale,
//                     size: 26,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Color",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 14.0),
//                         child: DropdownButton<String>(
//                             isDense: true,
//                             hint: Text(
//                               "Select color",
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             value: _mySelection,
//                             onChanged: (String newValue) {
//                               setState(() {
//                                 _mySelection = newValue;
//                               });
//                               print(_mySelection);
//                             },
//                             items: newColor
//                                 .map((c) => DropdownMenuItem<String>(
//                                       value: c,
//                                       child: Text(
//                                         c,
//                                         style: TextStyle(fontSize: 15),
//                                       ),
//                                     ))
//                                 .toList()),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
// // Size
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Size",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 14.0),
//                         child: DropdownButton<String>(
//                             isDense: true,
//                             hint: Text(
//                               "Select Size",
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             value: _sizeSelection,
//                             onChanged: (String newValue) {
//                               setState(() {
//                                 _sizeSelection = newValue;
//                               });
//                               print(_sizeSelection);
//                             },
//                             items: newSize
//                                 .map((s) => DropdownMenuItem<String>(
//                                       value: s,
//                                       child: Text(
//                                         s,
//                                         style: TextStyle(fontSize: 15),
//                                       ),
//                                     ))
//                                 .toList()),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 // Quantity
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Quantity",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Row(
//                         children: <Widget>[
//                           QuantityButton("-", () {
//                             setState(() {
//                               if (quantity != 1) {
//                                 quantity--;
//                               }
//                             });
//                           }),
//                           RawMaterialButton(
//                             onPressed: null,
//                             constraints:
//                                 BoxConstraints.tightFor(width: 48, height: 24),
//                             fillColor: Colors.grey[300],
//                             child: Text(
//                               quantity.toString(),
//                               style: TextStyle(
//                                   fontSize: 18, color: Colors.grey[600]),
//                             ),
//                           ),
//                           QuantityButton("+", () {
//                             setState(() {
//                               quantity++;
//                             });
//                           }),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 14.0, top: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_mySelection == null) {
//                             myToast("Please select a color..");
//                           } else if (_sizeSelection == null) {
//                             myToast("Please select a size..");
//                           } else {
//                             cart(
//                               widget.prodId,
//                               quantity,
//                               _mySelection,
//                               _sizeSelection,
//                             );
//                             Navigator.pop(context);
//                           }
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 20.0),
//                           child: Text(
//                             "Continue",
//                             style: TextStyle(
//                               color: white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 //  SignUpButton(() {}, "Continue"),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }

  imagePopup(image) {
    showGeneralDialog(
        // barrierColor: Colors.black.withOpacity(0.8),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                backgroundColor: black,
                contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                content: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Zoom(
                      enableScroll: false,
                      initZoom: 0,
                      maxZoomWidth: 1800,
                      maxZoomHeight: 1800,
                      backgroundColor: white,
                      child: WithoutCacheImage(
                        "$image",
                      ),
                    ) //Container()
                    // PinchZoomImage(
                    //   image: WithoutCacheImage(
                    //     "$image",
                    //   ),
                    //   zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                    //   hideStatusBarWhileZooming: false,
                    //   onZoomStart: () {
                    //     print('Zoom started');
                    //   },
                    //   onZoomEnd: () {
                    //     print('Zoom finished');
                    //   },
                    // ),
                    ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return;
        });
  }
}

class ImageCard extends StatelessWidget {
  final image;
  ImageCard(this.image);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     fit: BoxFit.cover,
          //     image: NetworkImage(
          //       image,
          //     ),
          //   ),
          // ),
          child: WithoutCacheImage(image),
        ),
      ),
    );
  }
}
