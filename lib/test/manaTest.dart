import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';
import 'package:thanhhoa_garden_staff_app/components/button/dialog_button.dart';
import 'package:thanhhoa_garden_staff_app/models/manaContract/manaServiceType/mana_service_type.dart';
import 'package:thanhhoa_garden_staff_app/utils/format/date.dart';
import '../../components/appBar.dart';
import '../../constants/constants.dart';
import '../../models/manaContract/manaServicePack/mana_service_pack.dart';
import '../../models/service/service.dart';
import '../../providers/contract/contract_provider.dart';
import '../../providers/img_provider.dart';
import '../../providers/service/service_provider.dart';
import '../blocs/service/service_bloc.dart';
import '../blocs/service/service_event.dart';
import '../blocs/service/service_state.dart';
import '../screens/contract/contractPageDetail.dart';


class ManaContractDetail2 extends StatefulWidget {
  ManaContractDetail2({super.key,required this.contractID, required this.workingDate, required this.des, required this.contractDetailID, required this.startDate, required this.endDate,
    required this.servicePackID, required this.serviceTypeID, required this.serviceID, required this.price, this.plantStatus, this.plantIMG, required this.isUpdate,
    required this.serviceType, required this.plantName, required this.totalPrice});
  final workingDate;
  final des;
  final contractDetailID;
  final startDate, endDate;
  final servicePackID, serviceTypeID, serviceID, contractID;
  final price;
  final plantStatus, plantIMG;
  final isUpdate;
  final serviceType;
  final plantName;
  final totalPrice;

  @override
  State<ManaContractDetail2> createState() => _ManaContractDetail2State();
}

class _ManaContractDetail2State extends State<ManaContractDetail2> {
  var f = NumberFormat("###,###,###", "en_US");


  Service service = Service();

  List<ServicePack> listServicePack = [];

  ServicePack servicePackSelect = ServicePack();

  List<TypeService> listServiceType = [];

  List<String>? selectDate = [];

  String totalPrice = '0';

  ServiceProvider serviceProvider = ServiceProvider();
  TypeService typeService = TypeService();

  final items = [
    'Cây từ đến 0 - 0.5 m',
    'Cây từ đến 0.5 - 1 m - Tăng 5%',
    'Cây từ đến 0.5 - 1 m - Tăng 15%',
    'Cây lớn hơn 2 m - Tăng 40%',
  ];
  String selectedOption ="Cây từ đến 0 - 0.5 m";
  String serviceTypeUpdate ="ST001";
  String servicePackUpdate ="SP001";
  bool isPackUpdate = false;
  bool isTypeUpdate = false;


  TextEditingController _inforController = TextEditingController();
  TextEditingController _inforPlantController = TextEditingController();
  TextEditingController _StartDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _plantNameController = TextEditingController();

  List<Service> listService = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();

  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> contractDetailData = ({
    "id": null,
    "note": null,
    "timeWorking": null,
    "startDate": null,
    "endDate": null,
    "servicePackID": null,
    "serviceTypeID": null,
    "plantName": null,
    "plantStatus": null,
    "plantIMG": []
  });



