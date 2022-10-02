import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

cart(id, quantity, color, size) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var userID = prefs.getString('userID');
  print("$email $userID $id $quantity");
  if (email == null && userID == null) {
    return myToast("Please Sign In..");
  } else {
    var response = await http.post(Uri.parse(addToCartUrl), body: {
      "id": userID,
      "product_id": id,
      "quantity": quantity.toString(),
      "color": color,
      "size": size,
    });
    print(response.body);
    if (response.statusCode == 200) {
      myToast("Product added to cart successfully");
    } else {
      myToast("Something went wrong");
    }
  }
}

wishList(prodId, title, image, price, cdate) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'hwm.db');
  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE Favourite (wish_id INTEGER PRIMARY KEY autoincrement, prod_id INTEGER, title TEXT, image TEXT, price INTEGER, date_added DATETIME)');
  });
// Insert some records in a transaction
  await database.transaction((txn) async {
    int id1 = await txn.rawInsert(
        'INSERT INTO Favourite (prod_id , title, image, price, date_added) VALUES("$prodId","$title", "$image" , "$price", "$cdate")');
    print('inserted1: $id1');
    if (id1 != null) {
      myToast("Product added to wishlist");
    } else {
      myToast("Failed to add");
    }
  });

  final response = await http.post(Uri.parse(deleteAddressUrl), body: {
    "id": prodId,
    "type": 'like',
  });
  if (response.statusCode == 200) {}
}

searchHistoryList(title, cdate) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'hwm.db');
  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE SearchHistory (search_id INTEGER PRIMARY KEY autoincrement, title TEXT, date_added TEXT)');
  });
// Insert some records in a transaction
  await database.transaction((txn) async {
    int id1 = await txn.rawInsert(
        'INSERT INTO SearchHistory (title, date_added) VALUES("$title", "$cdate")');
    print('inserted1: $id1');
  });
}
