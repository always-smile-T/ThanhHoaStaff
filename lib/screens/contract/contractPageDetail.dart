// ignore_for_file: must_be_immutable, file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:thanhhoa_garden_staff_app/components/button/dialog_button.dart';
import 'package:thanhhoa_garden_staff_app/models/contract/contractDetail/contract_detail.dart';
import 'package:thanhhoa_garden_staff_app/screens/contract/confirmContract.dart';
import '../../components/appBar.dart';
import '../../components/circular.dart';
import '../../components/note.dart';
import '../../constants/constants.dart';
import '../../models/contract/contract.dart';
import '../../providers/contract/contract_provider.dart';
import '../../providers/img_provider.dart';
import '../../utils/connection/utilsConnection.dart';
import '../../utils/format/date.dart';
import '../../utils/format/status.dart';
import '../schedule/workingDateScreen.dart';
import 'manaContractDetail.dart';

class ContractDetailPage extends StatefulWidget {
  ContractDetailPage({super.key,this.contract, required this.contractID});
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
  String reason = '';


  @override
  Widget build(BuildContext context) {
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
              child: _ServiceInfo()),
        ]),
      ),
    );
  }

  //Info Contract
  Widget _ContractInfo(contract){
    var size = MediaQuery.of(context).size;
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
                  _contractFiled('Ngày kết thúc',formatDatenoTime(contract.expectedEndedDate.toString())),
                  _contractFiled('Giá trị hợp đồng', '${f.format(contract.total)} đ'),
                  Row(
                    children: [
                      const Text('Trạng thái: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),),
                      Container(
                        width: 120,
                        height: 25,
                        decoration: BoxDecoration(
                          color: divince,
                          border: Border.all(width: 1)
                        ),
                          child: Center(child: Text(formatStatus(contract.status.toString()), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: formatColorStatus(contract.status.toString())),))),
                      const SizedBox(width: 10,),
                      (contract.status.toString() == 'CONFIRMING') ? GestureDetector(
                           onTap: (){
                             (contract.status.toString() == 'CONFIRMING') ? showdialogConfirm(formatCheckContract(contract.status.toString()), contract.status.toString(), contract.id, contract.showStaffModel!.id) : null;
                      }, child: Text(formatContractStatus(contract.status.toString()),
                        style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold, fontSize: 16,),)) : const SizedBox(),
                    ],
                  )
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
                  return selectedTab == 0 ? _ContractInfo(cDetail[0].showContractModel!) : ListView.builder(
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
                                    Text(cDetail.length > 1 ? "Thông tin dịch vụ ${index + 1}" : "Thông tin dịch vụ", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: buttonColor),),
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
                                              _contractFiled(cDetail[index].showServiceModel!.id == 'SE003' ? 'Diện tích vườn' : 'Chiều cao cây', cDetail[index].showServiceTypeModel!.typeSize.toString() + ' ' + cDetail[index].showServiceTypeModel!.typeUnit.toString()),
                                              //_contractFiledColor('Mô tả', cDetail[index].showServiceModel!.description.toString(), HintIcon),
                                              _contractFiled('Lịch chăm sóc',cDetail[index].timeWorking.toString()),
                                              _contractFiled('Ngày bắt đầu',formatDatenoTime(cDetail[index].startDate.toString())),
                                              _contractFiled('Ngày kết thúc',formatDatenoTime(cDetail[index].expectedEndDate.toString())),
                                              _contractFiled('Thời hạn dịch vụ', cDetail[index].showServicePackModel!.packRange.toString() + ' ' + cDetail[index].showServicePackModel!.packUnit.toString() ),
                                              _contractFiledColor('Chiết khấu', cDetail[index].showServicePackModel!.packRange.toString() + ' (%)' , highLightText),
                                              cDetail[index].plantStatus != null ? _contractFiled('Tình trạng cây trước dịch vụ', cDetail[index].plantStatus.toString()) : const SizedBox(),
                                              cDetail[index].plantStatusIMGModelList!.isNotEmpty ? Container(
                                                  decoration: BoxDecoration(
                                                    //shape: BoxShape.circle,
                                                      border: Border.all(
                                                          width: 3, color: Colors.white)),
                                                  width: 120,
                                                  height: 120,
                                                  child: Image.network( cDetail[index].plantStatusIMGModelList!.isEmpty ? getImageNoAvailableURL : cDetail[index].plantStatusIMGModelList![0].imgUrl.toString(), fit: BoxFit.fill,)
                                              ) : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      (cDetail[index].showContractModel!.status == "CONFIRMING") ? Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              cDetail[index].plantStatusIMGModelList!.isEmpty ? Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => ManaContractDetail(contractID: cDetail[index].showContractModel!.id, workingDate: cDetail[index].timeWorking, des: cDetail[index].note, contractDetailID: cDetail[index].id,
                                                  startDate: cDetail[index].startDate, endDate: cDetail[index].expectedEndDate, servicePackID: cDetail[index].showServicePackModel!.id, serviceTypeID: cDetail[index].showServiceTypeModel!.id,
                                                  serviceID: cDetail[index].showServiceModel!.id,price: cDetail[index].price, isUpdate: 0, serviceType: cDetail[index].showServiceTypeModel),
                                              )):  Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => ManaContractDetail(contractID: cDetail[index].showContractModel!.id, workingDate: cDetail[index].timeWorking, des: cDetail[index].note, contractDetailID: cDetail[index].id,
                                                startDate: cDetail[index].startDate, endDate: cDetail[index].expectedEndDate, servicePackID: cDetail[index].showServicePackModel!.id, serviceTypeID: cDetail[index].showServiceTypeModel!.id,
                                                 serviceID: cDetail[index].showServiceModel!.id,price: cDetail[index].price, plantStatus: cDetail[index].plantStatus!,
                                                plantIMG: cDetail[index].plantStatusIMGModelList![0].imgUrl!, isUpdate: 1, serviceType: cDetail[index].showServiceTypeModel),
                                              ));
                                            },
                                            child: const ConfirmButton(title: 'Chỉnh sửa', width: 120.0),
                                          ),
                                          const SizedBox(width: 10,)
                                        ],
                                      ) : (checkContractStatus(cDetail[index].showContractModel!.status)) ? Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => WorkingDateFollowContractPage(contractDetailID: cDetail[index].id),
                                              ));
                                            },
                                            child: ConfirmButton(title: 'Xem lịch', width: 120.0),
                                          ),
                                          const SizedBox(width: 10,)
                                        ],
                                      ): const SizedBox(),
                                      const SizedBox(height: 10,)
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

  dynamic showdialogConfirm(title, status, id, staffID) {
    var size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          status == 'CONFIRMING' ? _pickImage(ImageSource.gallery) : null;
          return AlertDialog(
            title: Center(
              child: Text(
                'Xác Nhận ' + title,
                style: const TextStyle(color: buttonColor, fontSize: 25),
              ),
            ),
            actions: [
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.center,
                      width: 110,
                      height: 45,
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text('Quay lại',
                          style: TextStyle(
                              color: lightText,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      /*if(status == "APPROVED"){
                        Navigator.of(context).pop();
                        setState(() {
                          addContractIMG(id, imgURL.last);
                          changeContractStatus(id, 'CONFIRMING', null, staffID);
                        });
                      }*/
                      if(status == "CONFIRMING"){
                        Navigator.of(context).pop();
                        setState(() {
                          addContractIMG(id, imgURL.last);
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ContractDetailPage(contractID: widget.contractID),
                          ));
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 110,
                      height: 45,
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text('Xác nhận',
                          style: TextStyle(
                              color: lightText,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          );
        });
  }

  List<String> imgURL = [];
  List<File> listFile = [];

  Future _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    // final image = await ImagePicker().pickMedia();
    if (image == null) return;
    File? img = File(image.path);
    OverlayLoadingProgress.start(context);
    ImgProvider().upload(img).then((value) {
      setState(() {
        imgURL.add(value);
        listFile.add(img);
      });
      OverlayLoadingProgress.stop();
    });

    // ImgProvider().upload(img);
  }

  dynamic showdialogConfirmReason(contractDetailID) {
    // var phone = widget.phone;
    var size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: Text(
                'Chỉnh Sửa Dịch Vụ',
                style: TextStyle(color: buttonColor, fontSize: 25),
              ),
            ),
            content: SizedBox(
                height: 170,
                width: size.width - 10,
                child: ConfirmCancelOrder(
                  callback: setReason,
                  orrderID: contractDetailID,
                )),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.center,
                      width: 110,
                      height: 45,
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text('Huỷ',
                          style: TextStyle(
                              color: lightText,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: 110,
                      height: 45,
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text('Lưu',
                          style: TextStyle(
                              color: lightText,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          );
        });
  }
  setReason(String value) {
    setState(() {
      reason = value;
    });
  }

  List<String> TabCategory = ['Thông tin hợp đồng', 'Chi Tiết Dịch vụ'];

}
