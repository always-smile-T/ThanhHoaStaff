// ignore_for_file: must_be_immutable, file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:thanhhoa_garden_staff_app/components/circular.dart';
import 'package:thanhhoa_garden_staff_app/models/contract/contractDetail/contract_detail.dart';
import 'package:thanhhoa_garden_staff_app/models/workingDate/working_date.dart';
import 'package:thanhhoa_garden_staff_app/providers/contract/contract_provider.dart';
import '../../components/appBar.dart';
import '../../components/button/dialog_button.dart';
import '../../components/schedule/calender_componenet2.dart';
import '../../components/schedule/workingConponent.dart';
import '../../constants/constants.dart';
import '../../models/contract/contract.dart';
import '../../models/workingDate/scheduleToday/schedule_today.dart';
import '../../providers/schedule/schedule_provider.dart';
import '../../utils/format/date.dart';
import '../../utils/showDialog/show_dialog.dart';
import '../contract/contractPageDetail.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key, required this.staffID, required this.whereCall});
  final staffID;
  final whereCall;


  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final ScrollController _scrollController = ScrollController();
  var selectedTab = 0; // For Main Category
  var selectedTabToday = 0; // For SUb Category (Today)
  var selectedTabInWeek = 0; // For SUb Category (Week schedule)
  var f = NumberFormat("###,###,###", "en_US");

  @override
  void initState() {
    if(widget.whereCall == 1){
      selectedTab = 1;
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      body: SizedBox(
        height: size.height,
        child: Column(children: [
          const SizedBox(
            height: 35,
          ),
          //search Bar
          AppBarWiget(title: 'Lịch Chăm Sóc'),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          //Main Category list
          SizedBox(
            height: 50,
            width: size.width,
            child: _listCategory(),
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          //Use when choose Today (selectedTab == 0)
          /*selectedTab == 0 ? Container(
            height: 50,
            width: size.width,
            child: _listCategoryToday(),
          ) : const SizedBox(),*/
          //Working List
          Expanded(child: /*selectedTab == 2 ? _listSchedule() :*/
          selectedTab == 0 ? _listJobToday() :
          selectedTab == 1 ? CanlenderComponent(staffID: widget.staffID!) : const SizedBox(),),
        ]),
      ),
    );
  }

  //UI Category Today
 /* Widget _listCategoryToday() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTabToday = index;
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width /4,
                height: 50,
                // padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: (selectedTabToday == index) ? buttonColor : Colors.white),
                //margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: AutoSizeText(tabToday[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: (selectedTabToday == index) ? lightText : HintIcon),
                ),)
          );
        },
        itemCount: 4);
  }*/

  Widget _listCategory() {
    DateTime now = DateTime.now();
    String weekday = getWeekday(now.weekday);
    int selectedDay = formatNumDay(weekday);
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = index;
                  selectedTab == 1 ? selectedTabInWeek = selectedDay : selectedTabInWeek = 0;
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width /2,
                height: 30,
                // padding: const EdgeInsets.all(5),
                decoration:  BoxDecoration(
                    color: (selectedTab == index) ? buttonColor : Colors.white),
                //margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(tab[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: (selectedTab == index) ? lightText : HintIcon),
                    ),
                    const SizedBox(width: 10,)
                  ],
                ),)
          );
        },
        itemCount: 2);
  }

  //UI Main Category
  /*Widget _listCategory() {
    DateTime now = DateTime.now();
    String weekday = getWeekday(now.weekday);
    int selectedDay = formatNumDay(weekday);
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = index;
                selectedTab == 1 ? selectedTabInWeek = selectedDay : selectedTabInWeek = 0;
              });
             // _searchPlant(0, PageSize, 'ID', true, null, cateID, null, null);
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 3,
              height: 30,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: (selectedTab == index) ? buttonColor : barColor,
                  borderRadius: BorderRadius.circular(50)),
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: AutoSizeText(tab[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: (selectedTab == index) ? lightText : HintIcon),
            ),)
          );
        },
        itemCount: 2);
  }*/

  //List Working Today
  Widget _listJobToday(){
    DateTime now = DateTime.now();
   // String weekday = getWeekday(now.weekday);
    String fweekday = now.year.toString() + '-' + now.month.toString().padLeft(2, '0') + '-' + now.day.toString().padLeft(2, '0');
    return FutureBuilder<List<WorkingInSchedule>>(
      future:fetchScheduleByUserID(widget.staffID,fweekday,fweekday),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Circular();
        }
        if (snapshot.hasData) {
          List <WorkingInSchedule> cD = snapshot.data!;
          //print("cD" + cD.toString());
          if (snapshot.data == null) {
            return const Center(
              child: Text(
                'Không có kết quả để hiển thị',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          } else {
            return ListView.builder(
              //padding: const EdgeInsets.symmetric(horizontal: 18),
              //scrollDirection: Axis.horizontal,
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: cD.length,
                itemBuilder: (BuildContext context, int index) {
                  List days_list = (cD[index].timeWorking.toString().split(" - "));
                  /*if(((selectedTabToday == 1 && cD[index].status.toString() == 'WAITING' ) || (selectedTabToday == 2 && cD[index].status.toString() == 'WORKING')
                      || (selectedTabToday == 3 && cD[index].status.toString() == 'DONE')  || (selectedTabToday == 0) )) {
                  for(int i = 0; i < days_list.length; i++ ){
                    if (days_list[i] == weekday){
                           return WorkingComponent(staffID: widget.staffID!, schedule: cD[index], today: fweekday, day: fweekday, whereCall: 0,);
                    }
                  }} return const SizedBox();*/

                  for(int i = 0; i < days_list.length; i++ ){
                    /*print('g' + i.toString());
                    print(days_list[i].toString().toLowerCase());
                    print(weekday.toString().toLowerCase());*/
                    if (days_list[i].toString().toLowerCase() == getWeekday(today.weekday)){
                     // print(days_list[i].toString().toLowerCase() == weekday);
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 10),
                              Text ('Dịch vụ ${index+1}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: buttonColor),),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          WorkingComponent(staffID: widget.staffID!, schedule: cD[index], today: fweekday, day: fweekday, whereCall: 0,),
                          const SizedBox(height: 10,)
                        ],
                      );
                    }
                  }return const SizedBox();
                }
            );
          }
        }
        return const Center(
          child: Text('Error'),
        );
      },
    );
  }

  //Main Schedule Field
  /*Widget _contractFiled(String title, String des) {
    return Column(
      children: [
        Row(
          children: [
            Text(title + ': ' , style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
            Text(des , style: const TextStyle(fontSize: 12),),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }*/
 /* Widget _contractFiled2(String title, String des) {
    return Column(
      children: [
        Row(
          children: [
            Text(title + ': ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            Text(des , style: const TextStyle(fontSize: 14),),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }*/


  //List main category
  List <String> tab = [
    ('Hôm nay'),('Lịch làm việc')
  ];

  //List today category
  /*List <String> tabToday = [
    ('Tất cả'),('Chờ'),('Đang làm'),('Xong')
  ];*/

  //List Working follow weekday
  /*List <String> dayOfWeek = [
    ('thứ 2'),('thứ 3'),('thứ 4'),('thứ 5'),('thứ 6'),('thứ 7'),('chủ nhật')
  ];*/

  //List weekday (get by DateTime.now)
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
