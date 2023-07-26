import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:thanhhoa_garden_staff_app/components/appBar.dart';
import 'package:thanhhoa_garden_staff_app/report/model/report.dart';
import 'package:thanhhoa_garden_staff_app/report/report_component.dart';
import 'package:thanhhoa_garden_staff_app/report/report_provider.dart';

import '../components/circular.dart';
import '../constants/constants.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final ScrollController _scrollController = ScrollController();
  var selectedTab = 0;
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
        AppBarWiget(title: 'Báo Cáo Của Bạn'),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: 10,
          decoration: const BoxDecoration(color: divince),
        ),
        Container(
          height: 50,
          width: size.width,
          child: _listCategory(),
        ),
        Container(
          height: 10,
          decoration: const BoxDecoration(color: divince),
        ),
        //Contract List
        Expanded(child: ListReort(),),
      ]),
    ),
    );
  }
  Widget ListReort () {
    return  FutureBuilder<List<Report>>(
      future: fetchReport(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Circular();
        }
        if (snapshot.hasData) {
          List<Report> report = snapshot.data!;
          if (snapshot.data == null) {
            return const Center(
              child: Text(
                'Không có kết quả để hiển thị',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            );
          } else {
            return ListView.builder(
              //padding: const EdgeInsets.symmetric(horizontal: 18),
              //scrollDirection: Axis.horizontal,
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: report.length,
                itemBuilder: (BuildContext context, int index) {
                  return (
                  selectedTab == 3 || (selectedTab == 0 && report[index].status == 'NEW') ||
                      (selectedTab == 1 && report[index].status == 'ACTIVE') ||
                      (selectedTab == 2 && report[index].status == 'CANCEL')
                  ) ? GestureDetector(
                    onTap: (){
                      //đến trang contract -> contract Detail
                    },
                      child: ReportContainer(report: report[index],)) : const SizedBox();
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

  //List Main category
  Widget _listCategory() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = index;
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width /4,
                height: 30,
                // padding: const EdgeInsets.all(5),
                decoration:  BoxDecoration(
                    border: selectedTab == index ? Border.all(width: 1, color: Colors.black) : Border.all(width: 0, color: background) ,
                    color: (selectedTab == index) ? buttonColor : Colors.white),
                //margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: AutoSizeText(filter[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: (selectedTab == index) ? lightText : HintIcon),
                ),)
          );
        },
        itemCount: 4);
  }

  //List category
  List filter = [
    'Đã gửi',
    'Đã duyệt',
    'Đã huỷ',
    'Tất cả'
  ];

}
