import 'package:flutter/material.dart';
import 'package:thanhhoa_garden_staff_app/constants/constants.dart';
import 'package:thanhhoa_garden_staff_app/utils/format/date.dart';

import '../utils/format/status.dart';
import 'model/report.dart';

class ReportContainer extends StatefulWidget {
  const ReportContainer({Key? key, required this.report}) : super(key: key);
  final report;

  @override
  State<ReportContainer> createState() => _ReportContainerState();
}

class _ReportContainerState extends State<ReportContainer> {
  @override
  Widget build(BuildContext context) {
    Report report = widget.report;
    var size = MediaQuery.of(context).size;
    return Container(
      //height: 180,
      width: size.width - 200,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: barColor,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(report.serviceName.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                  Text(formatDate(report.createdDate.toString()) , style: const TextStyle(fontSize: 12,)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //_reportFiled('Ngày tạo',formatDate(report.createdDate.toString())),
                  _reportFiled('Ngày làm việc',report.timeWorking.toString()),
                  _reportFiled('Nhân viên',report.staffName.toString()),
                  const Text('Mô tả: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                  Text(report.description.toString() , style: const TextStyle(fontSize: 12,)),
                  const SizedBox(height: 5,),
                  _reportFiled('Trạng thái',formatReport(report.status.toString())),
                ],
              ),
            ],
          ),
           Positioned(
            bottom: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text('Xem chi tiết', style: TextStyle(color: buttonColor),),
                Icon(Icons.chevron_right_outlined, color: buttonColor,),
              ],
            ),),
        ],
      ),
    );
  }

  //Field in Report
  Widget _reportFiled(String title, String des) {
    return Column(
      children: [
        Row(
          children: [
            Text('$title: ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
            Text(des , style: const TextStyle(fontSize: 12),),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

