// ignore_for_file: constant_identifier_names, unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/order/order.dart';
import '../models/order_detail/order_detail.dart';
import '../utils/format/date.dart';

// const String GG_API_Key = 'AIzaSyA2yiHIRWwyTMebbwJmYDiQcN6AZxpyvrI';
const String GG_API_Key = 'AIzaSyCGhBhR1KfeRlTi_vn8vD8SZEmO1pr-74I';

const infoBackground = LinearGradient(
  colors: [
    Color(0xFFCAF2F5),
    Color(0xFFC8E4E8),
    Color(0xFFFFFFFF),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.0, 0.3, 0.99],
  tileMode: TileMode.clamp,
);

const tabBackground = LinearGradient(
  colors: [
    Color(0xFF91C4C7),
    Color(0xFFC0DADC),
    Color(0xFFFFFFFF),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.0, 0.3, 0.99],
  tileMode: TileMode.clamp,
);
const narBarBackgroud = LinearGradient(
  colors: [
    Color(0xFF0D6368),
    Color(0xFF91C4C7),
    Color(0xFFC0DADC),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.0, 0.4, 0.99],
  tileMode: TileMode.clamp,
);

const background = Color(0xFFF1F7F9);
const divince = Color(0xFFD9D9D9);
const barColor = Color(0xFFC0DADC);
const midBlueColor = Color(0xFF91C4C7);
const buttonColor = Color(0xFF0D6368);
const darkText = Color(0xFF000000);
const lightText = Color(0xFFF8FDFF);
const highLightText = Color(0xFFFF97A3);
const ErorText = Color(0xFFFD6B6B);
const HintIcon = Color(0xFFA0A0A0);
const priceColor = Color(0xFFBD5864);
const notiColor = Color(0xFFEEEAEA);

String convertStatus(String value) {
  String result = value;
  switch (value) {
    case "ALL":
      result = 'Tất cả';
      break;
    case "APPROVED":
      result = 'Đã xác nhận';
      break;
    case "DENIED":
      result = 'Bị từ chối';
      break;
    case "PACKAGING":
      result = 'Đang đóng gói';
      break;
    case "DELIVERING":
      result = 'Đang giao';
      break;
    case "RECEIVED":
      result = 'Đã nhận';
      break;
    case "CUSTOMERCANCELED":
      result = 'Khách huỷ';
      break;
  }
  return result;
}

String scoreFeedback(int score) {
  switch (score) {
    case 1:
      return 'Chưa hài lòng';
    case 2:
      return 'Tạm ổn';
    case 3:
      return 'Bình thường';
    case 4:
      return 'Hài lòng';
    default:
      return 'Rất hài lòng';
  }
}

String converDate(OrderObject order) {
  String result = order.createdDate.toString().substring(0, 10);
  switch (order.progressStatus) {
    case "WAITING":
      result = 'Đang cập nhật';
      break;
    case "APPROVED":
      result = formatDate(order.approveDate.toString());
      break;
    case "DENIED":
      result = formatDate(order.rejectDate.toString());
      break;
    case "PACKAGING":
      result = formatDate(order.packageDate.toString());
      break;
    case "DELIVERING":
      result = formatDate(order.deliveryDate.toString());
      break;
    case "RECEIVED":
      result = formatDate(order.receivedDate.toString());
      break;
    case "CUSTOMERCANCELED":
      result = formatDate(order.rejectDate.toString());
      break;
  }
  return result;
}

String converDateByID(OrderDetailbyID order) {
  String result = order.showOrderModel!.createdDate.toString().substring(0, 10);
  switch (order.showOrderModel!.progressStatus) {
    case "WAITING":
      result = 'Đang cập nhật';
      break;
    case "APPROVED":
      result = formatDate(order.showOrderModel!.approveDate.toString());
      break;
    case "DENIED":
      result = formatDate(order.showOrderModel!.rejectDate.toString());
      break;
    case "PACKAGING":
      result = formatDate(order.showOrderModel!.packageDate.toString());
      break;
    case "DELIVERING":
      result = formatDate(order.showOrderModel!.deliveryDate.toString());
      break;
    case "RECEIVED":
      result = formatDate(order.showOrderModel!.receivedDate.toString());
      break;
    case "CUSTOMERCANCELED":
      result = formatDate(order.showOrderModel!.rejectDate.toString());
      break;
  }
  return result;
}

const NoIMG =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyRE2zZSPgbJThiOrx55_b4yG-J1eyADnhKw&usqp=CAU';

const NotiOrder1 = 'Nhớ cập nhật đơn hàng cho khách của bạn nhé !!!';
const NotiOrder2 =
    'Tiến hành đống gói.';
const NotiOrder3 =
    'Tiến hành giao hàng.';
const NotiOrder4 =
    'Xác nhận khách đã nhận tại đây.';
const NotiOrder5 =
    'Bạn đã hoàn thành đơn hàng xuất sắc.';
const NotiOrder6 =
    'Đơn hàng này đã không còn tồn tại.';


String formatDateShow(String date) {
  DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);
  return date = DateFormat('dd/MM/yyyy').format(parseDate);
}

dynamic showPolyci(String policy, context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Center(
              child: Text(
                'Điều khoảng',
                style: TextStyle(color: buttonColor, fontSize: 25),
              ),
            ),
            content: SingleChildScrollView(child: Text(policy)));
      });
}

List<String> listReason() {
  return [
    'Thứ 2',
    'Thứ 3',
    'Thứ 4',
    'Thứ 5',
    'Thứ 6',
    'Thứ 7',
    'Chủ nhật'
  ];
}

String getDate(String date) {
  DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date);
  return date = DateFormat('MM/dd/yyyy hh:mm a').format(parseDate);
}

