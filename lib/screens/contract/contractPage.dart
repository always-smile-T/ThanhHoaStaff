// ignore_for_file: must_be_immutable, file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:popup_banner/popup_banner.dart';
import 'package:thanhhoa_garden_staff_app/components/circular.dart';
import 'package:thanhhoa_garden_staff_app/providers/contract/contract_provider.dart';
import 'package:thanhhoa_garden_staff_app/utils/format/status.dart';
import '../../components/appBar.dart';
import '../../constants/constants.dart';
import '../../models/contract/contract.dart';
import '../../utils/connection/utilsConnection.dart';
import '../../utils/format/date.dart';
import 'contractPageDetail.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({super.key});

  @override
  State<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  var f = NumberFormat("###,###,###", "en_US");
  var selectedTab = 0;
  int pageNo = 0;
  int PageSize = 50;
  bool statusContract = true;


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
          AppBarWiget(title: 'Hợp đồng', tail: filterContract(),),
          const SizedBox(
            height: 5,
          ),
          Center(
            child: Container(
              height: 1,
              width: 250,
              decoration: const BoxDecoration(color: buttonColor),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          //Category list
          SizedBox(
            height: 50,
            width: size.width,
            child: _listCategory(),
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          //Contract List
          Expanded(child: _listContract(),),
        ]),
      ),
    );
  }
  //List Contract
  Widget _listContract(){
    var size = MediaQuery.of(context).size;
    return FutureBuilder<List<Contract>>(
      //fetch follow ID (sort), pageNo == 0, pageSize == 10.
      future: statusContract ? fetchContract(pageNo, PageSize, 'STATUS',true) : fetchContract(pageNo, PageSize, 'ID',true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Circular();
        }
        if (snapshot.hasData) {
          List<Contract> contract = snapshot.data!;
          if (snapshot.data == null) {
            return const Center(
              child: Text(
                'Không có kết quả để hiển thị',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          } else {
            print("contract.length: " + contract.length.toString());
            return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                //scrollDirection: Axis.horizontal,
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: contract.length,
                itemBuilder: (BuildContext context, int index){
                  bool isConfirming = false;
                  if(contract[index].status == "CONFIRMING"){
                    isConfirming = true;
                  }
                  return ((contract[index].status == 'WORKING' && selectedTab == 3) ||
                      ((contract[index].status == 'DENIED' || (contract[index].status == 'CUSTOMERCANCELED')) && selectedTab == 5) ||
                      (contract[index].status == 'SIGNED' && selectedTab == 2) ||
                      (contract[index].status == 'DONE' && selectedTab == 4) ||
                      (contract[index].status == 'CONFIRMING' && selectedTab == 1) ||(selectedTab == 0)
                  ) ? GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ContractDetailPage(contractID: contract[index].id),
                      ));
                    },
                    child: Container(height: 180,
                      width: size.width - 200,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          //color: barColor,
                          gradient: tabBackground,
                          border: Border.all(width: 1, color: buttonColor),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Image of Contract
                                  GestureDetector(
                                    onTap: () {
                                      PopupBanner(
                                        useDots: false,
                                        fit: BoxFit.fitWidth,
                                        height: size.height - 150,
                                        context: context,
                                        images: [contract[index].imgList!.isNotEmpty ? contract[index].imgList![0].imgUrl.toString() : NoIMG],
                                        autoSlide: false,
                                        dotsAlignment: Alignment.bottomCenter,
                                        dotsColorActive: buttonColor,
                                        dotsColorInactive:
                                        Colors.grey.withOpacity(0.5),
                                        onClick: (index) {},
                                      ).show();
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          //shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1, color: Colors.black)),
                                        width: 80,
                                        height: 100,
                                        child: contract[index].imgList != null ? Image.network(contract[index].imgList!.length == 0 ? getImageNoAvailableURL : contract[index].imgList![0].imgUrl.toString(), fit: BoxFit.fill,) : Image.network(getImageNoAvailableURL, fit: BoxFit.fill)
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  _contractFiled('ID',contract[index].id.toString()),
                                ],
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              /*Container(
                                width: 1,
                                height: 110,
                                decoration: const BoxDecoration(color: Colors.black54),
                              ),*/
                              const SizedBox(
                                width: 7,
                              ),
                              // Basic Info about Contract
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text((contract[index].title.toString().length >= 25) ? contract[index].title.toString().substring(0,22) + "..." : contract[index].title.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _contractFiled('Khách hàng',contract[index].fullName.toString().length >= 25 ? (contract[index].fullName.toString().substring(0,22) + "...") : contract[index].fullName.toString()),
                                      _contractFiled('Ngày bắt đầu',formatDatenoTime(contract[index].startedDate.toString())),
                                      _contractFiled('Ngày kết thúc',formatDatenoTime(contract[index].expectedEndedDate.toString())),
                                      _contractFiledColor('Giá trị hợp đồng','${f.format(contract[index].total)} đ', Colors.deepOrange),
                                      _contractFiledColor('Trạng thái', formatStatus(contract[index].status.toString()), formatColorStatus(contract[index].status.toString())),
                                      _contractFiled('Địa chỉ',contract[index].address.toString().length >= 25 ? (contract[index].address.toString().substring(0,22) + "...") : contract[index].address.toString()),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Positioned(
                            bottom: 5,
                            right: 5,
                            child: Icon(Icons.chevron_right_outlined, color: buttonColor,),),
                        ],
                      ),
                    ),
                  ) : const SizedBox();
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
                // _searchPlant(0, PageSize, 'ID', true, null, cateID, null, null);
              },
              child: Container(
                alignment: Alignment.center,
                width: 100,
                height: 30,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: (selectedTab == index) ? buttonColor : barColor,
                    borderRadius: BorderRadius.circular(50)),
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: AutoSizeText(filter[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: (selectedTab == index) ? lightText : HintIcon),
                ),)
          );
        },
        itemCount: 6);
  }

  //Field in Contract
  Widget _contractFiled(String title, String des) {
    return Column(
      children: [
        RichText(
            text: TextSpan(children: [
              TextSpan(
                text: title + ': ',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),),
              TextSpan(
                text: des,
                style: const TextStyle(fontSize: 12, color: Colors.black),),
            ])),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _contractFiledColor(String title, String des, color) {
    return Column(
      children: [
        RichText(
            text: TextSpan(children: [
              TextSpan(
                text: title + ': ',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),),
              TextSpan(
                text: des,
                style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w600),),
            ])),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  filterContract(){
    return GestureDetector(
      onTap: (){
        setState(() {
          statusContract = !statusContract;
        });
      },
      child: const Icon(Icons.filter_alt_outlined, color: buttonColor, size: 30,),
    );
  }

  //List category
  List filter = [
    'Tất cả',
    'Đang xét duyệt',
    'Đã Ký',
    'Đang hoạt động',
    'Hoàn Thành',
    'Đã huỷ'
  ];

}
