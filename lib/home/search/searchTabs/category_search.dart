import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hwn_mart/home/stores.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';

class CategorySearch extends StatefulWidget {
  final List<SearchResultModel> catList;
  CategorySearch(this.catList);
  @override
  _CategorySearchState createState() => _CategorySearchState();
}

class _CategorySearchState extends State<CategorySearch> {
  @override
  Widget build(BuildContext context) {
    var results = widget.catList
        .where((elem) => elem.type
            .toString()
            .toLowerCase()
            .contains('category'.toLowerCase()))
        .toList();
    return Scaffold(
        body: results.length == 0
            ? Center(
                child: Text("--No category found--"),
              )
            : StaggeredGridView.countBuilder(
                itemCount: widget.catList.length,
                crossAxisCount: 2,
                itemBuilder: (context, index) => widget.catList[index].type
                            .toString()
                            .toLowerCase() !=
                        'category'
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StoresScreen(
                                        widget.catList[index].title,
                                        widget.catList[index].id)));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: black, width: 1),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "$value/${widget.catList[index].image}"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              // SizedBox(height: 5),
                              Text(
                                "${widget.catList[index].title}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 0.0,
              ));
  }
}
