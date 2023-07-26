import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../components/appBar.dart';
import '../../constants/constants.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
          //App Bar
          AppBarWiget(title: 'Thông báo'),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          //Noti Field
          Expanded(child: Column(
            children: [
              _listNoti('Bạn có một đánh giá mới','19:00 03/07/2023',false),
              _listNoti('Bạn nhận được một báo cáo','20:00 02/07/2023',true),
              _listNoti('Bạn nhận được 1 hợp đồng mới','09:00 01/07/2023',false),
              _listNoti('Hôm nay có lịch chăm sóc cây, đừng quên!','07:00 20/06/2023',false),
              _listNoti('Hôm nay có lịch chăm sóc cây, đừng quên!','07:00 27/06/2023',true),
            ],
          )),
        ]),
      ),
    );
  }

  //noti Component
  Widget _listNoti(des, time, isClick){
    return Container(
      padding: const EdgeInsets.all(10),
      height: 80,
      decoration: BoxDecoration(
          color: isClick ? barColor : notiColor,
        border: Border.all(width: 1, color: divince)
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 3, color: Colors.white)),
                width: 70,
                height: 70,
                child:
                const CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage('assets/Logo.png'),
                ),
              ),
              const SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(des),
                  const SizedBox(width: 5,),
                  const Text('đến xem')
                ],
              )
            ],
          ),
          Positioned(
            bottom: 0,
              right: 0,
              child: Text(time))
        ],
      ),
    );
  }
}
