

import '../authentication/user.dart';
import '../bonsaiImg.dart';
import '../cart/cart.dart';

class Rating {
  late final id;
  late final description;

  Rating({this.id, this.description});

  Rating.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    description = json["description"];
  }
}

class FeedbackModel {
  late final orderFeedbackID;
  late final description;
  late final status;
  late final totalRating;
  late final totalFeedback;
  late final avgRatingFeedback;
  late final createdDate;
  late List<ImageURL>? listImg;
  late OrderCart? showPlantModel;
  late User? showCustomerModel;
  late Rating? ratingModel;

  FeedbackModel(
      {this.avgRatingFeedback,
        this.createdDate,
        this.listImg,
        this.description,
        this.orderFeedbackID,
        this.ratingModel,
        this.showCustomerModel,
        this.showPlantModel,
        this.status,
        this.totalFeedback,
        this.totalRating});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    List<ImageURL> Img = [];
    orderFeedbackID = json["orderFeedbackID"];
    description = json["description"];
    status = json["status"];
    totalFeedback = json["totalFeedback"];
    totalRating = json["totalRating"];
    avgRatingFeedback = json["avgRatingFeedback"];
    createdDate = json["createdDate"];
    if (json['imgList'] != null) {
      for (var data in json['imgList']) {
        Img.add(ImageURL.fromJson(data));
      }
    }
    listImg = Img;
    if (json['showPlantModel'] != null) {
      showPlantModel = OrderCart.fromJson(json['showPlantModel']);
    }
    if (json['showCustomerModel'] != null) {
      showCustomerModel = User.fetchInfo(json['showCustomerModel']);
    }
    if (json['ratingModel'] != null) {
      ratingModel = Rating.fromJson(json['ratingModel']);
    }
  }
}

