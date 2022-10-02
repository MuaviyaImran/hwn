import 'package:flutter/material.dart';
import 'package:hwn_mart/home/search/searchTabs/category_search.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'searchTabs/store_search.dart';
import 'searchTabs/product_search.dart';

class SearchResult extends StatefulWidget {
  final List<SearchResultModel> resultList;

  SearchResult(this.resultList);
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'Categories'),
              Tab(text: 'Stores'),
              Tab(text: 'Products'),
            ],
          ),
          centerTitle: true,
          title: Text(
            'Search Result',
            style: TextStyle(
              color: white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            CategorySearch(widget.resultList),
            StoreSearch(widget.resultList),
            ProductSearch(widget.resultList),
          ],
        ),
      ),
    );
  }
}
