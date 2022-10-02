import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// const String testDevice = 'A5E3AEB1C15CCB69551D62CC06D02516';

class HomeShowBannerAd extends StatefulWidget {
  final id;
  HomeShowBannerAd(this.id);
  @override
  _HomeShowBannerAdState createState() => _HomeShowBannerAdState();
}

class _HomeShowBannerAdState extends State<HomeShowBannerAd> {
  BannerAd _bannerAd;
  bool bannerFailed = false;
  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: widget.id, //'ca-app-pub-3940256099942544/6300978111',
      request: AdRequest(
        keywords: [
          'Game',
          'Flower',
          'Puzzle',
          'Recipe',
          'Food',
          'Restuarent',
          'Hotel',
          'Meal',
          'Vegetable',
          'Fast food',
          'Healthy food',
          'Brain game',
          'italian food',
          'Pizza',
          'Bread',
          'Ramen',
          'Chicken',
          'Candy',
          'Chips',
          'spaghetti',
          'tacos',
          'Desert',
          'Sweets',
          'Cookies',
          'Biscuit',
          'Fruit',
          'Groceries',
          'clothes',
          'toys',
          'sale',
          'shoes',
        ],
      ),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            bannerFailed = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          setState(() {
            bannerFailed = false;
          });
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  @override
  Widget build(BuildContext context) {
    final AdWidget adWidget = AdWidget(ad: _bannerAd);
    return Container(
      alignment: Alignment.center,
      child: adWidget,
      width: bannerFailed ? _bannerAd.size.width.toDouble() : 0.0,
      height: bannerFailed ? _bannerAd.size.height.toDouble() : 0.0,
    );
  }
}

class CatShowBannerAd extends StatefulWidget {
  final id;
  CatShowBannerAd(this.id);
  @override
  _CatShowBannerAdState createState() => _CatShowBannerAdState();
}

class _CatShowBannerAdState extends State<CatShowBannerAd> {
  BannerAd _bannerAd;
  bool bannerFailed = false;
  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: widget.id, //'ca-app-pub-3940256099942544/6300978111',
      request: AdRequest(
        keywords: [
          'Game',
          'Flower',
          'Puzzle',
          'Recipe',
          'Food',
          'Restuarent',
          'Hotel',
          'Meal',
          'Vegetable',
          'Fast food',
          'Healthy food',
          'Brain game',
          'italian food',
          'Pizza',
          'Bread',
          'Ramen',
          'Chicken',
          'Candy',
          'Chips',
          'spaghetti',
          'tacos',
          'Desert',
          'Sweets',
          'Cookies',
          'Biscuit',
          'Fruit',
          'Groceries',
          'clothes',
          'toys',
          'sale',
          'shoes',
        ],
      ),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            bannerFailed = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          setState(() {
            bannerFailed = false;
          });
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  @override
  Widget build(BuildContext context) {
    final AdWidget adWidget = AdWidget(ad: _bannerAd);
    return Container(
      alignment: Alignment.center,
      child: adWidget,
      width: bannerFailed ? _bannerAd.size.width.toDouble() : 0.0,
      height: bannerFailed ? _bannerAd.size.height.toDouble() : 0.0,
    );
  }
}
