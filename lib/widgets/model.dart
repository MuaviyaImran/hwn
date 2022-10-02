class CarouselModel {
  String id, title, storeId, storeTitle, storeImage, address, image, date;

  CarouselModel({
    this.id,
    this.title,
    this.storeId,
    this.storeTitle,
    this.storeImage,
    this.address,
    this.image,
    this.date,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
      id: json['id'],
      title: json['title'],
      storeId: json['store_id'],
      storeTitle: json['store_title'],
      storeImage: json['store_image'],
      address: json['address'],
      image: json['image'],
      date: json['date_added'],
    );
  }
}

// ===================== STORE MODEL
class StoreModel {
  String storeid, title, totalProducts, image, address, date;

  StoreModel({
    this.storeid,
    this.title,
    this.image,
    this.totalProducts,
    this.address,
    this.date,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      storeid: json['id'],
      title: json['title'],
      image: json['image'],
      totalProducts: json['tops'],
      address: json['address'],
      date: json['date_added'],
    );
  }
}

// ==============================PRODUCT Model
class ProductModel {
  String id, title, price, views, likes, image, date;
  String color,
      size,
      availab,
      vendor,
      sku,
      category,
      other,
      desc,
      deliveryChagres,
      contact_number,
      product_url,
      pid;

  ProductModel({
    this.pid,
    this.contact_number,
    this.product_url,
    this.id,
    this.title,
    this.price,
    this.views,
    this.likes,
    this.image,
    this.color,
    this.size,
    this.availab,
    this.vendor,
    this.sku,
    this.category,
    this.other,
    this.desc,
    this.deliveryChagres,
    this.date,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      pid: json['pid'],
      title: json['title'],
      price: json['price'],
      views: json['views'].toString(),
      likes: json['likes'].toString(),
      image: json['image'],
      desc: json['description'],
      color: json['colors'],
      size: json['sizes'],
      contact_number: json['number'],
      product_url: json['url'],
      availab: json['availability'],
      vendor: json['vendore'],
      sku: json['sku'],
      category: json['categories'],
      other: json['others'],
      deliveryChagres: json['delivery'],
      date: json['date_added'],
    );
  }
}

// ==============================PRODUCT IMAGE Model
class ProductImageModel {
  String id, date, image;
  ProductImageModel({
    this.id,
    this.image,
    this.date,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'],
      image: json["image"],
      date: json['date_added'],
    );
  }
}

// ==============================Cart Model
class CartModel {
  String cid, storeAddress;
  int cquantity;
  String ccolor, csize, date;
  String pid,
      title,
      image,
      price,
      colors,
      sizes,
      availability,
      vendore,
      sku,
      categories,
      others,
      description;

  CartModel({
    this.cid,
    this.storeAddress,
    this.cquantity,
    this.ccolor,
    this.csize,
    this.date,
    this.pid,
    this.title,
    this.price,
    this.image,
    this.colors,
    this.sizes,
    this.availability,
    this.vendore,
    this.sku,
    this.categories,
    this.others,
    this.description,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cid: json['cid'],
      storeAddress: json['saddress'],
      cquantity: int.parse(json['cquantity'].toString()),
      ccolor: json['ccolor'],
      csize: json['csize'],
      pid: json['pid'],
      title: json['title'],
      price: json['price'],
      image: json['image'],
      description: json['description'],
      colors: json['colors'],
      sizes: json['sizes'],
      availability: json['availability'],
      vendore: json['vendore'],
      sku: json['sku'],
      categories: json['categories'],
      others: json['others'],
      date: json['date_added'],
    );
  }
}

// ================================WishlistScreen
class FavModel {
  var wid, pid, title, image, price, date;

  FavModel({
    this.wid,
    this.pid,
    this.title,
    this.price,
    this.image,
    this.date,
  });

  factory FavModel.fromJson(Map<String, dynamic> json) {
    return FavModel(
      wid: json['wish_id'],
      pid: json['prod_id'],
      title: json['title'],
      price: json['price'],
      image: json['image'],
      date: json['date_added'],
    );
  }
}

// ================================Search
class SearchHistoryModel {
  var searchId, title, date;

  SearchHistoryModel({
    this.searchId,
    this.title,
    this.date,
  });

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      searchId: json['search_id'],
      title: json['title'],
      date: json['date_added'],
    );
  }
}

class SearchModel {
  String cid, ctitle, sid, stitle, date;
  String pid,
      title,
      likes,
      views,
      image,
      price,
      colors,
      sizes,
      availability,
      vendore,
      sku,
      categories,
      others,
      description,
      delivery,
      product_url,
      contact_number;

  SearchModel(
      {this.cid,
      this.ctitle,
      this.sid,
      this.stitle,
      this.date,
      this.pid,
      this.title,
      this.likes,
      this.views,
      this.price,
      this.image,
      this.colors,
      this.sizes,
      this.availability,
      this.vendore,
      this.sku,
      this.categories,
      this.others,
      this.description,
      this.delivery,
      this.product_url,
      this.contact_number});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      cid: json['cid'],
      ctitle: json['ctitle'],
      sid: json['sid'],
      stitle: json['stitle'],
      pid: json['pid'],
      title: json['title'],
      views: json['views'].toString(),
      likes: json['likes'].toString(),
      price: json['price'],
      image: json['image'],
      description: json['description'],
      colors: json['colors'],
      sizes: json['sizes'],
      availability: json['availability'],
      vendore: json['vendore'],
      sku: json['sku'],
      categories: json['categories'],
      others: json['others'],
      delivery: json['delivery'],
      date: json['date_added'],
      product_url: json['url'],
      contact_number: json['phone'],
    );
  }
}

