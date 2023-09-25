import 'dart:convert';


String formatDate(String date) {
  try {
    DateTime dateTime = DateTime.parse(date);
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String formattedString =
        "$hour:$minute ${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";

    return formattedString;
  } catch (e) {
    print('This is not a valid JSON.');
  }
  return 'Đang cập nhật';
}
int formatNumDay(String day) {
  int fday = 0;
  switch (day) {
    case 'Thứ 2' : fday = 0;
    break;
    case 'Thứ 3' : fday = 1;
    break;
    case 'Thứ 4' : fday = 2;
    break;
    case 'Thứ 5' : fday = 3;
    break;
    case 'Thứ 6' : fday = 4;
    break;
    case 'Thứ 7' : fday = 5;
    break;
    case 'Chủ Nhật' : fday = 6;
    break;
    default : fday = 0;
  }
  return fday;
}

String formatDatenoTime(String date) {
  try {
    DateTime dateTime = DateTime.parse(date);
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String formattedString =
        "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";

    return formattedString;
  } catch (e) {
    print('This is not a valid JSON.');
  }
  return 'Đang cập nhật';
}

String formatDatenoTime2(String date) {
  try {
    DateTime dateTime = DateTime.parse(date);
    String formattedString =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";

    return formattedString;
  } catch (e) {
    print('This is not a valid JSON.');
  }
  return 'Đang cập nhật';
}

String formatDateAPI(String inputDate) {
  // Tách ngày, tháng và năm từ chuỗi đầu vào
  List<String> dateParts = inputDate.split('/');

  if (dateParts.length == 3) {
    String day = dateParts[0];
    String month = dateParts[1];
    String year = dateParts[2];

    // Định dạng lại chuỗi ngày tháng năm
    String formattedDate = "$year-$month-$day";
    return formattedDate;
  } else {
    // Trả về chuỗi gốc nếu đầu vào không hợp lệ
    return inputDate;
  }
}