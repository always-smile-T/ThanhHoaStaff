import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:thanhhoa_garden_staff_app/components/button/dialog_button.dart';
import 'package:thanhhoa_garden_staff_app/models/contract/contractDetail/contract_detail.dart';
import 'package:thanhhoa_garden_staff_app/models/manaContract/manaServiceType/mana_service_type.dart';
import 'package:thanhhoa_garden_staff_app/utils/format/date.dart';
import '../../components/appBar.dart';
import '../../constants/constants.dart';
import '../../models/manaContract/manaServicePack/mana_service_pack.dart';
import '../../models/service/service.dart';
import '../../providers/contract/contract_provider.dart';
import '../../providers/img_provider.dart';
import '../../providers/service/service_provider.dart';
import '../../utils/connection/utilsConnection.dart';
import 'contractPage.dart';
import 'contractPageDetail.dart';


class ManaContractDetail extends StatefulWidget {
  ManaContractDetail({super.key,required this.contractID, required this.workingDate, required this.des, required this.contractDetailID, required this.startDate, required this.endDate,
  required this.servicePackID, required this.serviceTypeID, required this.serviceID, required this.price, this.plantStatus, this.plantIMG, required this.isUpdate,
  required this.serviceType});
  final workingDate;
  final des;
  final contractDetailID;
  final startDate, endDate;
  final servicePackID, serviceTypeID, serviceID, contractID;
  final price;
  final plantStatus, plantIMG;
  final isUpdate;
  final serviceType;

  @override
  State<ManaContractDetail> createState() => _ManaContractDetailState();
}

class _ManaContractDetailState extends State<ManaContractDetail> {
  var f = NumberFormat("###,###,###", "en_US");
  Service service = Service();

  List<ServicePack> listServicePack = [];

  ServicePack servicePackSelect = ServicePack();

  List<String>? selectDate = [];

  String totalPrice = '0';

  ServiceProvider serviceProvider = ServiceProvider();
  TypeService typeService = TypeService();


  String selectedOption ="Cây từ đến 0 - 0.5 m";
  String serviceTypeUpdate ="ST001";
  String servicePackUpdate ="SP001";
  bool isPackUpdate = false;
  bool isTypeUpdate = false;


