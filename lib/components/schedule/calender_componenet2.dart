
import 'dart:io';

import 'package:flutter/material.dart';
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
import '../circular.dart';


class CanlenderComponent extends StatefulWidget {
  const CanlenderComponent({Key? key, required this.staffID}) : super(key: key);
  final staffID;


  @override
  State<CanlenderComponent> createState() => _CanlenderComponentState();
}


DateTime today = DateTime.now();
bool isSelected = false;


class _CanlenderComponentState extends State<CanlenderComponent> {


  String day = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString().substring(0,10);

  @override
  void initState() {
    // TODO: implement initState
    getScheduleToday();
    super.initState();
  }

  getScheduleToday (){
    fetchScheduleInWeek(day,day);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10,),
          TableCalendar(
            locale: 'vi_VN',
            rowHeight: 35,
            headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, today),
            onDaySelected: _onDateSelected,
            firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day),
            lastDay: DateTime.utc(DateTime.now().year + 1, DateTime.now().month, ((DateTime.now().month == 2) && ((DateTime.now().year % 4) == 0)) ? 29 :
            ((DateTime.now().month == 2) && ((DateTime.now().year % 4) != 0)) ? 28 :
            ((DateTime.now().month == 4) || (DateTime.now().month == 6) || (DateTime.now().month == 9) || (DateTime.now().month == 11)) ? 30 : 31),
            focusedDay: today,
            startingDayOfWeek: StartingDayOfWeek.monday,
          ),
          const SizedBox(height: 10,),
          Container(
            height: 6,
            decoration: const BoxDecoration(color: divince),
          ),
         /* isSelected ?*/ SizedBox(
            height: 600,
            child: FutureBuilder<List<WorkingInSchedule>>(
              future: fetchScheduleInWeek(today.toString().split(" ")[0],today.toString().split(" ")[0]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Circular();
                }
                if (snapshot.hasData) {
                  List <WorkingInSchedule> schedule = snapshot.data!;
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text(
                        'Không có kết quả để hiển thị',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  } else {
                    return Container(
                      child: ListView.builder(
                          //scrollDirection: Axis.vertical,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            List daysList = (schedule[index].timeWorking.toString().split(" - "));
                            for(int i = 0; i < daysList.length; i++ ){
                              if(daysList[i] == getWeekday(today.weekday)){
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      child: Card(
                                        child: Container(
                                          padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('${schedule[index].title} - ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                                                  Text(schedule[index].serviceName.toString(), style: const TextStyle(fontSize: 12),),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              _contractFiled2('Khách hàng', schedule[index].fullName.toString()),
                                              _contractFiled2('Địa chỉ', schedule[index].address.toString()),
                                              _contractFiled2('Điện thoại', schedule[index].phone.toString()),
                                              const SizedBox(height: 5,),
                                              (schedule[index].status.toString() == 'WAITING' && (today.toString().split(" ")[0] == day) ) ? Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState(() {
                                                        showdialogConfirm('Bắt Đầu','WAITING',schedule[index].id);
                                                      });
                                                    },
                                                    child: ConfirmButton(title: "Làm", width: 80.0),
                                                  ),
                                                  const SizedBox(width: 10,)
                                                ],
                                              ) : (schedule[index].status.toString() == 'WORKING' && (today.toString().split(" ")[0] == day)) ?  Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){
                                                      showdialogConfirm('Kết Thúc Công Việc','WORKING',schedule[index].id);
                                                    },
                                                    child: ConfirmButton(title: "Xong", width: 80.0),
                                                  ),
                                                  const SizedBox(width: 10,)
                                                ],
                                              ) : const SizedBox(),
                                              const SizedBox(height: 10,)
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () async{
                                        Contract contract = await fetchAContract(schedule[index].contractID);
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => ContractDetailPage(contractID: contract.id),
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
                            } return const SizedBox();
                          },
                          itemCount: schedule.length),
                    );
                  }
                }
                return const Center(
                  child: Text('Không có kết quả để hiển thị'),
                );
              },
            ),
          ) /*: const SizedBox()*/,
        ],
      ),
    );
  }
  Future<void> _onDateSelected(DateTime day, DateTime focusedDay) async {
    setState(() {
      today = day;
      isSelected = true;
    });
  }
  Widget _contractFiled2(String title, String des) {
    return Column(
      children: [
        Row(
          children: [
            Text('$title: ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text(des , style: const TextStyle(fontSize: 12),),
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
                    onTap: () {
                      if(status == "WAITING"){
                        Navigator.of(context).pop();
                        setState(() {
                          checkStartWorking(id, imgURL.last , widget.staffID!);
                        });
                      }
                      if(status == "WORKING"){
                        Navigator.of(context).pop();
                        setState(() {
                          checkEndWorking(id, imgURL.last , widget.staffID!);
                        });
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