  DateTime? startDate;
  DateTime? endDate;
  @override
  void initState() {
    if(widget.serviceTypeID!.toString() == 'ST002'){
      selectedOption ="Cây từ đến 0.5 - 1 m - Tăng 5%";
    }else if(widget.serviceTypeID!.toString() == 'ST003'){
      selectedOption ="Cây từ đến 0.5 - 1 m - Tăng 15%";
    }else if(widget.serviceTypeID!.toString() == 'ST004'){
      selectedOption ="Cây lớn hơn 2 m - Tăng 40%";
    } else {
      selectedOption ="Cây từ đến 0 - 0.5 m";
    }
    widget.isUpdate == 1 ? setState((){
      for(int i = 0; i <= widget.plantIMG.length - 1; i++){
        imgURL.add(widget.plantIMG[i].imgUrl);
      }
      _inforPlantController = TextEditingController(text: widget.plantStatus);
      contractDetailData = ({
        "id": "${widget.contractDetailID!}",
        "note": "${widget.des!}",
        "timeWorking": "${widget.workingDate!}",
        "startDate": "${widget.startDate!.toString().substring(0,10)}",
        "endDate": "${widget.endDate!.toString().substring(0,10)}",
        "servicePackID": "${widget.servicePackID!}",
        "serviceTypeID": "${widget.serviceTypeID!}",
        "plantName": "${widget.plantName!}",
        "plantStatus": "${widget.plantStatus!}",
        "plantIMG": []
      });
    }) : setState((){
      contractDetailData = ({
        "id": "${widget.contractDetailID!}",
        "note": "${widget.des!}",
        "timeWorking": "${widget.workingDate!}",
        "startDate": (widget.startDate!.toString().substring(0,10)),
        "endDate": widget.endDate!.toString().substring(0,10),
        "servicePackID": "${widget.servicePackID!}",
        "serviceTypeID": "${widget.serviceTypeID!}",
        "plantName": "${widget.plantName!}",
        "plantStatus": null,
        "plantIMG": []
      });
    });
    _inforController = TextEditingController(text: widget.des);
    _plantNameController = TextEditingController(text: widget.plantName);
    startDate = DateTime.now().add(const Duration(days: 1));
    endDate = startDate!.add(const Duration(days: 30));
    //service = widget.service;
    //typeService = service.typeList!.first;
    _StartDateController.text = formatDatenoTime2(widget.startDate);
    _endDateController.text = formatDatenoTime2(widget.endDate);
    setState(() {
      getServicePack();
      getServiceType();
      totalPrice = f.format(widget.totalPrice);
    });
    super.initState();
  }

  getServiceType(){
    serviceProvider.getAllService().then((value){
      setState(() {
        listServiceType = serviceProvider.listService![0].typeList!;
        for (int i = 0 ; i < listServiceType.length ; i++){
          if (listServiceType[i].id == widget.serviceTypeID){
            typeService = listServiceType[i];
          }
        }
      });
    });
  }

  getServicePack() {
    serviceProvider.getAllServicePack().then((value) {
      setState(() {
        listServicePack = serviceProvider.listSeriverPack!;
        for (int i = 0 ; i < listServicePack.length ; i++){
          if (listServicePack[i].id == widget.servicePackID){
            servicePackSelect = listServicePack[i];
          }
        }
      });
    });
  }

  //Service service = Service();
  String selectDate2 = '' ;

