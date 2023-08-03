// ignore_for_file: must_be_immutable, file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thanhhoa_garden_staff_app/models/contract/contractDetail/contract_detail.dart';
import '../../components/appBar.dart';
import '../../components/circular.dart';
import '../../constants/constants.dart';
import '../../models/contract/contract.dart';
import '../../providers/contract/contract_provider.dart';
import '../../utils/format/date.dart';
import '../../utils/format/status.dart';

class ContractDetailPage extends StatefulWidget {
  ContractDetailPage({super.key, required this.contractID, required this.contract});
  String? contractID;
  final contract;
  @override
  State<ContractDetailPage> createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  final ScrollController _scrollController = ScrollController();
  var selectedTab = 0;
  int pageNo = 0;
  int PageSize = 10;
  List<ContractDetail> listContract = [];


  @override
  Widget build(BuildContext context) {
    Contract contract = widget.contract;
    var size = MediaQuery.of(context).size;
    var f = NumberFormat("###,###,###", "en_US");
    return Scaffold(
      backgroundColor: background,
      body: Container(
        /*decoration: const BoxDecoration(
          gradient: tabBackground,
        ),*/
        height: size.height,
        child: Column(children: [
          const SizedBox(
            height: 35,
          ),
          //search Bar
          AppBarWiget(title: 'Chi Tiết Hợp Đồng'),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          SizedBox(
            height: 50,
            width: size.width,
            child: _listCategory(),
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          Expanded(
              child: selectedTab == 0 ? _ContractInfo() : _ServiceInfo()),
        ]),
      ),
    );
  }

  //Info Contract
  Widget _ContractInfo(){
    var size = MediaQuery.of(context).size;
    Contract contract = widget.contract;
    var f = NumberFormat("###,###,###", "en_US");
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: size.width,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  const Text("Thông tin hợp đồng", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: buttonColor),),
                  const SizedBox(height: 10,),
                  _contractFiled('ID hợp đồng', contract.id.toString()),
                  _contractFiled('Tên hợp đồng',contract.title.toString()),
                  _contractFiled('Ngày Bắt Đầu',formatDatenoTime(contract.startedDate.toString())),
                  _contractFiled('Ngày kết thúc',formatDatenoTime(contract.endedDate.toString())),
                  _contractFiled('Tình trạng', contract.status.toString()),
                  _contractFiled('Giá trị hợp đồng', '${f.format(contract.total)} đ'),
                  _contractFiled('Đã cọc', '${f.format(contract.deposit)} đ'), ////
                  _contractFiled('Trạng thái', formatStatus(contract.status.toString())),
                ],
              ),
            ),
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          // Info Of The Cus Who Use The Contract
          Container(
            width: size.width,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  const Text("Thông tin khách hàng sử dụng", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: buttonColor),),
                  const SizedBox(height: 10,),
                  _contractFiled('Tên khách hàng',contract.fullName.toString()),
                  _contractFiled('Địa chỉ',contract.address.toString().length >= 50 ? contract.address.toString().substring(0,50) + "..." : contract.address.toString()),
                  _contractFiled('Số điện thoại',contract.phone.toString()),
                  _contractFiled('email', contract.email.toString()),
                ],
              ),
            ),
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          //Info Of The Cus Who Pay The Contract
          Container(
            /*decoration: const BoxDecoration(
                        gradient: tabBackground,
                      ),*/
            width: size.width,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  const Text("Thông tin khách hàng ký kết", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: buttonColor),),
                  const SizedBox(height: 10,),
                  _contractFiled('ID khách hàng', contract.showCustomerModel!.id.toString()),
                  _contractFiled('Tên khách hàng',contract.showCustomerModel!.fullName.toString()),
                  _contractFiled('Địa chỉ',contract.showCustomerModel!.address.toString().length >= 50 ? contract.address.toString().substring(0,50) + "..." : contract.address.toString()),
                  _contractFiled('Số điện thoại',contract.showCustomerModel!.phone.toString()),
                  _contractFiled('email', contract.showCustomerModel!.email.toString()),
                ],
              ),
            ),
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
        ],
      ),
    );
  }

  //Info Service
  Widget _ServiceInfo (){
    var size = MediaQuery.of(context).size;
    Contract contract = widget.contract;
    var f = NumberFormat("###,###,###", "en_US");
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<List<ContractDetail>>(
            future: fetchContractDetailByID(widget.contractID, pageNo, 10),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Circular();
              }
              if (snapshot.hasData) {
                List<ContractDetail> cDetail = snapshot.data!;
                if (cDetail.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không có kết quả để hiển thị',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                } else {
                  return ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: cDetail.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Card(
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
                                    Text(cDetail.length > 1 ? "Thông tin dịch vụ ${index + 1}" : "Thông tin dịch vụ", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                                    const SizedBox(height: 5,),
                                    _contractFiled('ID dịch vụ', cDetail[index].showServiceModel!.id.toString()),
                                    _contractFiled('ID hoá đơn dịch vụ',cDetail[index].id.toString()),
                                    _contractFiled('Tên dịch vụ', cDetail[index].showServiceModel!.name.toString()),
                                    _contractFiled('Lưu ý', cDetail[index].note.toString()),
                                  ],
                                ),
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width,
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                                          padding: const EdgeInsets.only(left: 10, right: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _contractFiled(cDetail[index].showServiceModel!.id == 'SE003' ? 'Diện tích vườn' : 'Chiều cao cây', cDetail[index].showServiceTypeModel!.typeName.toString()),
                                              _contractFiled('Mô tả', cDetail[index].showServiceModel!.description.toString()),
                                              _contractFiled('Lịch chăm sóc',cDetail[index].timeWorking.toString()),
                                              _contractFiled('Ngày bắt đầu',formatDatenoTime(cDetail[index].startDate.toString())),
                                              _contractFiled('Ngày kết thúc',formatDatenoTime(cDetail[index].endDate.toString())),
                                              _contractFiled('Thời hạn dịch vụ', cDetail[index].showServicePackModel!.packRange.toString()),
                                              _contractFiled('Chiết khấu(%)', cDetail[index].showServicePackModel!.packPercentage.toString()),
                                              _contractFiled('Giá',f.format(cDetail[index].showServiceModel!.price)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                  );
                }
              }
              return Center(
                child: Text(fetchContractDetailByID(widget.contractID, pageNo, 10).toString()),
              );
            },
          ),
        ],
      ),
    );
}


  //Contract Detail Main Field
  Widget _contractFiled(String title, String des) {
    return Column(
      children: [
        RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: title + ': ',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),),
              TextSpan(
                  text: des,
                  style: const TextStyle(fontSize: 14, color: Colors.black),),
            ])),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

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
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width /2,
                height: 30,
                // padding: const EdgeInsets.all(5),
                decoration:  BoxDecoration(
                    color: (selectedTab == index) ? buttonColor : Colors.white),
                //margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: AutoSizeText(TabCategory[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: (selectedTab == index) ? lightText : HintIcon),
                ),)
          );
        },
        itemCount: 2);
  }

  List<String> TabCategory = ['Thông tin hợp đồng', 'Chi Tiết Dịch vụ'];

}