  TextEditingController _inforController = TextEditingController();
  TextEditingController _inforPlantController = TextEditingController();
  TextEditingController _StartDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

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
    "plantStatus": null,
    "plantIMG": []
  });



  DateTime? startDate;
  DateTime? endDate;
  @override
  void initState() {

    widget.isUpdate == 1 ? setState((){
    imgURL.add(widget.plantIMG);
    _inforPlantController = TextEditingController(text: widget.plantStatus);
    contractDetailData = ({
      "id": "${widget.contractDetailID!}",
      "note": "${widget.des!}",
      "timeWorking": "${widget.workingDate!}",
      "startDate": "${widget.startDate!.toString().substring(0,10)}",
      "endDate": "${widget.endDate!.toString().substring(0,10)}",
      "servicePackID": "${widget.servicePackID!}",
      "serviceTypeID": "${widget.serviceTypeID!}",
      "plantStatus": "${widget.plantStatus!}",
      "plantIMG": ["${widget.plantIMG!}"]
    });
    }) : setState((){
      contractDetailData = ({
        "id": "${widget.contractDetailID!}",
        "note": "${widget.des!}",
        "timeWorking": "${widget.workingDate!}",
        "startDate": "${(widget.startDate!.toString().substring(0,10))}",
        "endDate": "${widget.endDate!.toString().substring(0,10)}",
        "servicePackID": "${widget.servicePackID!}",
        "serviceTypeID": "${widget.serviceTypeID!}",
        "plantStatus": null,
        "plantIMG": []
      });
    });
    setState(() {
      GetServiceInfo();
      GetServicePackInfo();
    });
    _inforController = TextEditingController(text: widget.des);
    startDate = DateTime.now().add(const Duration(days: 1));
    endDate = startDate!.add(const Duration(days: 30));
    //service = widget.service;
    //typeService = service.typeList!.first;
    _StartDateController.text = formatDatenoTime2(widget.startDate);
    _endDateController.text = formatDatenoTime2(widget.endDate);
    getServicePack();
    super.initState();
  }

  getServicePack() {
    serviceProvider.getAllServicePack().then((value) {
      setState(() {
        int month = 1;
        listServicePack = serviceProvider.listSeriverPack!;
        print("servicePackSelect.percentage: " + servicePackSelect.percentage.toString());
        totalPrice = setPriceService(
            widget.price,
            /*typeService.percentage*/0,
            servicePackSelect.percentage,
            month);
      });
    });
  }

  //Service service = Service();
   String selectDate2 = '' ;

  List <ManaServiceType> typeService1 = [];
  List <ManaServicePack> packService = [];
  bool firstime = true;
  int erorState = 0;

  Future<dynamic> GetServiceInfo() async {
    typeService1 = (await fetchServiceTypeByID(widget.serviceID));
    return typeService1;
  }
  Future<dynamic> GetServicePackInfo() async {
    packService = (await fetchServicePack());
    return packService;
  }


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
                    'Tình trạng cây trước dịch vụ :',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10,),
                  (erorState == 1 || erorState == 3) ? const Text(
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
              imgURL.isNotEmpty ? const SizedBox() : Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        _pickImage(ImageSource.gallery);
                      });
                    },
                    child: ConfirmButton(title: 'Thêm hình ảnh', width: 100.0),
                  ),
                  const SizedBox(width: 10,),
                  (erorState == 2 || erorState == 3) ? const Text(
                    'Không được trống',
                    style: TextStyle(fontSize: 14, color: ErorText),
                  ) : const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              imgURL.isNotEmpty ? Row(
                children: [
                  Container(
                    height: 150,
                    width: 150,
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
                              child: Image.network( imgURL.length == 0 ? getImageNoAvailableURL : imgURL.last.toString(), fit: BoxFit.fill,)
                          ),
                        ),
                        Positioned(
                          top: 0,
                            right: 0,
                            child: IconButton(
                          onPressed: (){
                            setState(() {
                              imgURL.clear();
                              listFile.clear();
                            });
                          },
                          icon: Icon(Icons.cancel, color: buttonColor, size: 30,),
                        ))
                      ],
                    ),
                  ),
                  const Text(
                    'Hình ảnh cây trước dịch vụ',
                    style: TextStyle(fontSize: 14, color: buttonColor, fontWeight: FontWeight.bold),
                  )
                ],
              ) : const SizedBox(),
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
              _listSize(/*typeService*/),
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
              _textFormField( widget.des, widget.des,
                  false, () {}, _inforController, 150, 3),
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
  }

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
                /*typeService.percentage*/0,
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
                  Row(
                    children: [
                      const Text(
                        'Thời gian làm việc : ',
                        style: TextStyle(fontSize: 18),
                      ),
                      selectDate == null || selectDate!.isEmpty ? Text(
                        widget.workingDate.toString(),
                        style: const TextStyle(fontSize: 14, color: buttonColor),
                      ) : Text(
                        selectDate2.toString(),
                        style: const TextStyle(fontSize: 14, color: buttonColor),
                      ),
                    ],
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
        print("No format: " + _StartDateController.text);
        print("format: " + formatDateAPI(_StartDateController.text));
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
      totalPrice = setPriceService(widget.price, /*typeService.percentage!*/ 0,
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
                  if (value!.length > 3) {
                    return "Chọn tối đa 3 ngày làm việc";
                  }
                  if (value.length == 0) {
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
              // print('trước 123 : ' +
              //     sharedPreferences.getString('ContactDetail')!);
              //addContactService();
              setState(() {
                imgURL.isNotEmpty ? contractDetailData.addAll({
                  "plantIMG": [imgURL.first, imgURL.first]
                }) : null;
                _inforPlantController.text.isNotEmpty ? contractDetailData.addAll({
                  "plantStatus": _inforPlantController.text
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

                setState(() {
                  if(_inforPlantController.text.isNotEmpty && imgURL.isNotEmpty){
                    erorState = 0;
                    ChangeContractDetail(contractDetailData);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ContractDetailPage(contractID: widget.contractID),
                    ));
                  }if(_inforPlantController.text.isEmpty && imgURL.isNotEmpty){
                    erorState = 1;
                  } if(imgURL.isEmpty && _inforPlantController.text.isNotEmpty){
                    erorState = 2;
                  } if(imgURL.isEmpty && _inforPlantController.text.isEmpty){
                    erorState = 3;
                  }
                });
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
