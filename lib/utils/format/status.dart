

import 'package:flutter/material.dart';
import 'package:thanhhoa_garden_staff_app/constants/constants.dart';

String formatStatus (status) {
  String fStatus = '';
  switch (status) {
    case 'WAITING' : fStatus = 'Chờ duyệt';
    break;
    case 'DENIED' : fStatus = 'Quản lý huỷ';
    break;
    case 'STAFFCANCELED' : fStatus = 'Nhân viên huỷ';
    break;
    case 'CUSTOMERCANCELED' : fStatus = 'Khách hàng huỷ';
    break;
    case 'APPROVED' : fStatus = 'Đã nhận';
    break;
    case 'SIGNED' : fStatus = 'Đã ký';
    break;
    case 'WORKING' : fStatus = 'Đang hoạt động';
    break;
    case 'DONE' : fStatus = 'Hoàn thành';
    break;
    default : fStatus = 'Đang cập nhật';
  }

  return fStatus;
}


Color formatColorStatus (status) {
  Color fStatus = Colors.black;
  switch (status) {
    case 'WAITING' : fStatus = Colors.orange;
    break;
    case 'DENIED' : fStatus = highLightText;
    break;
    case 'STAFFCANCELED' : fStatus = highLightText;
    break;
    case 'CUSTOMERCANCELED' : fStatus = highLightText;
    break;
    case 'SIGNED' : fStatus = Colors.yellowAccent;
    break;
    case 'WORKING' : fStatus = Colors.green;
    break;
    case 'DONE' : fStatus = Colors.lightGreen;
    break;
    case 'APPROVED' : fStatus = buttonColor;
    break;
    default : fStatus = Colors.black;
  }

  return fStatus;
}

String formatReport (report) {
  String fReport = '';
  switch (report) {
    case 'NEW' : fReport = 'Đã gửi';
    break;
    case 'ACTIVE' : fReport = 'Đã duyệt';
    break;
    case 'CANCEL' : fReport = 'Đã huỷ';
    break;
    default : fReport = 'Đang cập nhật';
  }

  return fReport;
}
