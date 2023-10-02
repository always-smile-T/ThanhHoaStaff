// ignore_for_file: must_be_immutable, file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../blocs/bonsai/bonsai_bloc.dart';
import '../../blocs/bonsai/bonsai_state.dart';
import '../../blocs/service/service_bloc.dart';
import '../../blocs/service/service_state.dart';
import '../../constants/constants.dart';
import '../../models/authentication/user.dart';
import '../../providers/authentication/authantication_provider.dart';
import '../../providers/store/my_store.dart';
import '../../screens/bonsai/searchScreen.dart';
import '../authentication/loginPage.dart';
import '../authentication/manaProfilePage.dart';
import '../contract/contractPage.dart';
import '../notification/notificationPage.dart';
import '../order/orderHistoryScreen.dart';
import '../schedule/schedulePage.dart';
import '../schedule/scheduleScreen.dart';
import '../service/servicePage.dart';
import '../webview.dart';


class HomePage extends StatefulWidget {
  User? user;
  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ServiceBloc serviceBloc;
  late BonsaiBloc bonsaiBloc;
  StreamSubscription<ServiceState>? _serviceStateSubscription;
  StreamSubscription<BonsaiState>? _bonsaiStateSubscription;
  late Stream<BonsaiState> bonsaiStream;
  late Stream<ServiceState> serviceStream;
  String storeName = '';
  String storeAddress = '';

  Future getStore() async {
    var myStore = await FetchInfoMyStore(widget.user!.storeID);
    setState(() {
      storeName = myStore.storeName.toString();
      storeAddress = myStore.address.toString();
    });
  }


  @override
  void initState() {
    super.initState();
    serviceBloc = Provider.of<ServiceBloc>(context, listen: false);
    bonsaiBloc = Provider.of<BonsaiBloc>(context, listen: false);

    bonsaiStream = bonsaiBloc.authStateStream;
    serviceStream = serviceBloc.authStateStream;
    getStore();
  }

  @override
  void didChangeDependencies() {
    _serviceStateSubscription?.cancel();
    _bonsaiStateSubscription?.cancel();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    serviceBloc.dispose();
    // bonsaiBloc.dispose();
    _serviceStateSubscription?.cancel();
    _bonsaiStateSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 200,),
            //Nghiep vu in Store List
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nghiệp Vụ Tại Cửa Hàng',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  const SizedBox(height: 20,),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchScreen(),
                        ));
                      },
                      child: _dashboardButton('Cây Cảnh')),
                  const SizedBox(height: 20,),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OrderHistoryScreen(),
                        ));
                      },
                      child: _dashboardButton('Đơn đã đặt')),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ServicePage(),
                      ));
                    },
                    child: _dashboardButton('Dịch vụ'),
                  ),
                ],
              ),
            ),
            Container(
              width: size.width,
              height: 10,
              color: divince,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nghiệp Vụ Chăm Sóc',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  /*const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ScheduleScreen(),
                      ));
                    },
                    child: _dashboardButton('Lich Chăm Sóc Cây - Hiếu'),
                  ),*/
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SchedulePage(staffID: widget.user!.userID, whereCall: 0,),
                      ));
                    },
                    child: _dashboardButton('Lich Chăm Sóc Cây'),
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ContractPage(),
                      ));
                    },
                    child: _dashboardButton('Hợp Đồng Liên Quan'),
                  ),
                ],
              ),
            ),
            Container(
              width: size.width,
              height: 10,
              color: divince,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Khác',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                     // AuthenticationProvider().logout();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                    },
                    child: _dashboardButton('Đổi Tài Khoản'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
        //Staff Profile
        Positioned(
            top: 0,
            child: Container(
                decoration: const BoxDecoration(
                    gradient: narBarBackgroud,
                   // color: barColor,
                    border: Border.symmetric(vertical: BorderSide.none, horizontal: BorderSide(width: 1))
                ),
                width: size.width,
                height: 200,
                child: Column(
                  children: [
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _appBarButton(const NotificationPage(),Icons.notifications_none),
                        /*const SizedBox(width: 10,),
                        _appBarButton( ManagerProfileScreen(user: widget.user!),Icons.settings),*/
                        const SizedBox(width: 20,),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        const SizedBox(width: 20,),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 3, color: Colors.white)),
                          width: 100,
                          height: 100,
                          child:
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(widget.user!.avatar),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.user!.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Tài Khoản:'),
                                    Text('Cửa hàng:'),
                                    Text('Địa chỉ:'),
                                  ],
                                ),
                                const SizedBox(width: 20,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Nhân viên'),
                                    Text(storeName),
                                    Text(storeAddress.toString().length >= 22 ? storeAddress.toString().substring(0,22) + "..." : storeAddress.toString()),
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                )
            )),
      ]),
    );
  }

  //Main Dashboard Button
  Widget _dashboardButton(String title){
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width - 80,
          height: 40,
          decoration: BoxDecoration(
            color: barColor,
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(15),
            gradient: tabBackground
          ),
          child: Text(title, style: const TextStyle(fontSize: 16),),
        ),
        const SizedBox(width: 20,),
        const Icon(Icons.chevron_right),
      ],
    );
  }

  // setting/ notify button
  Widget _appBarButton(page, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.transparent),
        child: Center(
            child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: darkText),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white),
                child: FaIcon(icon, size: 28, color: buttonColor))),
      ),
    );
  }

}
