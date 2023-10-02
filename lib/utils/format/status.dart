

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
    case 'CONFIRMING' : fStatus = 'Đang xác thực';
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
    case 'SIGNED' : fStatus = Colors.blueAccent;
    break;
    case 'WORKING' : fStatus = Colors.indigo;
    break;
    case 'DONE' : fStatus = buttonColor;
    break;
    case 'APPROVED' : fStatus = buttonColor;
    break;
    case 'CONFIRMING' : fStatus = Colors.purple;
    break;
    case 'MISS' : fStatus = ErorText;
    break;
    case 'OTHER' : fStatus = ErorText;
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

String formatContractStatus (status) {
  String fStatus = '';
  switch (status) {
    case 'SIGNED' : fStatus = 'Đến xem lịch >>>';
    break;
    case 'WORKING' : fStatus = 'Đến xem lịch >>>';
    break;
    case 'DONE' : fStatus = 'Đến xem lịch >>>';
    break;
    case 'APPROVED' : fStatus = 'Đến xác nhận >>>';
    break;
    case 'CONFIRMING' : fStatus = 'Duyệt hợp đồng >>>';
    break;
    default : fStatus = '';
  }
  return fStatus;
}

String formatCheckContract(status) {
  String fStatus = '';
  switch (status) {
    case 'APPROVED' : fStatus = 'Đến Nhà Khách Hàng';
    break;
    case 'CONFIRMING' : fStatus = 'Ký Hợp Đồng';
    break;
    default : fStatus = '';
  }
  return fStatus;
}

bool checkContractStatus (status) {
  bool fStatus = false;
  switch (status) {
    case 'SIGNED' : fStatus = true;
    break;
    case 'WORKING' : fStatus = true;
    break;
    case 'DONE' : fStatus = true;
    break;
    default : fStatus = false;
  }
  return fStatus;
}

String formatWorkingStatus (report) {
  String fReport = '';
  switch (report) {
    case 'WAITING' : fReport = 'Chưa bắt đầu';
    break;
    case 'WORKING' : fReport = 'Đang làm';
    break;
    case 'DONE' : fReport = 'Đã hoàn thành';
    break;
    case 'MISS' : fReport = 'Không hoàng thành';
    break;
    default : fReport = 'Đang cập nhật';
  }

  return fReport;
}

String formatWorking (status) {
  String fStatus = '';
  switch (status) {
    case 'WAITING' : fStatus = 'Chưa làm';
    break;
    case 'WORKING' : fStatus = 'Đang Làm';
    break;
    case 'DONE' : fStatus = 'Hoàn thành';
    break;
    case 'MISS' : fStatus = 'Bỏ lỡ';
    break;
    default : fStatus = 'Đang cập nhật';
  }

  return fStatus;
}
String checkNull (status) {
  String fStatus = '';
  if(status == null || status == ''){
    fStatus = '(đang cập nhật)';
  }
  fStatus = status;
  return fStatus;
}