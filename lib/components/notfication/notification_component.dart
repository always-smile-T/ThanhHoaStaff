


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/constants.dart';
import '../../models/contract/contract.dart';
import '../../models/notification/notification.dart';
import '../../providers/contract/contract_provider.dart';
import '../../providers/notification/notification_provider.dart';
import '../../screens/contract/contractPageDetail.dart';
import '../../utils/format/date.dart';

class NotificationComponent extends StatefulWidget {
  const NotificationComponent({Key? key, required this.noty}) : super(key: key);
  final noty;

  @override
  State<NotificationComponent> createState() => _NotificationComponentState();
}

class _NotificationComponentState extends State<NotificationComponent> {
  String? location = '';
  String? locationID = '';

  @override
  Widget build(BuildContext context) {
    Noty noty = widget.noty;
    return GestureDetector(
      onTap: () async{
        location = getLocation(noty.link!.toString());
        locationID = getLocationID(noty.link!.toString());
        if(noty.isRead == false){
          readOneNoty(noty.id);
        }
        if(location == 'CONTRACT'){
          Contract contract = await fetchAContract(locationID);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ContractDetailPage(contractID: locationID, contract: contract),
          ));
        }
        else if(location  == 'ORDER'){
          Fluttertoast.showToast(
              msg: "Hiện bạn không thể xem thông báo này",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: buttonColor,
              textColor: Colors.white,
              fontSize: 16.0);
          /*OrderObject order = (await fetchAContract(locationID)) as OrderObject;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailScreen(order: order),
                                ));*/
        } if (location == null) {
          Fluttertoast.showToast(
              msg: "Hiện bạn không thể xem thông báo này",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: buttonColor,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      child: confirmButton(noty),
    );
  }


  Widget confirmButton(noty){
    return Container(
      padding: const EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
          color: noty.isRead == false ? barColor : background,
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
                  Text(noty.title.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  Text(noty.description.toString().length >= 50 ? '${noty.description.toString().substring(0,47)}...': "${noty.description}", style: TextStyle(fontSize: 12),),
                ],
              )
            ],
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Text(formatDate(noty.date.toString())))
        ],
      ),
    );
  }
}


String? getLocation(data) {
  int endIndex = data.indexOf("-");

  if (endIndex >= 0) {
    String result = data.substring(0, endIndex);
    return result; // Kết quả: CONTRACT
  } else {
    print("Không tìm thấy chuỗi phù hợp");
  }
}
String? getLocationID(data) {
  int endIndex = data.indexOf("-");

  if (endIndex >= 0) {
    String result = data.substring(endIndex + 1, data.toString().length);
    return result;// Kết quả: CONTRACT
  } else {
    print("Không tìm thấy chuỗi phù hợp");
  }
}
