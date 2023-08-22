import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thanhhoa_garden_staff_app/utils/format/date.dart';
import '../../blocs/order/orderBloc.dart';
import '../../blocs/order/orderEvent.dart';
import '../../blocs/order/orderState.dart';
import '../../components/appBar.dart';
import '../../components/circular.dart';
import '../../components/notfication/notification_component.dart';
import '../../components/notfication/read_all_component.dart';
import '../../constants/constants.dart';
import '../../models/contract/contract.dart';
import '../../models/notification/notification.dart';
import '../../models/order/order.dart';
import '../../providers/contract/contract_provider.dart';
import '../../providers/notification/notification_provider.dart';
import '../contract/contractPageDetail.dart';
import '../order/orderDetail.dart';



class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

final ScrollController _scrollController = ScrollController();

class _NotificationPageState extends State<NotificationPage> {
 /* late OrderBloc orderBloc;
  late Stream<OrderState> orderStream;
  late OrderObject order;*/


  void initState() {
    /*orderBloc = Provider.of<OrderBloc>(context, listen: true);
    orderStream = orderBloc.authStateStream;*/
    // TODO: implement initState
    super.initState();
  }

/*  _getOrder(
      String id,
      ) {
    orderBloc.send(GetAnOrderEvent(
      order: order,
      id: id,
    ));
  }*/
/*
  @override
  void dispose() {
    orderBloc.dispose();
    // TODO: implement dispose
    super.dispose();
  }*/



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
        child: ReadALlComponent(title: 'đánh dâu đã đọc'))
      ],
    );
  }

}

