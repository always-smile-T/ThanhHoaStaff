// ignore_for_file: must_be_immutable, file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:popup_banner/popup_banner.dart';
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
import '../../test/manaTest.dart';
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
  int countImage = 0;
  int countDate = 0;
  bool canCheckImage = false;
  bool canCheckDate = true;
  String day = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString();
  TextEditingController _reasonController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var f = NumberFormat("###,###,###", "en_US");
    return Scaffold(
      backgroundColor: background,
      body: Container(
        width: size.width,
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
  Widget _ContractInfo(contract, cDetail){
    var size = MediaQuery.of(context).size;
    var f = NumberFormat("###,###,###", "en_US");
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            /*decoration: const BoxDecoration(
              gradient: infoBackground
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Thông tin hợp đồng", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: buttonColor),),
                      contract.status == 'CONFIRMING' ? GestureDetector(
                        onTap: (){
                          showdialogConfirm('huỷ hợp đồng', 0, contract.id, contract.showStaffModel!.id);
                        },
                        child: const Icon(Icons.delete_forever_outlined, color: buttonColor, size: 30),
                      ) : const SizedBox()
                    ],
                  ),
                  const SizedBox(height: 10,),
                  _contractFiled('ID hợp đồng', contract.id.toString()),
                  _contractFiled('Tên hợp đồng',contract.title.toString()),
                  _contractFiled('Ngày Bắt Đầu',formatDatenoTime(contract.startedDate.toString())),
                  _contractFiled('Ngày kết thúc',formatDatenoTime(contract.expectedEndedDate.toString())),
                  _contractFiledColor('Giá trị hợp đồng', '${f.format(contract.total)} đ', Colors.deepOrange),
                  Row(
                    children: [
                      const Text('Trạng thái: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),),
                      Container(
                        width: 120,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1)
                        ),
                          child: Center(child:Text(
                            formatStatus(contract.status.toString()),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: formatColorStatus(contract.status.toString()),
                            ),
                          ),
                          /*Text(
                            formatStatus(contract.status.toString()),
                            style: TextStyle(fontSize: 16,
                                fontWeight: FontWeight.bold,

                                color: formatColorStatus(contract.status.toString())),)*/)),
                      const SizedBox(width: 30,),
                      (contract.status.toString() == 'CONFIRMING' && imgURL.isEmpty) ? GestureDetector(
                           onTap: (){
                             (canCheckImage && canCheckDate) ? _pickImage(ImageSource.gallery)
                                 : Fluttertoast.showToast(
                                 msg: (canCheckImage && !canCheckDate) ? "Có dịch vụ quá hạn" :
                                 (!canCheckImage && canCheckDate) ? "Có dịch vụ chưa cập nhật" : "Có dịch vụ chưa cập nhật và quá hạn",
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.BOTTOM,
                                 timeInSecForIosWeb: 1,
                                 backgroundColor: ErorText,
                                 textColor: Colors.white,
                                 fontSize: 16.0);
                      }, child: const ConfirmButton(title: 'Hình hợp đồng', width: 100.0)) :
                      (contract.status.toString() == 'CONFIRMING' && imgURL.isNotEmpty)
                          ? GestureDetector(
                          onTap: (){
                            (canCheckImage) ? showdialogConfirm(formatCheckContract(contract.status.toString()), 1, contract.id, contract.showStaffModel!.id)
                                : Fluttertoast.showToast(
                                msg: "Có dịch vụ chưa cập nhật",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: ErorText,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }, child: const ConfirmButton(title: 'Ký hợp đồng', width: 100.0)) : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  imgURL.isNotEmpty ? GestureDetector(
                    onTap: () {
                      PopupBanner(
                        useDots: false,
                        fit: BoxFit.fitWidth,
                        height: size.height - 150,
                        context: context,
                        images: [imgURL.last.toString()],
                        autoSlide: false,
                        dotsAlignment: Alignment.bottomCenter,
                        dotsColorActive: buttonColor,
                        dotsColorInactive:
                        Colors.grey.withOpacity(0.5),
                        onClick: (index) {},
                      ).show();
                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  //shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 3, color: Colors.white)),
                                width: 120,
                                height: 120,
                                child: Image.network(imgURL.last.toString(), fit: BoxFit.fill,)
                            ),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: (){
                                  setState(() {
                                    //imgURL.removeLast();
                                    imgURL.clear();
                                    listFile.clear();
                                    // listFile[index].delete(recursive: listFile[index]);
                                  });
                                },
                                icon: Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white
                                    ),
                                    width: 30,
                                    height: 30,
                                    child: const Icon(Icons.cancel_outlined, color: buttonColor, size: 30,)),
                              ))
                        ],
                      ),
                    ),
                  ) : const SizedBox(),
                ],
              ),
            ),
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          (contract.status == 'DONE' || contract.status == 'WORKING' || contract.status == 'SIGNED') ?
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //const SizedBox(height: 10,),
                    const Text("Hình ảnh hợp đồng", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: buttonColor),),
                    //const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () {
                        PopupBanner(
                          useDots: false,
                          fit: BoxFit.fitWidth,
                          height: size.height - 150,
                          context: context,
                          images: [contract.imgList.length != 0 ? contract.imgList[0].imgUrl.toString() : NoIMG],
                          autoSlide: false,
                          dotsAlignment: Alignment.bottomCenter,
                          dotsColorActive: buttonColor,
                          dotsColorInactive:
                          Colors.grey.withOpacity(0.5),
                          onClick: (index) {},
                        ).show();
                      },
                      child: Container(
                          /*decoration: BoxDecoration(
                            //shape: BoxShape.circle,
                              border: Border.all(
                                  width: 3, color: Colors.white)),*/
                          width: 30,
                          height: 30,
                          child: const Icon(Icons.image_outlined, color: buttonColor, size: 30.0,)/*Image.network(contract.imgList[0].imgUrl.toString(), fit: BoxFit.fill,)*/
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 10,
                decoration: const BoxDecoration(color: divince),
              ),
            ],
          ) : const SizedBox(),
          // Info Of The Cus Who Use The Contract
          Container(
            width: size.width,
            /*decoration: const BoxDecoration(
                gradient: infoBackground
            ),*/
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          //Info Of The Cus Who Pay The Contract
          Container(
            width: size.width,
            /*decoration: const BoxDecoration(
                gradient: infoBackground
            ),*/
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          (contract.status == 'DONE' || contract.status == 'WORKING') ?
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //const SizedBox(height: 10,),
                    const Text("Lịch làm việc", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: buttonColor),),
                    //const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => WorkingDateFollowContractPage(contractDetailID: cDetail[0].id, contractID: contract.id, whereCall: false, staffID : contract.showStaffModel!.id),
                        ));
                      },
                      child: const SizedBox(
                          width: 30,
                          height: 30,
                          child: Icon(Icons.edit_calendar, color: buttonColor, size: 30.0,)/*Image.network(contract.imgList[0].imgUrl.toString(), fit: BoxFit.fill,)*/
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 10,
                decoration: const BoxDecoration(color: divince),
              ),
            ],
          ) : const SizedBox(),
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
                for(int i = 0; i <= cDetail.length - 1 ; i++){
                  DateTime startDate = DateTime.parse(cDetail[i].startDate!.toString().substring(0,10));
                  DateTime today = DateTime.parse(day);
                  //DateTime startDate = today;
                 if (cDetail[i].plantStatusIMGModelList!.isNotEmpty){
                   countImage = countImage + 1;
                  }
                 if (today.isAfter(startDate.add(const Duration(days: 0))) && cDetail[i].showContractModel!.status.toString() == 'CONFIRMING'){
                   countDate = countDate + 1;
                  }
                 if(countImage == cDetail.length){
                   canCheckImage = true;
                 }
                 if(countDate >= 1){
                   canCheckDate = false;
                 }
                }
                if (cDetail.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không có kết quả để hiển thị',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                } else {
                  return selectedTab == 0 ? _ContractInfo(cDetail[0].showContractModel!,cDetail) : ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: cDetail.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Card(
                              margin: const EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: infoBackground,
                                    border: Border.all(width: 1, color: buttonColor)
                                  ),
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
                                        const SizedBox(height: 10,),
                                        _contractFiled('ID dịch vụ', cDetail[index].showServiceModel!.id.toString()),
                                        _contractFiled('ID hoá đơn dịch vụ',cDetail[index].id.toString()),
                                        _contractFiled('Tên dịch vụ', cDetail[index].showServiceModel!.name.toString()),
                                        _contractFiled('Tên cây', cDetail[index].plantName.toString()),
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
                                                  Container(
                                                    height: 1,
                                                    decoration: const BoxDecoration(color: buttonColor),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text("Thông tin chăm sóc", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: buttonColor),),
                                                  const SizedBox(height: 5,),
                                                  _contractFiled('Lịch chăm sóc',cDetail[index].timeWorking.toString()),
                                                  _contractFiled('Ngày bắt đầu',formatDatenoTime(cDetail[index].startDate.toString())),
                                                  _contractFiled('Ngày kết thúc',formatDatenoTime(cDetail[index].expectedEndDate.toString())),
                                                  _contractFiled('Thời hạn dịch vụ', cDetail[index].showServicePackModel!.packRange.toString() + ' ' + cDetail[index].showServicePackModel!.packUnit.toString() ),
                                                  cDetail[index].note.toString().isEmpty ? _contractFiled('Lưu ý', '(không có ghi chú)') :
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text('Lưu ý:', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 14),),
                                                      const SizedBox(height: 5,),
                                                      Text(cDetail[index].note.toString(), style: const TextStyle(fontSize: 14),),
                                                      const SizedBox(height: 5,),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    decoration: const BoxDecoration(color: buttonColor),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text("Thông tin giá dịch vụ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: buttonColor),),
                                                  const SizedBox(height: 5,),
                                                  _contractFiledColor('Giá của dịch vụ này', '${f.format(cDetail[index].totalPrice)} đ', Colors.deepOrange),
                                                  _contractFiled('Đơn giá', '${f.format(cDetail[index].price)} đ'),
                                                  _contractFiledColor('Chiết khấu', cDetail[index].showServicePackModel!.packRange.toString() + ' (%)' , highLightText),
                                                  Container(
                                                    height: 1,
                                                    decoration: const BoxDecoration(color: buttonColor),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text("Thông tin xác nhận", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: buttonColor),),
                                                  const SizedBox(height: 5,),
                                                  _contractFiled('Chiều cao cây', cDetail[index].showServiceTypeModel!.typeSize.toString() + ' ' + cDetail[index].showServiceTypeModel!.typeUnit.toString()),
                                                  cDetail[index].plantStatusIMGModelList!.isNotEmpty ? Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text('Tình trạng cây trước dịch vụ:', style: TextStyle(/*color: buttonColor,*/ fontWeight: FontWeight.bold, fontSize: 14),),
                                                      const SizedBox(height: 5,),
                                                      Text(cDetail[index].plantStatus.toString(), style: const TextStyle(fontSize: 14),),
                                                      const SizedBox(height: 5,),
                                                      const Text('Hình ảnh của cây trước dịch vụ:', style: TextStyle(/*color: buttonColor,*/ fontWeight: FontWeight.bold, fontSize: 14),),
                                                      const SizedBox(height: 5,),
                                                      GridView.builder(
                                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, ),
                                                          shrinkWrap: true,
                                                          scrollDirection: Axis.vertical,
                                                          padding: EdgeInsets.zero,
                                                          itemBuilder: (context, i) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                PopupBanner(
                                                                  useDots: false,
                                                                  fit: BoxFit.fitWidth,
                                                                  height: size.height - 150,
                                                                  context: context,
                                                                  images: [cDetail[index].plantStatusIMGModelList![i].imgUrl.toString()],
                                                                  autoSlide: false,
                                                                  dotsAlignment: Alignment.bottomCenter,
                                                                  dotsColorActive: buttonColor,
                                                                  dotsColorInactive:
                                                                  Colors.grey.withOpacity(0.5),
                                                                  onClick: (index) {},
                                                                ).show();
                                                              },
                                                              child: Container(
                                                                height: 120,
                                                                width: 120,
                                                                child: Center(
                                                                  child: Container(
                                                                      decoration: BoxDecoration(
                                                                        //shape: BoxShape.circle,
                                                                          border: Border.all(
                                                                              width: 3, color: Colors.white)),
                                                                      width: 120,
                                                                      height: 120,
                                                                      child: Image.network(cDetail[index].plantStatusIMGModelList![i].imgUrl.toString(), fit: BoxFit.fill,)
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          itemCount: cDetail[index].plantStatusIMGModelList!.length),
                                                    ],
                                                  ) : const SizedBox(),
                                                  const SizedBox(height: 5,),
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
                                                    builder: (context) => ManaContractDetail2(contractID: cDetail[index].showContractModel!.id, workingDate: cDetail[index].timeWorking, des: cDetail[index].note ?? '', contractDetailID: cDetail[index].id,
                                                      startDate: cDetail[index].startDate, endDate: cDetail[index].expectedEndDate, servicePackID: cDetail[index].showServicePackModel!.id, serviceTypeID: cDetail[index].showServiceTypeModel!.id,
                                                      serviceID: cDetail[index].showServiceModel!.id,price: cDetail[index].price, isUpdate: 0, serviceType: cDetail[index].showServiceTypeModel, plantName: cDetail[index].plantName ?? '', totalPrice: cDetail[index].totalPrice ?? 0,),
                                                  )):  Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => ManaContractDetail(contractID: cDetail[index].showContractModel!.id, workingDate: cDetail[index].timeWorking, des: cDetail[index].note ?? '', contractDetailID: cDetail[index].id,
                                                    startDate: cDetail[index].startDate, endDate: cDetail[index].expectedEndDate, servicePackID: cDetail[index].showServicePackModel!.id, serviceTypeID: cDetail[index].showServiceTypeModel!.id,
                                                     serviceID: cDetail[index].showServiceModel!.id,price: cDetail[index].price, plantStatus: cDetail[index].plantStatus! ?? '',
                                                    plantIMG: cDetail[index].plantStatusIMGModelList! ?? '', isUpdate: 1, serviceType: cDetail[index].showServiceTypeModel, plantName: cDetail[index].plantName ?? '', totalPrice: cDetail[index].totalPrice ?? 0),
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
                                                    builder: (context) => WorkingDateFollowContractPage(contractDetailID: cDetail[index].id, contractID: cDetail[index].showContractModel!.id, whereCall: true, staffID : cDetail[0].showContractModel!.showStaffModel!.id),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(TabCategory[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: (selectedTab == index) ? lightText : HintIcon),
                    ),
                    const SizedBox(width: 10,)
                  ],
                ),)
          );
        },
        itemCount: 2);
  }

  dynamic showdialogConfirm(title, status, id, staffID) {
    var size = MediaQuery.of(context).size;
    String errorText = '';
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Xác nhận ' + title,
                style: const TextStyle(color: buttonColor, fontSize: 25),
              ),
            ),
            content: status == 0 ? SizedBox(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Lý do', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: buttonColor),),
                  const SizedBox(height: 5,),
                  _textFormField( '', 'Điền lý do',
                      false, () {}, _reasonController, 150, 3),
                ],
              ),
            ) : const SizedBox(),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _reasonController = TextEditingController(text: '');
                      Navigator.pop(context);
                    },
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
                    onTap: () async {
                      if(status == 0){
                        if(_reasonController.text.isEmpty){
                          Fluttertoast.showToast(
                              msg: "Không được để trống lý do",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: ErorText,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if(_reasonController.text.length < 20){
                          Fluttertoast.showToast(
                              msg: "Lý do quá ngắn (<20 ký tự)",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: ErorText,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                        OverlayLoadingProgress.start(context);
                        bool checkSuccess = await CancelContract(id, _reasonController.text, staffID);
                        OverlayLoadingProgress.stop();
                        if(checkSuccess){
                          setState(() {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContractDetailPage(contractID: widget.contractID),
                            ));
                          });
                        }
                        else {Navigator.pop(context);}}
                      }
                      if(status == 1){
                        OverlayLoadingProgress.start(context);
                        bool checkSuccess = await addContractIMG(id, imgURL.last);
                        OverlayLoadingProgress.stop();
                        if(checkSuccess){
                          setState(() {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContractDetailPage(contractID: widget.contractID),
                            ));
                          });
                        }
                        else {Navigator.pop(context);}
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
  setReason(String value) {
    setState(() {
      reason = value;
    });
  }

  List<String> TabCategory = ['Thông tin hợp đồng', 'Chi Tiết Dịch vụ'];

  Widget _textFormField(
      String label,
      String hint,
      bool readonly,
      Function()? onTap,
      TextEditingController controller,
      maxLength,
      height,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            width: MediaQuery.of(context).size.width - 140,
            child: TextFormField(
              autofocus: false,
              textAlign: TextAlign.start,
              minLines: 1,
              readOnly: readonly,
              controller: controller,
              onTap: onTap,
              maxLength: maxLength,
              maxLines: height,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Vui lòng đủ thông tin';
                }
                return null;
              },
              decoration: InputDecoration(
                //labelText: label,
                hintText: hint,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: buttonColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: buttonColor,
                    width: 2.0,
                  ),
                ),
              ),
            )),
      ],
    );
  }

}
