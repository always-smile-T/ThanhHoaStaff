
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:popup_banner/popup_banner.dart';
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
import '../circular.dart';


class WorkingComponent extends StatefulWidget {
  const WorkingComponent({Key? key, required this.staffID, required this.schedule, required this.today, required this.day, required this.whereCall}) : super(key: key);
  final staffID;
  final schedule;
  final today, day;
  final whereCall;


  @override
  State<WorkingComponent> createState() => _WorkingComponentState();
}


bool isSelected = false;


class _WorkingComponentState extends State<WorkingComponent> {
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
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${schedule.title}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                  const SizedBox(height: 5,),
                  _contractFiled2('ID hợp đồng', schedule.contractID.toString()),
                  _contractFiledColor('Dịch vụ', schedule.serviceName.toString(), buttonColor),
                  _contractFiled2('Tên cây', schedule.plantName.toString()),
                  _contractFiled2('Khách hàng', schedule.fullName.toString()),
                  _contractFiled2('Địa chỉ', schedule.address.toString()),
                  _contractFiled2('Điện thoại', schedule.phone.toString()),
                  _contractFiledColor('Trạng thái', formatWorking(schedule.status.toString()), formatColorStatus(schedule.status.toString())),
                  schedule.startWorkingIMG != null ? ImageChoose(schedule, 'Thông tin trước làm việc', schedule.startWorkingIMG ,schedule.startWorking.toString()) : const SizedBox(),
                  const SizedBox(height: 5,),
                  schedule.endWorkingIMG != null ? ImageChoose(schedule, 'Thông tin sau làm việc', schedule.endWorkingIMG ,schedule.endWorking.toString()) : const SizedBox(),
                  const SizedBox(height: 5,),
                  (imgURL.isEmpty && schedule.status.toString() != 'DONE') ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      schedule.startWorkingIMG == null ? const Text('Để xác nhận làm việc', style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold, fontSize: 14),) :
                      (schedule.endWorkingIMG == null && schedule.startWorkingIMG != null)? const Text('Để xác nhận hoàn thành', style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold, fontSize: 14),) : const SizedBox(),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: (){
                          _pickImage(ImageSource.gallery);
                          setState(() {
                          });
                        },
                        child: const ConfirmButton(title: 'Thêm hình ảnh', width: 100.0),
                      ),
                      const SizedBox(width: 10,),
                    ],
                  ) : const SizedBox(),
                  (imgURL.isNotEmpty) ? GestureDetector(
                    onTap: () {
                      PopupBanner(
                        useDots: false,
                        fit: BoxFit.fitWidth,
                        height: size.height - 150,
                        context: context,
                        images: [imgURL.last.toString()],
                        autoSlide: false,
                        dotsAlignment: Alignment.bottomCenter,
                        dotsColorActive: buttonColor,
                        dotsColorInactive:
                        Colors.grey.withOpacity(0.5),
                        onClick: (index) {},
                      ).show();
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  //shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 3, color: Colors.white)),
                                width: 120,
                                height: 120,
                                child: Image.network(imgURL.last.toString(), fit: BoxFit.fill,)
                            ),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: (){
                                  setState(() {
                                    imgURL.clear();
                                    listFile.clear();
                                  });
                                },
                                icon: Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white
                                    ),
                                    width: 30,
                                    height: 30,
                                    child: const Icon(Icons.cancel_outlined, color: buttonColor, size: 30,)),
                              ))
                        ],
                      ),
                    ),
                  ) : const SizedBox(),
                  (schedule.status.toString() == 'WAITING' && imgURL.isNotEmpty) ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            showdialogConfirm('Bắt Đầu','WAITING',schedule.id);
                          });
                        },
                        child: const ConfirmButton(title: "Bắt đầu làm", width: 100.0),
                      ),
                      const SizedBox(width: 10,)
                    ],
                  ) : (schedule.status.toString() == 'WORKING' && imgURL.isNotEmpty) ?  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          showdialogConfirm('Kết Thúc Công Việc','WORKING',schedule.id);
                        },
                        child: const ConfirmButton(title: "Xong", width: 80.0),
                      ),
                      const SizedBox(width: 10,)
                    ],
                  ) : const SizedBox(),
                  const SizedBox(height: 10,)
                ],
              ),
            ),
          //),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ContractDetailPage(contractID: schedule.contractID),
            ));
          },
        ),
        Container(
          height: 6,
          decoration: const BoxDecoration(color: divince),
        ),
      ],
    );
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

  dynamic showdialogConfirm(title, status, id) {
    var size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
                        OverlayLoadingProgress.start(context);
                        bool checkSuccess = await checkStartWorking(id, imgURL.last , widget.staffID!);
                        if(checkSuccess){
                          setState(() {
                            imgURL.clear();
                            listFile.clear();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SchedulePage(staffID: widget.staffID!, whereCall: widget.whereCall),
                            ));
                          });
                          OverlayLoadingProgress.stop();
                        }
                      }
                      if(status == "WORKING"){
                        OverlayLoadingProgress.start(context);
                        bool checkSuccessDone = await checkEndWorking(id, imgURL.last , widget.staffID!);
                        if(checkSuccessDone){
                          setState(() {
                            imgURL.clear();
                            listFile.clear();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SchedulePage(staffID: widget.staffID!, whereCall: widget.whereCall),
                            ));
                          });
                        }
                        else {Navigator.pop(context);}
                        OverlayLoadingProgress.stop();
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

  ImageChoose(schedule, title, image, time){
    return Card(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: buttonColor)
          ),
          child: ExpansionTile(
            collapsedBackgroundColor: null,
          collapsedTextColor: Colors.black,
          collapsedIconColor: Colors.black,
          iconColor: buttonColor,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          title: Text(title , style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: buttonColor)),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        PopupBanner(
                          useDots: false,
                          fit: BoxFit.fitWidth,
                          height: MediaQuery.of(context).size.height - 150,
                          context: context,
                          images: [image!],
                          autoSlide: false,
                          dotsAlignment: Alignment.bottomCenter,
                          dotsColorActive: buttonColor,
                          dotsColorInactive:
                          Colors.grey.withOpacity(0.5),
                          onClick: (index) {},
                        ).show();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            //shape: BoxShape.circle,
                              border: Border.all(
                                  width: 3, color: Colors.white)),
                          width: 120,
                          height: 120,
                          child: image != null ? Image.network(image!, fit: BoxFit.fill) : Image.network(getImageNoAvailableURL, fit: BoxFit.fill)
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _contractFiled2('Thời gian',formatDate(time)),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}
