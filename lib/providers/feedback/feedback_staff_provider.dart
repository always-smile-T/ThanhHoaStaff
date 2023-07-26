/*
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:thanhhoa_garden_staff_app/models/feedback/feedback_staff.dart';
import '../../models/bonsaiImg.dart';
import '../../models/feedback/feedback.dart';

class FeedbackStaffProvider extends ChangeNotifier {
  FeedbackStaffModel? _feedback;

  FeedbackStaffModel? get feedbackStaff => _feedback;

  Future<bool> getFeedStaffback() async {
    bool result = false;
    List<FeedbackStaffModel> list = [];
    int status = 404;
    try {
      // Simulate an asynchronous API call
      await Future.delayed(const Duration(seconds: 2))
          .then((value) => {status = 200});
      if (status == 200) {
        if (feedbackList.isNotEmpty) {
          for (var data in feedbackList) {
            List<ImageURL> listImg = [];
            var imgData = data["listImg"];
            if (imgData is List) {
              for (var img in imgData) {
                listImg.add(ImageURL.fromJson(img));
              }
            }
            _feedback = FeedbackStaffModel.fromJson(data, listImg);
          }
        }
        result = true;
        notifyListeners();
      } else {
        result = false;
        notifyListeners();
      }
    } on HttpException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    return result;
  }
}
*/
