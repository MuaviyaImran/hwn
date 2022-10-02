import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hwn_mart/Provider/GetAllProducts.dart';
import 'package:hwn_mart/home/category_all.dart';
import 'package:hwn_mart/home/wishlist.dart';
import 'package:hwn_mart/profile/address/add_address.dart';
import 'package:hwn_mart/profile/address/show_address.dart';
import 'package:hwn_mart/profile/edit_account.dart';
import 'package:hwn_mart/profile/edit_password.dart';
import 'package:hwn_mart/profile/history/order_history.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:provider/provider.dart';
import 'bottom_tab.dart';
import 'home/search/search.dart';
import 'splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => allProductProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'HWN Mart',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primary,
          primarySwatch: Colors.orange,
          primaryIconTheme: const IconThemeData.fallback().copyWith(
            color: black,
          ),
        ),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => SplashScreen(),
          '/home': (context) => MyHomePage(0),
          '/account': (context) => MyHomePage(3),
          '/search': (context) => SearchScreen(),
          "/allcategory": (context) => AllCategoriesScreen(),
          "/wishlist": (context) => WishlistScreen(),
          "/editaccount": (context) => EditAccount(),
          "/editpassword": (context) => EditPassword(),
          "/showaddress": (context) => ShowAddress(),
          "/addaddress": (context) => AddAddress(),
          "/orderHistory": (context) => OrderHistoryScreen(),
        },
      ),
    );
  }
}
