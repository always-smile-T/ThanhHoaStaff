import 'package:flutter/material.dart';
import '../../components/appBar.dart';
import '../../components/circular.dart';
import '../../components/notfication/notification_component.dart';
import '../../components/notfication/read_all_component.dart';
import '../../constants/constants.dart';
import '../../models/notification/notification.dart';
import '../../providers/notification/notification_provider.dart';



class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

final ScrollController _scrollController = ScrollController();

class _NotificationPageState extends State<NotificationPage> {


  void initState() {
    // TODO: implement initState
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
          //App Bar
          AppBarWiget(title: 'Thông báo'),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          Expanded(child: _listNoti()),
        ]),
      ),
    );
  }

  Widget _listNoti(){
    return Stack(
      children: [
        FutureBuilder<List<Noty>>(
          future: fetchNotification(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Circular();
            }
            if (snapshot.hasData) {
              List<Noty> noty = snapshot.data!;
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
                    itemCount: noty.length,
                    itemBuilder: (BuildContext context, int index){
                      return NotificationComponent(noty: noty[index]);
                    }
                );
              }
            }
            return const Center(
              child: Text('Error'),
            );
          },
        ),
    Positioned(
        right: MediaQuery.of(context).size.width / 2 - 70,
      bottom: 10,
        child: GestureDetector(
          onTap: (){
            readAllNoty();
            setState(() {
              Navigator.of(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationPage(),
                  ));
            });
          },
            child: const ReadALlComponent(title: 'đánh dấu đã đọc')))
      ],
    );
  }

}

