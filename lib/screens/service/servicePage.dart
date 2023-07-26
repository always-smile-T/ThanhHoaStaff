// ignore_for_file: must_be_immutable, file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../blocs/bonsai/cart/cart_state.dart';
import '../../blocs/service/service_bloc.dart';
import '../../blocs/service/service_event.dart';
import '../../blocs/service/service_state.dart';
import '../../components/appBar.dart';
import '../../constants/constants.dart';
import '../../screens/service/serviceDetail.dart';
import '../../models/service/service.dart';
class ServicePage extends StatefulWidget {
  StreamSubscription<CartState>? cartStateSubscription;
  Stream<CartState>? cartStream;
  ServicePage({super.key, this.cartStateSubscription, this.cartStream});


  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {

  late ServiceBloc serviceBloc;

  StreamSubscription<ServiceState>? _serviceStateSubscription;


  late Stream<ServiceState> serviceStream;

  @override
  void initState() {
    super.initState();
    serviceBloc = Provider.of<ServiceBloc>(context, listen: false);
    serviceStream = serviceBloc.authStateStream;
    serviceBloc.send(GetAllServiceEvent());
  }

  @override
  void didChangeDependencies() {
    _serviceStateSubscription?.cancel();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    serviceBloc.dispose();
    _serviceStateSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            const SizedBox(
              height: 35,
            ),
            //search Bar
            AppBarWiget(title: 'Tất Cả Dịch Vụ'),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 10,
              decoration: const BoxDecoration(color: divince),
            ),
            SizedBox(
                height: size.height - 100,
                child: Column(
                  children: [
                    StreamBuilder<ServiceState>(
                      stream: serviceStream,
                      //initialData: ServiceInitial(),
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        if (state is ServiceLoading) {
                          return const Expanded(
                              child:
                              Center(child: CircularProgressIndicator()));
                        } else if (state is ListServiceSuccess) {
                          return Expanded(
                              child: state.listService == null
                                  ? Container()
                                  : _listService(state.listService));
                        } else if (state is ServiceFailure) {
                          return Text(state.errorMessage);
                        } else {
                          return const Center(
                            child: Text('Load faild'),
                          );
                        }
                      },
                    ),
                  ],
                )),
            //Bonsai List
          ]),
        ),
      ),
    );
  }

  Widget _listService(List<Service>? listService) {
    var size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: listService!.length,
          itemBuilder: (context, index) {
            return Container(
                width: 130,
                height: 145,
                alignment: Alignment.center,
                child: _serviceTab(listService[index], icons[index]));
          },
        ));
  }
  Widget _serviceTab(Service? service, IconData icon) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ServiceDetail(service: service),
        ));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: tabBackground,
            border: Border.all(width: 1)
        ),
        child: Stack(
          children: [
            Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 80,
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: darkText),
                            borderRadius: BorderRadius.circular(50),
                            color: barColor),
                        child: FaIcon(icon, size: 35, color: buttonColor)),
                    const SizedBox(width: 20,),
                    AutoSizeText(
                      service!.name,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                      maxFontSize: 30,
                    ),
                  ],
                )),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                height: 35,
                width: 70,
                decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(45)
                ),
                child: const Center(child: Text('Chi tiết', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),)),
              ),)
          ],
        ),
      ),
    );
  }
  List<IconData> icons = [
    FontAwesomeIcons.leaf,
    FontAwesomeIcons.plantWilt,
    FontAwesomeIcons.sunPlantWilt,
  ];
}
