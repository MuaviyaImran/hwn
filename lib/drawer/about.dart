import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:hwn_mart/bars/top.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  var kHtml = """
  <center><h2><b> About Us </b></h2></center>
    Here comes the first HWN MART in your city. You can find all the goods relevant to fashion, clothes , mobile phones and all others on a click. The HWN MART is a platform for the customers and shopkeepers to have fun with us.
    <h3><b>FOR CUSTOMERS & SHOPKEEPERS</h3></b>
    You must be thinking why you would stay with us. Give us a second and have a look. We are here to make you stay up to date with your market while staying at your home. You can look for your product or for the shop to give a visit. Hi shopkeepers, how many customers do daily visit your shop? 100 or 200 but after sharing your product with us we will ensure that plenty of people go through  your product not in your city but abroad as well. You don’t have to show your product one by one to your customers, they will finalise the product at their home and visit the shop to have their product.
    <h3><b>GET WHAT YOU WANT</h3></b>
    Just click the app once and search for your product. If you find something of your choice visit the market and get it, or you can leave a message for us to deliver the product to your door in just 24 hours and the payment will be on delivery. We will try to have all the goods in our mart.
    <h3><b>ALL GOODS ARE NOW AT ONE PLACE</h3></b>
    As you know we don’t have a mall or a mega mart in our city where you can find all the goods to save your time .We provide you a mart full of fashion and all other goods just on a click. You don’t have to visit your market any more, just stay connected with us. We are connected with the market for you. We try to  do our best to make you up to date with the latest of your market.
    <h3><b>WE PUBLISH YOU NOT US</h3></b>
    We ensure to the shop keepers that the product will be launched under their logo and banner. Also we will ensure the shopkeepers maintain their product quality , So you (our users) get the best.
    <h3><b>contacts us</h3></b>
    <h4><b>Whatsapp : <a href="https://wa.me/+923301580106">+923301580106</a></h4></b>
    <h4><b>Gmail : <a href="mailto:hwnmart@gmail.com">   
    hwnmart@gmail.com</a></h4></b>
    <h3><b>FOLLOW US ON</h3></b>
    <h4><b>Fb : <a href="https://facebook.com/HWN-Mart-103386555392168">facebook.com/HWN-Mart-103386555392168</a></h4></b>
    <h4><b>Insta : <a href="https://instagram.com/hwn_mart">instagram.com/hwn_mart</a></h4></b>



""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DrawerTopBar().getAppBar("About Us", context),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: HtmlWidget(
              "$kHtml",
              webView: false,
            ),
          ),
        ),
      ),
    );
  }
}