class SearchResultModel {
  String type,
      id,
      storeId,
      storeAddress,
      title,
      price,
      views,
      likes,
      image,
      date,
      product_url,
      contact_number;
  String color, size, availab, vendor, sku, category, other, desc, delivery;

  SearchResultModel(
      {this.type,
      this.id,
      this.storeId,
      this.storeAddress,
      this.title,
      this.price,
      this.views,
      this.likes,
      this.image,
      this.color,
      this.size,
      this.availab,
      this.vendor,
      this.sku,
      this.category,
      this.other,
      this.desc,
      this.delivery,
      this.date,
      this.product_url,
      this.contact_number});

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      type: json['type'],
      id: json['pid'],
      storeId: json['sid'],
      title: json['title'],
      storeAddress: json['address'],
      price: json['price'],
      views: json['views'].toString(),
      likes: json['likes'].toString(),
      image: json['image'],
      desc: json['description'],
      color: json['colors'],
      size: json['sizes'],
      availab: json['availability'],
      vendor: json['vendore'],
      sku: json['sku'],
      category: json['categories'],
      other: json['others'],
      delivery: json['delivery'],
      date: json['date_added'],
      product_url: json['url'],
      contact_number: json['phone'],
    );
  }
}

/////////////////////////RATING /////////////////////////////
class RatingModel {
  String name, rating, comment, avgrate, total, date;

  RatingModel({
    this.name,
    this.rating,
    this.comment,
    this.avgrate,
    this.total,
    this.date,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      name: json['name'],
      rating: json['rating'].toString(),
      comment: json['review'].toString(),
      avgrate: json['avgrate'].toString(),
      total: json['total'],
      date: json['date_added'],
    );
  }
}

/////////////////////////Address /////////////////////////////
class AddressModel {
  String id, address, city, postcode, date;

  AddressModel({
    this.id,
    this.address,
    this.city,
    this.postcode,
    this.date,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['address_id'],
      address: json['address'].toString(),
      city: json['city'].toString(),
      postcode: json['postcode'].toString(),
      date: json['date_added'],
    );
  }
}

//=================== HISTORY ORDER ====================
class HistoryModel {
  String orderId,
      status,
      first,
      last,
      email,
      number,
      totalCost,
      subCost,
      address,
      city,
      delivery,
      deliveryCharges,
      date;

  HistoryModel({
    this.orderId,
    this.status,
    this.first,
    this.last,
    this.email,
    this.number,
    this.totalCost,
    this.subCost,
    this.address,
    this.city,
    this.delivery,
    this.deliveryCharges,
    this.date,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      orderId: json['order_id'].toString(),
      status: json['status'].toString(),
      first: json['first'].toString(),
      last: json['last'].toString(),
      email: json['email'].toString(),
      number: json['number'].toString(),
      subCost: json['sub_total'].toString(),
      totalCost: json['total_cost'].toString(),
      address: json['address'].toString(),
      city: json['city'].toString(),
      delivery: json['delivery'].toString(),
      deliveryCharges: json['delivery_charges'].toString(),
      date: json['date'].toString(),
    );
  }
}

//=================== HISTORY Detail ORDER ====================

class HistoryDetailModel {
  String orderdetailid,
      sku,
      pId,
      title,
      size,
      color,
      image,
      storeAddress,
      price,
      quantity,
      total,
      rating,
      review,
      reviewStatus,
      date;

  HistoryDetailModel({
    this.orderdetailid,
    this.sku,
    this.pId,
    this.title,
    this.size,
    this.color,
    this.image,
    this.storeAddress,
    this.price,
    this.quantity,
    this.total,
    this.rating,
    this.review,
    this.reviewStatus,
    this.date,
  });

  factory HistoryDetailModel.fromJson(Map<String, dynamic> json) {
    return HistoryDetailModel(
      orderdetailid: json['order_detail_id'].toString(),
      pId: json['prod_id'].toString(),
      sku: json['sku'].toString(),
      title: json['title'].toString(),
      size: json['size'].toString(),
      color: json['color'].toString(),
      image: json['image'].toString(),
      storeAddress: json['store_address'].toString(),
      price: json['price'].toString(),
      quantity: json['quantity'].toString(),
      total: json['total'].toString(),
      rating: json['rating'].toString(),
      review: json['review'].toString(),
      reviewStatus: json['review_status'].toString(),
      date: json['date_added'].toString(),
    );
  }
}

class PromotionImageModel {
  PromotionImageModel({
    this.success,
    this.message,
    this.data,
    this.promotionStatus,
  });

  String success;
  String message;
  List<String> data;
  int promotionStatus;

  factory PromotionImageModel.fromJson(Map<String, dynamic> json) =>
      PromotionImageModel(
        success: json["success"],
        message: json["message"],
        data: List<String>.from(json["data"].map((x) => x)),
        promotionStatus: json["Promotion_status"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x)),
        "Promotion_status": promotionStatus,
      };
}