  List <ManaServicePack> packService = [];
  bool firstime = true;
  int erorState = 0;
  bool checkFieldName = true;
  bool checkFieldDes = true;
  bool checkFieldIMG = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: background,
        body: Stack(children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(children: [
              const SizedBox(
                height: 35,
              ),
              AppBarWiget(title: 'Chỉnh sửa dịch vụ'),
              Container(
                height: 10,
                decoration: const BoxDecoration(color: divince),
              ),
              //Information
              Container(
                  padding: const EdgeInsets.all(20),
                  width: size.width,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*const Text(
                          'Mô tả: ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),*/
                        Row(
                          children: [
                            Text(
                              'Giá dịch vụ: ${f.format(widget.price)} đ / tháng',
                              style: const TextStyle(
                                  color: priceColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ])),
              /*Container(
                height: 10,
                decoration: const BoxDecoration(color: divince),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                height: 43,
                width: size.width,
                decoration: const BoxDecoration(color: barColor),
                child: const Text(
                  'Tiến Hành Đặt Dịch Vụ',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),*/
              Container(
                height: 10,
                decoration: const BoxDecoration(color: divince),
              ),
              _inforStaff('Thông tin cây trước dịch vụ :'),
              Container(
                height: 10,
                decoration: const BoxDecoration(color: divince),
              ),
              _infor('Thông tin cây :'),
              Container(
                height: 10,
                decoration: const BoxDecoration(color: divince),
              ),
              _serviceTab(),
              Container(
                height: 10,
                decoration: const BoxDecoration(color: divince),
              ),
              Container(
                height: 65,
              ),
            ]),
          ),
          Positioned(top: size.height - 65, child: _floatingBar()),
        ]),
      ),
    );
  }

  Widget _inforStaff(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(50)),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    'Tên cây :',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10,),
                  !checkFieldName ? const Text(
                    'Không được trống',
                    style: TextStyle(fontSize: 14, color: ErorText),
                  ) : const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              _textFormField( 'Vui lòng nhập tên cây', 'Vui lòng nhập tên cây',
                  false, () {}, _plantNameController, 150, 3),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    'Tình trạng Cây :',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10,),
                  !checkFieldDes ? const Text(
                    'Không được trống',
                    style: TextStyle(fontSize: 14, color: ErorText),
                  ) : const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              _textFormField( 'Vui lòng nhập tình trạng hiện tại của cây', 'Vui lòng nhập tình trạng hiện tại của cây',
                  false, () {}, _inforPlantController, 150, 3),
              const SizedBox(
                height: 10,
              ),
              /*imgURL.isNotEmpty ? const SizedBox() : */Row(
                children: [
                  (imgURL.length <= 4) ? GestureDetector(
                    onTap: (){
                      _pickImage(ImageSource.gallery);
                      setState(() {
                      });
                    },
                    child: const ConfirmButton(title: 'Thêm hình ảnh', width: 100.0),
                  ) : const Text('Tối đa 5 hình', style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold, fontSize: 16),),
                  const SizedBox(width: 10,),
                  !checkFieldIMG ? const Text(
                    'Không được trống',
                    style: TextStyle(fontSize: 14, color: ErorText),
                  ) : const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              imgURL.isNotEmpty ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Container(
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
                                child: Image.network(imgURL[index].toString(), fit: BoxFit.fill,)
                            ),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: (){
                                  setState(() {
                                    //imgURL.removeLast();
                                    imgURL.removeAt(index);
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
                    )/* GestureDetector(
                      onTap: () {
                        PopupBanner(
                          useDots: false,
                          fit: BoxFit.fitWidth,
                          height: MediaQuery.of(context).size.height - 150,
                          context: context,
                          images: [imgURL[index].toString()],
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
                                  child: Image.network(imgURL[index].toString(), fit: BoxFit.fill,)
                              ),
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      //imgURL.removeLast();
                                      imgURL.removeAt(index);
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
                    )*/;
                  },
                  itemCount: imgURL.length) : const SizedBox(),
            ],
          ),
        )
      ]),
    );
  }

  Widget _infor(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(50)),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Chiều cao của cây :',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              _listSize(),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Ghi chú :',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              _textFormField( widget.des, widget.des.toString().isNotEmpty ? widget.des : '(không có ghi chú)',
                  true, () {}, _inforController, 150, 3),
            ],
          ),
        )
      ]),
    );
  }
  Widget _listSize(/*Service service*/) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: buttonColor, width: 2),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: DropdownButton<TypeService>(
        isExpanded: false,
        value: typeService,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        onChanged: (TypeService? value) {
          setState(() {
            typeService = value!;
            totalPrice = setPriceService(
                widget.price,
                typeService.percentage,
                servicePackSelect.percentage,
                countMonths(startDate!, endDate!));
          });
        },
        items: listServiceType!
            .map<DropdownMenuItem<TypeService>>((TypeService value) {
          return DropdownMenuItem<TypeService>(
            value: value,
            child: SizedBox(
                width: MediaQuery.of(context).size.width - 130,
                child: AutoSizeText(
                    'Chiều cao (diện tích) ${value.size} (tăng ${value.percentage}%)',
                    style: const TextStyle(fontSize: 18, color: buttonColor))),
          );
        }).toList(),
      ),
    );
  }
