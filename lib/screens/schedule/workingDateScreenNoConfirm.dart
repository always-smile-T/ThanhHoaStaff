
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:thanhhoa_garden_staff_app/components/button/dialog_button.dart';
import 'package:thanhhoa_garden_staff_app/constants/constants.dart';
import '../../models/contract/contract.dart';
import '../../models/workingDate/scheduleToday/schedule_today.dart';
import '../../providers/contract/contract_provider.dart';
import '../../providers/img_provider.dart';
import '../../providers/schedule/schedule_provider.dart';
import '../../screens/contract/contractPageDetail.dart';
import '../../screens/schedule/schedulePage.dart';
import '../../utils/connection/utilsConnection.dart';
import '../../utils/format/date.dart';
import '../../utils/format/status.dart';


class WorkingComponentNoConfirm extends StatefulWidget {
  const WorkingComponentNoConfirm({Key? key, required this.staffID, required this.schedule, required this.today, required this.day, required this.whereCall}) : super(key: key);
  final staffID;
  final schedule;
  final today, day;
  final whereCall;


  @override
  State<WorkingComponentNoConfirm> createState() => _WorkingComponentNoConfirmState();
}


bool isSelected = false;


class _WorkingComponentNoConfirmState extends State<WorkingComponentNoConfirm> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    WorkingInSchedule schedule = widget.schedule;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          //child: Card(
            child: Container(
              decoration: BoxDecoration(
                  gradient: infoBackground,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 1, color: buttonColor)
              ),
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
             // padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${schedule.title}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)
                    ],
                  ),
                  const SizedBox(height: 5,),
                  _contractFiled2('ID hợp đồng', schedule.contractID.toString()),
                  _contractFiledColor('Dịch vụ', schedule.serviceName.toString(), buttonColor),
                  _contractFiled2('Tên cây', schedule.plantName.toString()),
                  _contractFiled2('Khách hàng', schedule.fullName.toString()),
                  _contractFiled2('Địa chỉ', schedule.address.toString()),
                  _contractFiled2('Điện thoại', schedule.phone.toString()),
                  _contractFiledColor('Trạng thái', formatWorking(schedule.status.toString()), formatColorStatus(schedule.status.toString())),
                  const SizedBox(height: 5,),
                ],
              ),
            ),
          //),
          onTap: () async {
            OverlayLoadingProgress.start(context);
            bool checkSuccess = await fetchAContract(schedule.contractID);
            OverlayLoadingProgress.stop();
            if(checkSuccess){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ContractDetailPage(contractID: schedule.contractID),
              ));
            } else{
              Fluttertoast.showToast(
                  msg: "Bạn không thể xem hợp đồng này",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: buttonColor,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
        ),
        Container(
          height: 6,
          decoration: const BoxDecoration(color: divince),
        ),
      ],
    );
  }


  Widget _contractFiled2(String title, String des) {
    return Column(
      children: [
        Row(
          children: [
            Text('$title: ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            Text(des , style: const TextStyle(fontSize: 14),),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
  String getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Thứ 2';
      case 2:
        return 'Thứ 3';
      case 3:
        return 'Thứ 4';
      case 4:
        return 'Thứ 5';
      case 5:
        return 'Thứ 6';
      case 6:
        return 'Thứ 7';
      case 7:
        return 'Chủ nhật';
      default:
        return '';
    }
  }
  Widget _contractFiledColor(String title, String des, color) {
    return Column(
      children: [
        RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '$title: ',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),),
              TextSpan(
                text: des,
                style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w600),),
            ])),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  dynamic showdialogConfirm(title, status, id) {
    var size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          _pickImage(ImageSource.gallery);
          return AlertDialog(
            title: Center(
              child: Text(
                'Xác Nhận ' + title,
                style: const TextStyle(color: buttonColor, fontSize: 25),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.center,
                      width: 110,
                      height: 45,
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text('Quay lại',
                          style: TextStyle(
                              color: lightText,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if(status == "WAITING"){

                        bool checkSuccess = await checkStartWorking(id, imgURL.last , widget.staffID!);
                        if(checkSuccess){
                          setState(() {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SchedulePage(staffID: widget.staffID!, whereCall: widget.whereCall),
                            ));
                          });
                        }
                      }
                      if(status == "WORKING"){
                        bool checkSuccess = await checkEndWorking(id, imgURL.last , widget.staffID!);
                        if(checkSuccess){
                          setState(() {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SchedulePage(staffID: widget.staffID!, whereCall: widget.whereCall),
                            ));
                          });
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 110,
                      height: 45,
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text('Xác nhận',
                          style: TextStyle(
                              color: lightText,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          );
        });
  }

  List<String> imgURL = [];
  List<File> listFile = [];

  Future _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    // final image = await ImagePicker().pickMedia();
    if (image == null) return;
    File? img = File(image.path);
    OverlayLoadingProgress.start(context);
    ImgProvider().upload(img).then((value) {
      setState(() {
        imgURL.add(value);
        listFile.add(img);
      });
      OverlayLoadingProgress.stop();
    });

    // ImgProvider().upload(img);
  }
}
