import 'dart:convert';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:hwn_mart/home/product_extend.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  int size;
  var userId;
  var totalRows;
  bool _isInAsyncCall = false;

  Future<List> fetchFavourite() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'hwm.db');
// open the database
    Database database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {});
    List<Map<dynamic, dynamic>> maps;

    maps = await database.query('Favourite');

// Count the records
    totalRows = Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM Favourite'));
    print(totalRows);

    return List.generate(maps.length, (i) {
      return FavModel(
        wid: maps[i]['wish_id'].toString(),
        pid: maps[i]['prod_id'].toString(),
        title: maps[i]['title'].toString(),
        price: maps[i]['price'].toString(),
        image: maps[i]['image'],
        date: maps[i]['date_added'].toString(),
      );
    });
  }

  deleteRecord(id) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'hwm.db');
    Database database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {});
    // Delete a record
    var count = await database
        .rawDelete('DELETE FROM Favourite WHERE wish_id = ?', ['$id']);
    print(count);
    if (count == 1) {
      Navigator.pushReplacement(this.context,
          MaterialPageRoute(builder: (context) => WishlistScreen()));
    } else {
      myToast("Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DrawerTopBar().getAppBar("WishList", context),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        color: black,
        progressIndicator: CircularProgressIndicator(),
        child: FutureBuilder<List>(
          future: fetchFavourite(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return totalRows == 0
                ? Center(
                    child: Text("--No data found--"),
                  )
                : StaggeredGridView.countBuilder(
                    padding: const EdgeInsets.all(2.0),
                    itemCount: snapshot.data.length,
                    crossAxisCount: 2,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () async {
                        setState(() {
                          _isInAsyncCall = true;
                        });
                        var response =
                            await http.post(Uri.parse(fetchwishUrl), body: {
                          "id": snapshot.data[index].pid,
                        });
                        if (response.statusCode == 200) {
                          final items = json
                              .decode(response.body)
                              .cast<Map<String, dynamic>>();

                          var sid = items[0]['sid'].toString();
                          var pid = items[0]['pid'].toString();
                          var title = items[0]['title'].toString();
                          var likes = items[0]['likes'].toString();
                          var views = items[0]['views'].toString();
                          var price = items[0]['price'].toString();
                          var image = items[0]['image'].toString();
                          var description = items[0]['description'].toString();
                          var colors = items[0]['colors'].toString();
                          var sizes = items[0]['sizes'].toString();
                          var availability =
                              items[0]['availability'].toString();
                          var vendore = items[0]['vendore'].toString();
                          var sku = items[0]['sku'].toString();
                          var categories = items[0]['categories'].toString();
                          var others = items[0]['others'];
                          var deliveryCharges = items[0]['delivery'];
                          var contact_numb = items[0]['number'];
                          var product_url = items[0]['url'];
                          // var date = items[0]['date_added'];
                          setState(() {
                            _isInAsyncCall = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductExtendScreen(
                                      sid,
                                      pid,
                                      title,
                                      likes,
                                      views,
                                      price,
                                      image,
                                      colors,
                                      sizes,
                                      availability,
                                      vendore,
                                      sku,
                                      categories,
                                      others,
                                      description,
                                      deliveryCharges,
                                      contact_numb,
                                      product_url)));
                        }
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
                                    image: MemoryImage(
                                      base64Decode(
                                        snapshot.data[index].image,
                                      ),
                                    ),
                                  ),
                                ),
                                // child: Image.memory(
                                //   base64Decode(snapshot.data[index].image),
                                //   gaplessPlayback: true,
                                // ),
                              ),
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
                                    style: TextStyle(color: red, fontSize: 12),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      deleteRecord(snapshot.data[index].wid);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WishlistScreen()));
                                    },
                                    child: Icon(
                                      Icons.delete,
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
    );
  }
}
