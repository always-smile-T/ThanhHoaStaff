
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
import '../../constants/constants.dart';
import '../../models/contract/contract.dart';
import '../../models/workingDate/scheduleToday/schedule_today.dart';
import '../../providers/schedule/schedule_provider.dart';
import '../../utils/connection/utilsConnection.dart';
import '../../utils/format/date.dart';
import '../../utils/format/status.dart';
import '../../utils/showDialog/show_dialog.dart';
import '../contract/contractPageDetail.dart';

class WorkingDateFollowContractPage extends StatefulWidget {
  const WorkingDateFollowContractPage({super.key, required this.contractDetailID, required this.contractID, required this.whereCall, required this.staffID});
  final contractDetailID;
  final contractID;
  final whereCall;
  final staffID;


  @override
  State<WorkingDateFollowContractPage> createState() => _WorkingDateFollowContractPageState();
}

class _WorkingDateFollowContractPageState extends State<WorkingDateFollowContractPage> {
  final ScrollController _scrollController = ScrollController();
  var selectedTab = 0; // For Main Category
  var selectedTabToday = 0; // For SUb Category (Today)
  var selectedTabInWeek = 0; // For SUb Category (Week schedule)
  var f = NumberFormat("###,###,###", "en_US");

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
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
          /*Center(
            child: Container(
              height: 1,
              width: size.width - 180,
              decoration: const BoxDecoration(color: buttonColor),
            ),
          ),*/ /*
          const SizedBox(
            height: 20,
          ),
          //Main Category list
          SizedBox(
            height: 50,
            width: size.width,
            child: _listCategory(),
          ),*/
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
          /*(selectedTab == 0 || selectedTab == 1) ? Container(
            height: 1,
            width: size.width,
            decoration: const BoxDecoration(color: buttonColor),
          ): const SizedBox(),*/
          //Working List
          Expanded(child: /*selectedTab == 2 ? _listSchedule() :
          selectedTab == 0 ? _listJobToday() :*/
          _listSchedule(),)
        ]),
      ),
    );
  }

  //All Of the Schedule that Staff done (History)
  Widget _listSchedule(){
    var size = MediaQuery.of(context).size;
    return FutureBuilder<List<WorkingInSchedule>>(
      future: fetchScheduleContractDetail(widget.contractDetailID, widget.contractID, widget.whereCall),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Circular();
        }
        if (snapshot.hasData) {
          List<WorkingInSchedule> date = snapshot.data!;
          if (snapshot.data! == null) {
            return const Center(
              child: Text(
                'Không có kết quả để hiển thị',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            );
          } else {
            //List ClipRREct -> show history when hit the container
            //Need to Design better
            print("staff1: " + widget.staffID.toString());
            int length = date.length;
            print("staff1: " + date[10].showStaffModel!.id.toString());
            return ListView.builder(
              //padding: const EdgeInsets.symmetric(horizontal: 18),
              //scrollDirection: Axis.horizontal,
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: date.length,
                itemBuilder: (BuildContext context, int index) {
                  return (date[length - index - 1].status.toString() == 'WAITING') ?
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formatDatenoTime(date[length - index - 1].workingDate.toString()), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                          //const SizedBox(height: 5,),
                          //Text(date[index].serviceName.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 5,),
                          _contractFiled2('ID hợp đồng', widget.contractID.toString()),
                          _contractFiled2('ID Dịch vụ', date[length - index - 1].contractDetailID.toString()),
                          _contractFiled2('Tên cây', date[length - index - 1].plantName.toString()),
                          _contractFiled('Trạng thái',formatWorkingStatus(date[length - index - 1].status.toString()),date[length - index - 1].status.toString() ),
                          (widget.staffID.toString() == date[length - index - 1].showStaffModel!.id.toString()) ? const SizedBox() : const Text('Đã chuyển cho nhân viên khác' , style: TextStyle(fontSize: 14, color: Colors.pink,),),
                        ],
                      ),
                    ),
                  ) : Card(
                    child: ExpansionTile(
                      collapsedTextColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      iconColor: buttonColor,
                      textColor: Colors.black,
                      backgroundColor: Colors.white,
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formatDatenoTime(date[length - index - 1].workingDate.toString()), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                          //const SizedBox(height: 5,),
                          //Text(date[index].serviceName.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 5,),
                          _contractFiled2('ID hợp đồng', widget.contractID.toString()),
                          _contractFiled2('ID Dịch vụ', date[length - index - 1].contractDetailID.toString()),
                          _contractFiled2('Tên cây',  date[length - index - 1].title.toString()), //plantName
                          _contractFiled('Trạng thái',formatWorkingStatus(date[length - index - 1].status.toString()),date[length - index - 1].status.toString() ),
                        ],
                      ),
                      children: [
                        Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: size.width - 40,
                                              height: 1,
                                              decoration: const BoxDecoration(color: divince),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text('Thông tin trước làm việc' , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: buttonColor)),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                  //shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 3, color: Colors.white)),
                                                width: 120,
                                                height: 120,
                                                child: date[length - index - 1].startWorkingIMG != null ? Image.network(date[length - index - 1].startWorkingIMG!, fit: BoxFit.fill) : Image.network(getImageNoAvailableURL, fit: BoxFit.fill)
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            _contractFiled2('Thời gian',formatDate(date[length - index - 1].startWorking.toString())),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: size.width - 40,
                                              height: 1,
                                              decoration: const BoxDecoration(color: divince),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                        date[length - index - 1].endWorkingIMG != null ? Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Thông tin sau làm việc' , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: buttonColor)),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                  //shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 3, color: Colors.white)),
                                                width: 120,
                                                height: 120,
                                                child: date[length - index - 1].endWorkingIMG != null ? Image.network(date[length - index - 1].endWorkingIMG!, fit: BoxFit.fill) : Image.network(getImageNoAvailableURL, fit: BoxFit.fill)
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            _contractFiled2('Thời gian',formatDate(date[length - index - 1].endWorking.toString())),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ) : const SizedBox(),
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ],
                        )
                      ],
                    ),
                  );
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

  Widget _contractFiled(String title, String des, status) {
    return Column(
      children: [
        Row(
          children: [
            Text(title + ': ' , style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
            Text(des , style: TextStyle(fontSize: 14, color: formatColorStatus(status)),),
          ],
        ),
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
            Text(title + ': ' , style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
            Text(des , style: TextStyle(fontSize: 14),),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}