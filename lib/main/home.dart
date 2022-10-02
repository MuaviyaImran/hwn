import 'dart:async';
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hwn_mart/Provider/GetAllProducts.dart';
import 'package:hwn_mart/ads/ad_const.dart';
import 'package:hwn_mart/ads/ad_helper.dart';
import 'package:hwn_mart/bars/drawer.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:hwn_mart/home/product_extend.dart';
import 'package:hwn_mart/home/products.dart';
import 'package:after_layout/after_layout.dart';
import 'package:hwn_mart/home/stores.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/insert_data.dart';
import 'package:hwn_mart/widgets/internet_class.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/foundation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AfterLayoutMixin<HomeScreen> {
  int _current = 0;
  int size;
  var carouselList = [];
  var networkConnection = '';
  bool favourit = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _page = 1;
  final int _limit = 36;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List products = [];
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      // final res =
      //     await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));
      final Map<String, String> body = {
        'page': _page.toString(),
        'limit': _limit.toString(),
      };

      final response = await http.post(
          Uri.parse('https://hwnmart.com/app/all_product_pagi.php'),
          body: body,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          });
      setState(() {
        products = json.decode(response.body);
      });
      products.shuffle();
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        final Map<String, String> body = {
          'page': _page.toString(),
          'limit': _limit.toString(),
        };

        final response = await http.post(
            Uri.parse('https://hwnmart.com/app/all_product_pagi.php'),
            body: body,
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            });
        final List fetchedPosts = json.decode(response.body);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            products.addAll(fetchedPosts);
          });
          products.shuffle();
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  ScrollController _controller;

  Future<List<CarouselModel>> fetchData() async {
    var response = await http.post(Uri.parse(carouselUrl));
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<CarouselModel> listOfUsers = items.map<CarouselModel>((json) {
        return CarouselModel.fromJson(json);
      }).toList();
      if (mounted) {
        setState(() {
          carouselList = listOfUsers;
        });
      }

      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  Future<List<CarouselModel>> _fetchcategoryChunk() async {
    var response = await http.post(Uri.parse(categoryUrl), body: {
      "type": "some",
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<CarouselModel> listOfUsers = items.map<CarouselModel>((json) {
        return CarouselModel.fromJson(json);
      }).toList();

      var chunks = [];
      int chunkSize = 4;
      for (var i = 0; i < listOfUsers.length; i += chunkSize) {
        chunks.add(listOfUsers.sublist(
            i,
            i + chunkSize > listOfUsers.length
                ? listOfUsers.length
                : i + chunkSize));
      }
      size = listOfUsers.length;
      return chunks[0];
    } else {
      throw Exception('Failed to load internet');
    }
  }

  fetchPrefrence(bool isNetworkPresent) {
    if (isNetworkPresent) {
      setState(() {
        networkConnection = 'online';
      });
    } else {
      setState(() {
        networkConnection = 'offline';
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  void initState() {
    NetworkCheck networkCheck = new NetworkCheck();
    networkCheck.checkInternet(fetchPrefrence);
    fetchData();
    final data = Provider.of<allProductProvider>(context, listen: false);
    data.getProductsData(context);
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);

    super.initState();
  }

  void _onRefresh() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    //var products = context.read<allProductProvider>().allProducts;
    var _crossAxisSpacing = 1;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 4;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 160;
    var _aspectRatio = _width / cellHeight;
    return Scaffold(
      //items: allProducts //List with Provider
      appBar: TopBar().getAppBar(context),
      drawer: MyDrawer(),
      body: networkConnection == 'offline'
          ? Center(child: Text("--Please connect with internet--"))
          : SmartRefresher(
              enablePullDown: true,
              header: WaterDropHeader(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: black,
                          child: CarouselSlider(
                            items: carouselList
                                .map(
                                  (e) => Builder(
                                    builder: (context) {
                                      return InkWell(
                                        onTap: () {
                                          print(e.storeId);
                                          if (e.storeId == 0 ||
                                              e.storeId == "0" ||
                                              e.storeId == "" ||
                                              e.storeId == null) {
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductScreen(
                                                            e.storeTitle,
                                                            e.storeImage,
                                                            e.storeId,
                                                            e.address)));
                                          }
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  "$value/${e.image}"),
                                            ),
                                          ),
                                          child: MyCacheImage(
                                              "$value/${e.image}",
                                              double.infinity,
                                              double.infinity),
                                        ),
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                            options: CarouselOptions(
                              height: 200.0,
                              reverse: false,
                              autoPlay: true,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: carouselList.map((url) {
                            int index = carouselList.indexOf(url);
                            return Container(
                              width: 17.0,
                              height: 3.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 2.0),
                              color: _current == index ? black : Colors.grey,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              color: skin,
                              child: HomeShowBannerAd(adUnitId),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Categories"),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/allcategory");
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Show More",
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: red,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          size: 11, color: red)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: FutureBuilder<List<CarouselModel>>(
                        future: _fetchcategoryChunk(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          return Padding(
                            padding: EdgeInsets.only(top: 0),
                            // height: 480,
                            child: GridView(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _crossAxisCount,
                                childAspectRatio: _aspectRatio,
                              ),
                              physics: ScrollPhysics(),
                              children: snapshot.data
                                  .map(
                                    (cat) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 11),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StoresScreen(
                                                          cat.title, cat.id)));
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: primary, width: 2),
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      "$value/${cat.image}"),
                                                  // fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            // SizedBox(height: 5),
                                            AutoSizeText(
                                              "${cat.title}",
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(0),
                        child:
                            Text("All Products", textAlign: TextAlign.start)),
                    _isFirstLoadRunning
                        ? const Center(
                            child: const CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 00.0),
                            child: Column(
                              children: [
                                StaggeredGridView.countBuilder(
                                  controller: _controller,
                                  padding: const EdgeInsets.all(2.0),
                                  itemCount: products.length,
                                  crossAxisCount: 2,
                                  physics: ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductExtendScreen(
                                                    products[index]['vendore'],
                                                    products[index]['id'],
                                                    products[index]['title'],
                                                    products[index]['likes'],
                                                    products[index]['views'],
                                                    products[index]['price'],
                                                    products[index]['image'],
                                                    products[index]['colors'],
                                                    products[index]['sizes'],
                                                    products[index]
                                                        ['availability'],
                                                    products[index]['vendor'],
                                                    products[index]['sku'],
                                                    products[index]
                                                        ['categories'],
                                                    products[index]['other'],
                                                    products[index]
                                                        ['description'],
                                                    products[index]['delivery'],
                                                    products[index]['number'],
                                                    products[index]['url'],
                                                  )));
                                    },
                                    child: Card(
                                      elevation: 0,
                                      color: Color(0xFFeaeaea),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            WithoutCacheImage(
                                                "$value/${products[index]['image']}"),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "${products[index]['title']}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Rs.${double.parse(products[index]['price']).toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      color: red, fontSize: 12),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    http.Response
                                                        imageResponse =
                                                        await http.get(
                                                      Uri.parse(
                                                        "$value/${products[index]['image']}",
                                                      ),
                                                    );
                                                    var image = base64.encode(
                                                        imageResponse
                                                            .bodyBytes);
                                                    wishList(
                                                        products[index]['id'],
                                                        products[index]
                                                            ['title'],
                                                        image,
                                                        products[index]
                                                            ['price'],
                                                        DateTime.now());
                                                  },
                                                  child: Icon(
                                                    favourit
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_outline,
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
                                  staggeredTileBuilder: (index) =>
                                      StaggeredTile.fit(1),
                                  mainAxisSpacing: 0.0,
                                  crossAxisSpacing: 0.0,
                                ),

                                if (_isLoadMoreRunning == true)
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 40),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),

                                // When nothing else to load
                                if (_hasNextPage == false)
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 30, bottom: 40),
                                    color: Colors.amber,
                                    child: const Center(
                                      child: Text(
                                          'You have fetched all of the content'),
                                    ),
                                  ),
                              ],
                            )),
                    Center(
                        child: ElevatedButton(
                            child: Text(
                              "Load More",
                              style: TextStyle(
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            onPressed: () {
                              _loadMore();
                            }))
                  ],
                ),
              ),
            ),
    );
  }

  void _buildPopupDialog(List<dynamic> promotionList) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text("Promotions",
                        style: TextStyle(
                            color: Color.fromARGB(255, 241, 133, 8),
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          print("closed");
                          Navigator.pop(context, true);
                        },
                        child: Icon(Icons.close,
                            color: Color.fromARGB(255, 241, 133, 8))),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                promotionList.isEmpty
                    ? CircularProgressIndicator()
                    : Container(
                        height: 200,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            viewportFraction: 1,
                          ),
                          items: promotionList
                              .map(
                                (item) => Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("$value${item}"),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
              ],
            ),
          );
        });
  }

  //@override
  void afterFirstLayout(BuildContext context) async {
    print("I am alertBox");
    // Calling the same function "after layout" to resolve the issue.
    var promotionList = [];
    var response = await http.get(Uri.parse(promotionImages));
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      final listOfImage = items.values.toList();
      if (mounted) {
        setState(() {
          promotionList = listOfImage[2];
        });
      }
    } else {
      throw Exception('Failed to load internet');
    }
    if (promotionList.isNotEmpty) {
      _buildPopupDialog(promotionList);
    }
  }
}
