import 'package:flutter/material.dart';
import 'package:hwn_mart/home/products.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';

class StoreSearch extends StatefulWidget {
  final List<SearchResultModel> storeList;
  StoreSearch(this.storeList);
  @override
  _StoreSearchState createState() => _StoreSearchState();
}

class _StoreSearchState extends State<StoreSearch> {
  @override
  Widget build(BuildContext context) {
    var results = widget.storeList
        .where((elem) =>
            elem.type.toString().toLowerCase().contains('store'.toLowerCase()))
        .toList();
    return Scaffold(
      body: results.length == 0
          ? Center(
              child: Text("--No category found--"),
            )
          : ListView(
              children: widget.storeList
                  .map(
                    (cat) => cat.type.toString().toLowerCase() != 'store'
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductScreen(
                                            cat.title,
                                            cat.image,
                                            cat.id,
                                            cat.storeAddress)));
                              },
                              child: Card(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                        "$value/${cat.image}",
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "${cat.title}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  )
                  .toList(),
            ),
    );
  }
}
