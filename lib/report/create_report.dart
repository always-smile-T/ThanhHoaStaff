// ignore_for_file: must_be_immutable, file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:thanhhoa_garden_staff_app/report/report_provider.dart';

import '../../components/appBar.dart';
import '../../components/button/dialog_button.dart';
import '../../constants/constants.dart';


class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  late TextEditingController _reasonController = TextEditingController();
  bool desNotNull = true;
  late String hintText = 'Để lại phản hồi ở đây';
  String contractDetailID = 'CTD012';


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
          AppBarWiget(title: 'Tạo Báo Cáo'),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          //Contract List
          Expanded(child: _CreateReport(),),
        ]),
      ),
    );
  }

  Widget _CreateReport(){
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Đây là trang báo cáo và bạn có bất cứ bất cập nào về dịch vụ chăm sóc của Thanh Hoa vui lòng nói cho chúng tôi biết', style: TextStyle(fontSize: 16,),),
            const SizedBox(height: 20,),
            Container(
              height: 200,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: desNotNull ? buttonColor : ErorText)
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.bottom,
                cursorColor: Colors.black,
                style: const TextStyle(
                    fontSize: 12, color: Colors.black),
                controller: _reasonController,
                decoration: InputDecoration(
                  border:  const OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: hintText,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: (){
                    if(_reasonController.text.isEmpty) {
                      setState(() {
                        desNotNull = false;
                        hintText = 'Không được để trống';
                      });
                    }
                    else {
                      if (_reasonController.text.length > 50) {
                        setState(() {
                          desNotNull = false;
                          hintText = 'Không được nhập quá 50 ký tự';
                          Fluttertoast.showToast(
                              msg: "Vui lòng nhập dưới 50 từ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        });
                      }
                      else {
                        setState(() {
                          desNotNull = true;
                          hintText = 'Để lại phản hồi ở đây';
                          createReport(_reasonController.text, contractDetailID);
                          Navigator.pop(context);
                        });
                      }
                    }

                  },
                  child: const ConfirmButton(title: 'Gửi báo cáo', width: 100.0,),),
              ],
            )
          ],
        ),),
    );
  }
}