/*  Widget _listSize(*//*Service service*//*) {
    return Container(
        padding: const EdgeInsets.all(10),
        height: 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: buttonColor, width: 2),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: DropdownButton<String>(
          value: selectedOption,
          onChanged: (String? newValue) {
            setState(() {
              selectedOption = newValue!;
              isTypeUpdate = true;
              if(newValue == 'Cây từ đến 0.5 - 1 m - Tăng 5%'){
                serviceTypeUpdate = 'ST002';
              }else if(newValue == 'Cây từ đến 0.5 - 1 m - Tăng 15%'){
                serviceTypeUpdate = 'ST003';
              }else if(newValue == 'Cây lớn hơn 2 m - Tăng 40%'){
                serviceTypeUpdate = 'ST004';
              } else {
                serviceTypeUpdate = 'ST001';
              }
            });
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: buttonColor)),
            );
          }).toList(),
        )
    );
  }*/

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
            width: MediaQuery.of(context).size.width - 60,
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

  Widget _listPack() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: buttonColor, width: 2),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: DropdownButton<ServicePack>(
        isExpanded: false,
        value: servicePackSelect,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        onChanged: (ServicePack? pack) {
          setState(() {
            servicePackSelect = pack!;
            getEndDate(startDate!, servicePackSelect);
            isPackUpdate = true;
            totalPrice = setPriceService(
                widget.price,
                typeService.percentage,
                servicePackSelect.percentage,
                countMonths(startDate!, endDate!));
          });
        },
        items: listServicePack
            .map<DropdownMenuItem<ServicePack>>((ServicePack value) {
          return DropdownMenuItem<ServicePack>(
            value: value,
            child: Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width - 130,
                height: 58,
                child: AutoSizeText(
                    'Thời gian ${value.range} ${value.unit}'
                        '${value.percentage == 0 ? '' : ' ( Ưu đãi  ${value.percentage}% )'}',
                    style: const TextStyle(fontSize: 18, color: buttonColor))),
          );
        }).toList(),
      ),
    );
  }

  Widget _serviceTab() {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(50)),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Dịch vụ',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              (/*!service.atHome*/false)
                  ? const SizedBox()
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thời gian làm việc : ',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  selectDate == null || selectDate!.isEmpty ? Text(
                    widget.workingDate.toString(),
                    style: const TextStyle(fontSize: 16, color: buttonColor, fontWeight: FontWeight.bold),
                  ) : Text(
                    selectDate2.toString(),
                    style: const TextStyle(fontSize: 16, color: buttonColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _selectWorkingDate(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Chọn gói dịch vụ ',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              _listPack(),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Chọn Ngày bắt đầu hợp đồng',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              _textFormField('Ngày bắt đầu hợp đồng', 'Chọn ngày bắt đầu', true,
                      () {
                    getStartDate();
                  }, _StartDateController, null, 1),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Ngày Kết thúc hợp đồng',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              _textFormField('Ngày kết thúc hợp đồng', 'Ngày kết thức', true,
                  null, _endDateController, null, 1),
            ],
          ),
        ),
      ]),
    );
  }

  getStartDate() async {
    startDate = await showDatePicker(
        helpText: 'Chọn ngày bắt đầu hợp đồng',
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime(2101));
    if (startDate != null) {
      setState(() {
        _StartDateController.text = formatDate1(startDate!);
      });

      getEndDate(startDate!, servicePackSelect);
    } else {
      startDate = DateFormat("dd/MM/yyy").parse(_StartDateController.text);
      getEndDate(startDate!, servicePackSelect);
    }
  }

  getEndDate(DateTime startDate, ServicePack servicePack) async {
    switch (servicePack.unit) {
      case 'tháng':
        {
          switch (servicePack.range) {
            case '1':
              endDate = startDate.add(const Duration(days: 30));
              servicePackUpdate = 'SP001';
              break;
            case '3':
              endDate = startDate.add(const Duration(days: 90));
              servicePackUpdate = 'SP002';
              break;
            case '6':
              endDate = startDate.add(const Duration(days: 180));
              servicePackUpdate = 'SP003';
              break;
          }
          break;
        }
      case 'năm':
        {
          switch (servicePack.range) {
            case '1':
              endDate = startDate.add(const Duration(days: 365));
              servicePackUpdate = 'SP004';
              break;
            case '2':
              endDate = startDate.add(const Duration(days: 730));
              servicePackUpdate = 'SP005';
              break;
            default:
              endDate = await showDatePicker(
                  helpText: 'Chọn ngày kết thúc hợp đồng',
                  context: context,
                  initialDate: startDate.add(const Duration(days: 366)),
                  firstDate: startDate.add(const Duration(days: 366)),
                  lastDate: DateTime(2101));
              servicePackUpdate = 'SP005';
          }
          break;
        }
      default:
        endDate = await showDatePicker(
            helpText: 'Chọn ngày kết thúc hợp đồng',
            context: context,
            initialDate: startDate.add(const Duration(days: 366)),
            firstDate: startDate.add(const Duration(days: 366)),
            lastDate: DateTime(2101));
    }
    setState(() {
      if (endDate != null) _endDateController.text = formatDate1(endDate!);
      totalPrice = setPriceService(widget.price, typeService.percentage! ,
          servicePackSelect.percentage, countMonths(startDate, endDate!));
    });
  }

  Widget _selectWorkingDate() {
    List<String> litDate = [
      'Thứ 2',
      'Thứ 3',
      'Thứ 4',
      'Thứ 5',
      'Thứ 6',
      'Thứ 7',
      'Chủ nhật'
    ];
    final _items =
    litDate.map((date) => MultiSelectItem<String>(date, date)).toList();
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: lightText,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: buttonColor,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              MultiSelectBottomSheetField(
                key: _multiSelectKey,
                initialChildSize: 0.4,
                listType: MultiSelectListType.CHIP,
                searchable: false,
                buttonText: const Text("Thời gian làm việc mới"),
                title: const Text("Ngày làm việc bạn muốn nhân viên đến"),
                items: _items,
                selectedColor: buttonColor,
                selectedItemsTextStyle: const TextStyle(color: lightText),
                validator: (value) {
                  if (value!.length != 3 && value.isNotEmpty) {
                    return "Chọn 3 ngày làm việc";
                  }
                  if (value.isEmpty) {
                    return "Hệ thống sẽ tự động chọn ngày làm việc cũ";
                  }
                  return null;
                },
                onConfirm: (values) {
                  _multiSelectKey.currentState!.validate();
                },
                onSelectionChanged: (p0) {
                  setState(() {
                    selectDate = p0.cast<String>();
                    firstime = false;
                    selectDate2 = selectDate!.join(' - ');
                  });
                },
                maxChildSize: 0.5,
                chipDisplay: MultiSelectChipDisplay(
                  chipColor: buttonColor,
                  textStyle: const TextStyle(color: lightText),
                  onTap: (value) {
                    // setState(() {
                    //   selectDate.remove(value.toString());
                    // });
                  },
                ),
              ),
              selectDate == null || selectDate!.isEmpty
                  ? Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Chọn ngày làm việc mới",
                    style: TextStyle(color: Colors.black54),
                  ))
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _floatingBar() {
    var size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(10),
      height: 65,
      width: size.width,
      decoration: const BoxDecoration(color: barColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Giá: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '$totalPrice đ',
            style: const TextStyle(
                fontSize: 20, color: priceColor, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              setState(() async {
                imgURL.isNotEmpty ? contractDetailData.addAll({
                  "plantIMG": imgURL
                }) : null;
                _inforPlantController.text.isNotEmpty ? contractDetailData.addAll({
                  "plantStatus": _inforPlantController.text
                }) : null;
                _plantNameController.text.isNotEmpty ? contractDetailData.addAll({
                  "plantName": _plantNameController.text
                }) : null;
                (selectDate!.isNotEmpty) ? contractDetailData.addAll({
                  "timeWorking": selectDate2
                }) : contractDetailData.addAll({
                  "timeWorking": "${widget.workingDate}"
                });
                startDate != null ? contractDetailData.addAll({
                  "startDate": formatDateAPI(_StartDateController.text)
                }) : null;
                startDate != null ? contractDetailData.addAll({
                  "endDate": formatDateAPI(_endDateController.text)
                }) : null;
                _inforController.text != null ? contractDetailData.addAll({
                  "note": _inforController.text
                }) : null;
                isPackUpdate ? contractDetailData.addAll({
                  "servicePackID": servicePackUpdate
                }) : null;
                isTypeUpdate ? contractDetailData.addAll({
                  "serviceTypeID": serviceTypeUpdate
                }) : null;
                print("contractDetailData: $contractDetailData");
                if(_inforPlantController.text.isNotEmpty && imgURL.isNotEmpty && _plantNameController.text.isNotEmpty&& ( selectDate!.length == 3 || selectDate!.length == 0)){
                  checkFieldIMG = true;
                  checkFieldName = true;
                  checkFieldDes = true;
                  OverlayLoadingProgress.start(context);
                  bool checkSucess = await ChangeContractDetail(contractDetailData);
                  if(checkSucess){
                    setState(() {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ContractDetailPage(contractID: widget.contractID),
                      ));
                    });
                  } else {Navigator.pop(context);}
                  OverlayLoadingProgress.stop();
                }
                if(_plantNameController.text.isEmpty){
                  setState(() {
                    checkFieldName = false;
                  });
                } else {setState(() {
                  checkFieldName = true;
                });}
                if(_inforPlantController.text.isEmpty){
                  setState(() {
                    checkFieldDes = false;
                  });
                } else {setState(() {
                  checkFieldDes = true;
                });}
                if(imgURL.isEmpty){
                  setState(() {
                    checkFieldIMG = false;
                  });
                } else {setState(() {
                  checkFieldIMG = true;
                });}
              });
            },
            child: Container(
              height: 45,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(50)),
              child: const Text(
                'Lưu dịch vụ ',
                style: TextStyle(
                    color: lightText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
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
}
