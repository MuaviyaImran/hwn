import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hwn_mart/home/product_extend.dart';
import 'package:hwn_mart/home/search/searchResult.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/insert_data.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<SearchModel> _notes = [];
  List<SearchModel> _notesForDisplay = [];
  TextEditingController _editingController;
  List searchJson = [];
  var totalRows;
  Future<List<SearchModel>> _fetchSearchProduct() async {
    var response = await http.post(Uri.parse(searchUrl));
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<SearchModel> listOfUsers = items.map<SearchModel>((json) {
        return SearchModel.fromJson(json);
      }).toList();
      if (mounted) {
        setState(() {
          searchJson = listOfUsers;
        });
      }
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  var searchText = "";
  @override
  void initState() {
    _editingController = new TextEditingController(text: searchText);
    _fetchSearchProduct().then((value) {
      setState(() {
        _notes.addAll(value);
        _notesForDisplay = _notes;
      });
    });
    super.initState();
  }

  bool _isInAsyncCall = false;
  List resultList = [];
  Future<List<SearchResultModel>> _fetchSearchResult(search) async {
    var response = await http.post(Uri.parse(searchResultUrl), body: {
      "name": search,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<SearchResultModel> listOfUsers =
          items.map<SearchResultModel>((json) {
        return SearchResultModel.fromJson(json);
      }).toList();
      if (mounted) {
        setState(() {
          resultList = listOfUsers;
          _isInAsyncCall = false;
        });
      }
      if (resultList.length == 0) {
        myToast("Nothing found, please try another words");
      } else {
        Navigator.push(this.context,
            MaterialPageRoute(builder: (context) => SearchResult(resultList)));
      }
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  Future<List> fetchHistory() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'hwm.db');
// open the database
    Database database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {});
    List<Map<dynamic, dynamic>> maps;

    maps = await database.query('SearchHistory');

// Count the records
    totalRows = Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM SearchHistory'));
    print(totalRows);

    return List.generate(maps.length, (i) {
      return SearchHistoryModel(
        searchId: maps[i]['search_id'].toString(),
        title: maps[i]['title'].toString(),
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
        .rawDelete('DELETE FROM SearchHistory WHERE search_id = ?', ['$id']);
    print(count);
    if (count == 1) {
      Navigator.pushReplacement(this.context,
          MaterialPageRoute(builder: (context) => SearchScreen()));
    } else {
      myToast("Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: transparent,
        elevation: 0,
        centerTitle: true,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFfcfcfc),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(255, 255, 255, 0.4),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: _editingController,
            onChanged: (text) {
              text = text.toLowerCase();
              setState(() {
                searchText = text;
              });
              print(searchText);
              setState(() {
                _notesForDisplay = _notes.where((note) {
                  var noteTitle = note.title.toLowerCase();
                  return noteTitle.contains(text);
                }).toList();
              });
            },
            onSubmitted: (text) {
              if (searchText.length > 1) {
                if (FocusScope.of(context).isFirstFocus) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
                if (mounted) {
                  setState(() {
                    _isInAsyncCall = true;
                  });
                }
                //save to search history
                searchHistoryList(searchText, DateTime.now());
                _fetchSearchResult(searchText);
              } else {
                myToast("Please enter a valid value");
              }
            },
            keyboardType: TextInputType.text,
            autocorrect: true,
            autofocus: true,
            decoration: InputDecoration(
              isDense: true,
              hintText: "Search categories / stores / product",
              prefixIcon: Icon(Icons.search, size: 22),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _editingController.clear();
                    searchText = '';
                  });
                  print(searchText);
                },
                icon: Icon(
                  Icons.close,
                  size: 20,
                ),
              ),
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primary),
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
        ),
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
      ),
      body: WillPopScope(
        onWillPop: () {
          if (FocusScope.of(context).isFirstFocus) {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
          return;
        },
        child: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          opacity: 0.5,
          color: black,
          progressIndicator: CircularProgressIndicator(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              searchJson.length > 0
                  ? Container(
                      child: searchText.length < 1
                          ? _searchHistory()
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                return index == 0
                                    ? Container()
                                    : _listItem(index - 1, context);
                              },
                              itemCount: _notesForDisplay.length + 1,
                            ),
                    )
                  : Center(child: Text("")),
            ],
          ),
        ),
      ),
    );
  }

  _searchHistory() {
    return FutureBuilder<List>(
      future: fetchHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return totalRows == 0
            ? Center(
                child: Text("--Your search history is empty--"),
              )
            : ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    if (FocusScope.of(context).isFirstFocus) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                    if (mounted) {
                      setState(() {
                        _isInAsyncCall = true;
                      });
                    }
                    //save to search history
                    searchHistoryList(
                        snapshot.data[index].title, DateTime.now());
                    _fetchSearchResult(snapshot.data[index].title);
                  },
                  trailing: IconButton(
                      onPressed: () {
                        deleteRecord(snapshot.data[index].searchId);
                      },
                      icon: Icon(
                        Icons.close,
                        size: 15,
                      )),
                  title: Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        snapshot.data[index].title,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  _listItem(index, context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            this.context,
            MaterialPageRoute(
                builder: (context) => ProductExtendScreen(
                      _notesForDisplay[index].sid,
                      _notesForDisplay[index].pid,
                      _notesForDisplay[index].title,
                      _notesForDisplay[index].likes,
                      _notesForDisplay[index].views,
                      _notesForDisplay[index].price,
                      _notesForDisplay[index].image,
                      _notesForDisplay[index].colors,
                      _notesForDisplay[index].sizes,
                      _notesForDisplay[index].availability,
                      _notesForDisplay[index].vendore,
                      _notesForDisplay[index].sku,
                      _notesForDisplay[index].categories,
                      _notesForDisplay[index].others,
                      _notesForDisplay[index].description,
                      _notesForDisplay[index].delivery,
                      _notesForDisplay[index].contact_number,
                      _notesForDisplay[index].product_url,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 90,
                        child: CachedNetworkImage(
                          imageUrl: "$value/" + _notesForDisplay[index].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  _notesForDisplay[index].title,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Category: " +
                              _notesForDisplay[index].categories.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                        // Text(
                        //   "Store: " + _notesForDisplay[index].stitle.toString(),
                        //   style: TextStyle(fontSize: 14),
                        // ),
                        Text(
                          "Rs.${(_notesForDisplay[index].price)}",
                          style: TextStyle(fontSize: 12, color: primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
