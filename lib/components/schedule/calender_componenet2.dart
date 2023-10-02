
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:thanhhoa_garden_staff_app/components/button/dialog_button.dart';
import 'package:thanhhoa_garden_staff_app/components/schedule/workingConponent.dart';
import 'package:thanhhoa_garden_staff_app/constants/constants.dart';
import '../../models/contract/contract.dart';
import '../../models/workingDate/scheduleToday/schedule_today.dart';
import '../../providers/contract/contract_provider.dart';
import '../../providers/img_provider.dart';
import '../../providers/schedule/schedule_provider.dart';
import '../../screens/contract/contractPageDetail.dart';
import '../../screens/schedule/schedulePage.dart';
import '../../screens/schedule/workingDateScreenNoConfirm.dart';
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
              future: fetchScheduleByUserID(widget.staffID, today.toString().split(" ")[0],today.toString().split(" ")[0]),
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
                    return ListView.builder(
                      //scrollDirection: Axis.vertical,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          List daysList = (schedule[index].timeWorking.toString().split(" - "));
                          for(int i = 0; i < daysList.length; i++ ){
                            if(daysList[i] == getWeekday(today.weekday)){
                              return Column(
                                children: [
                                  //Text ('Dịch vụ ${index+1}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  WorkingComponentNoConfirm(staffID: widget.staffID!, schedule: schedule[index], today: today, day: day, whereCall: 1,),
                                ],
                              );
                            }
                          } return const SizedBox();
                        },
                        itemCount: schedule.length);
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

}
