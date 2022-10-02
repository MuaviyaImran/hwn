import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hwn_mart/ads/ad_const.dart';
import 'package:hwn_mart/ads/ad_helper.dart';
import 'package:hwn_mart/bars/searchBar.dart';
import 'package:hwn_mart/home/stores.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';

class AllCategoriesScreen extends StatefulWidget {
  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  int size;
  Future<List<CarouselModel>> _fetchcategory() async {
    var response = await http.post(Uri.parse(categoryUrl), body: {
      "type": "all",
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<CarouselModel> listOfUsers = items.map<CarouselModel>((json) {
        return CarouselModel.fromJson(json);
      }).toList();
      size = listOfUsers.length;

      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 1;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 4;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 160;
    var _aspectRatio = _width / cellHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: transparent,
        // toolbarHeight: 45,
        centerTitle: true,
        title: SearchBarSc(),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/wishlist");
            },
            icon: Image.asset(
              "assets/slice/Heart.png",
              width: 24,
            ),
          ),
        ],
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  color: skin,
                  child: CatShowBannerAd(catAdUnitId),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 90.0),
            child: FutureBuilder<List<CarouselModel>>(
                future: _fetchcategory(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  return GridView(
                    shrinkWrap: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _crossAxisCount,
                      childAspectRatio: _aspectRatio,
                    ),
                    // physics: ScrollPhysics(),
                    children: snapshot.data
                        .map(
                          (cat) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StoresScreen(cat.title, cat.id)));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: primary, width: 2),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image:
                                            NetworkImage("$value/${cat.image}"),
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
                  );
                }),
          ),
        ],
      ),
    );
  }
}
