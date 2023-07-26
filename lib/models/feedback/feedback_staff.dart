import '../bonsaiImg.dart';

class FeedbackStaffModel {
  late final name_creater;
  late final imgurl;
  late final create_date;
  late final description;
  late final rating;
  late List<ImageURL>? listImg;

  FeedbackStaffModel(
      { this.create_date,
        this.description,
        this.listImg,
        this.rating,
        this.name_creater,
        this.imgurl});

  FeedbackStaffModel.fromJson(
      Map<String, dynamic> json, List<ImageURL>? listImgage) {
    name_creater = json["name_creater"];
    create_date = json["create_date"];
    rating = json["rating"];
    description = json["description"];
    imgurl = json["imgurl"];
    listImg = listImgage;
  }
}

var feedback =
  {
    "name_creater": "Nguyễn Văn A",
    "imgurl":
    "https://haycafe.vn/wp-content/uploads/2021/11/Anh-avatar-dep-chat-lam-hinh-dai-dien-600x600.jpg",
    "create_date": "2023-06-15 23:59:59",
    "rating": "5",
    "description":
    "Lần đầu mua online mà ưng nha. Tưởng phải chờ lâu hàng mới iao tới nhưng lẹ lắm. Còn cây này trồng khoẻ re, nào vui tưới nước còn buồn buồn thì thôi.",
    "listImg": [
      {
        "id": "65",
        "url":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhGBCS9NCNjgwkm5AG3YdueTODZ31ngbpayw&usqp=CAU",
        "plant_id": "1"
      },
      {
        "id": "66",
        "url":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKdofWcH2chdhzWYbnCuencDeZTWd4vYLymQ&usqp=CAU",
        "plant_id": "1"
      },
      {
        "id": "67",
        "url":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRedLtTWJCXIKURdrMpExn8tjk4DfbjNU3CDA&usqp=CAU",
        "plant_id": "1"
      },
      {
        "id": "68",
        "url":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6aZodFeLihM-q18vpDMlBV85bEpQZkY1cXQ&usqp=CAU",
        "plant_id": "1"
      },
      {
        "id": "68",
        "url":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6aZodFeLihM-q18vpDMlBV85bEpQZkY1cXQ&usqp=CAU",
        "plant_id": "1"
      },
      {
        "id": "68",
        "url":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6aZodFeLihM-q18vpDMlBV85bEpQZkY1cXQ&usqp=CAU",
        "plant_id": "1"
      },
      {
        "id": "68",
        "url":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6aZodFeLihM-q18vpDMlBV85bEpQZkY1cXQ&usqp=CAU",
        "plant_id": "1"
      },
    ]
  };