String formatDateStartDateContact(String date) {
  DateTime parseDate = DateFormat("dd/MM/yyyy").parse(date);
  return date = DateFormat('yyyy-MM-dd').format(parseDate);
}

String formatDate1(DateTime date) {
  String result;
  return result = DateFormat('dd/MM/yyyy').format(date);
}
String getToday(DateTime date) {
  String result = DateFormat('yyyy-MM-dd').format(date);
  return result;
}

Color colorWorkingDate(String value) {
  Color result = Colors.black;
  switch (value) {
    case "WAITING":
      result = Colors.yellow.shade700;
      break;
    case "WORKING":
      result = Colors.green;
      break;
    case "DONE":
      result = buttonColor;
      break;
    case "CUSTOMERCANCELED":
      result = Colors.red;
      break;
    case "STAFFCANCELED":
      result = Colors.red;
      break;
  }
  return result;
}

String convertStatusWorkingDate(String value) {
  String result = value;
  switch (value) {
    case "WAITING":
      result = 'Chờ thực hiện';
      break;
    case "WORKING":
      result = 'Đang thực hiện';
      break;
    case "DONE":
      result = 'Hoàn thành';
      break;
    case "CUSTOMERCANCELED":
      result = 'KH Hủy';
      break;
    case "STAFFCANCELED":
      result = 'Hủy';
      break;
  }
  return result;
}
List<String> tab = [
  ('Hôm nay'),
  ('Lịch theo tháng'),
  ('Lịch theo HĐ'),
];

var f = NumberFormat("###,###,###", "en_US");
String setPriceService(double price, int type, int pack, int months) {
  return f.format(price * months +
      (price * type / 100) * months -
      (price * pack / 100) * months);
}

int countMonths(DateTime date1, DateTime date2) {
  int months = (date2.difference(date1).inDays / 31).ceil();
  return months;
}

const String policyContract = 'Điều khoản hợp đồng'
    '\n1.Tạo và xác nhận hợp đồng:'
    '\nHợp đồng tạo khách hàng cần được người quản lý xác nhận.'
    '\n2.Hủy Trong Quá trình Người Quản lý Lý Xem:'
    '\nTrong thời gian chờ trình quản lý đồng bộ, khách hàng có thể hủy hợp đồng.'
    '\n3.Hoàn Thiện và Chỉnh Hợp Đồng:'
    '\nSau khi người quản lý xác nhận đồng ý, không thể sửa đổi bất cứ điều gì.'
    '\n4.Hủy và Điều chỉnh bởi Thanh Hóa:'
    '\nThanh Hóa có quyền hủy bỏ hoặc điều chỉnh đồng bộ nếu có vấn đề xảy ra.'
    '\n5.Ký hiệu Hợp Đồng và Phân Phối:'
    '\nSau khi người quản lý xác nhận đồng ý, hợp đồng sẽ được gửi cho khách hàng để ký kết.'
    '\n6.Bản Sao Hợp Đồng và Lưu Trữ:'
    '\nMỗi bên chứa một bản sao đã ký và một bản sao sẽ được lưu trữ trong hệ thống của Thanh Hóa.'
    '\n7.Hợp Đồng Tại Cửa Hàng:'
    '\nHợp đồng tạo tại cửa hàng sẽ được ký tại cửa hàng với tham số của người quản lý cửa hàng. Mỗi bên chứa một bản sao và một bản sao sẽ được lưu trữ trong hệ thống của Thanh Hóa.'
    '\n8.Thời gian làm việc hiệu lực:'
    '\nSau khi ký hợp đồng, thời gian làm việc được xác định sẽ có hiệu lực như trong hợp đồng. Khách hàng có thể theo dõi tiến trình công việc trực tiếp qua ứng dụng "Thanh Hóa".'
    '\n9.Báo Cáo Lỡ Hẹn:'
    '\nTrong những ngày dự phòng nhưng nhân viên chưa đến, khách hàng có thể sử dụng ứng dụng để tạo báo cáo và thông báo cho Thanh Hóa.'
    '\n10.Báo Cáo Do Khách Hàng Tạo Ra:'
    '\nMọi báo cáo do khách hàng tạo ra sẽ được người quản lý hợp lý đồng xem xét và phê duyệt.'
    '\n11.Phê duyệt Báo Cáo:'
    '\nNếu báo cáo được người quản lý hợp lý chấp thuận, khách hàng sẽ nhận được dịch vụ bỏ lỡ vào một ngày thay thế.'
    '\n12.Nhiệm vụ trong Công Cáo:'
    '\nKhách hàng phải sử dụng tính năng báo cáo một cách trách nhiệm và người quản lý luôn xác minh các báo cáo để đảm bảo tính chính xác.'
    '\n13.Vi Phạm Hợp Đồng:'
    '\nTrong thời hạn hợp nhất, nếu có một bên trong phạm vi điều khoản, bên kia có quyền yêu cầu chấm dứt hợp đồng và thực hiện các thủ tục liên tục và tương ứng phí.'
    '\n14.Bảo Mật Thông Tin Hàng Hàng:'
    '\nThanh Hóa phải đảm bảo tính bảo mật của thông tin khách hàng.'
    '\n16.Độ Chính Xác Của Thông Tin Hàng Hàng:'
    '\nCung cấp thông tin khách hàng cho Thanh Hóa phải chính xác.'
    '\n17.Độ Chính xác Thông tin của Thanh Hóa:'
    '\nThông tin Thanh Hóa cung cấp cho khách hàng phải chính xác.'
    '\n18.Xác nhận Nhận Thông Tin Giao Dịch:'
    '\nMọi thông tin liên quan đến giao dịch phải được xác định bởi cả hai bên.';