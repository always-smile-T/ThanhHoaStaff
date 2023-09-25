import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';
import '../../blocs/order/orderBloc.dart';
import '../../blocs/order/orderEvent.dart';
import '../../blocs/order/orderState.dart';
import '../../components/appBar.dart';
import '../../constants/constants.dart';
import '../../main.dart';
import '../../models/order/order.dart';
import '../../providers/img_provider.dart';
import '../../providers/order/order_provider.dart';
import '../../screens/order/orderDetail.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  var f = NumberFormat("###,###,###", "en_US");
  var selectedTab = 0;
  bool isLoadingOrder = false;

  int pageNo = 0;
  int PageSize = 10;
  OrderProvider orderProvider = OrderProvider();
  bool isLoading = true;
  String status = 'ALL';
  int checkState = 0;
  final _scrollController = ScrollController();
  String currentStatus = 'ALL';

  late OrderBloc orderBloc;
  late Stream<OrderState> orderStream;

  List<OrderObject> listOrder = [];

  getEnum() {
    orderProvider.getOrderStatus().then((value) {
      setState(() {
        enumStatus = orderProvider.enumStatus!;
        isLoading = false;
      });
    });
  }

  List<String> enumStatus = [];
  @override
  void initState() {
    getEnum();
    orderBloc = Provider.of<OrderBloc>(context, listen: false);
    orderStream = orderBloc.authStateStream;
    _getOrder(0, PageSize, 'CREATEDDATE', false);
    _scrollController.addListener(() {
      _getMoreOrder();
    });
    // TODO: implement initState
    super.initState();
  }

  _getOrder(
      int pageNo,
      int pageSize,
      String sortBy,
      bool sortAsc,
      ) {
    orderBloc.send(GetAllOrderEvent(
        pageNo: pageNo,
        pageSize: pageSize,
        sortBy: sortBy,
        sortAsc: sortAsc,
        listOrder: listOrder));
  }

  _getMoreOrder() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      int totalPage = listOrder[0].totalPage.round() - 1;
      if (pageNo >= totalPage) {
        // setState(() {
        //   isLoading = false;
        // });
        Fluttertoast.showToast(
            msg: "Hết trang",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: buttonColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Đang tải thêm đơn hàng ...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: buttonColor,
            textColor: Colors.white,
            fontSize: 16.0);
        pageNo++;
        int nextPage = pageNo;
        await _searchOrder(nextPage, PageSize, 'CREATEDDATE', false, status);
      }
    }
  }

  _searchOrder(
      int pageNo,
      int pageSize,
      String sortBy,
      bool sortAsc,
      String? status,
      ) {
    orderBloc.send(GetAllOrderEvent(
      listOrder: listOrder,
      pageNo: pageNo,
      pageSize: pageSize,
      sortBy: sortBy,
      sortAsc: sortAsc,
      status: status == 'ALL' ? null : status,
    ));
  }

  @override
  void dispose() {
    orderBloc.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      body: Container(
        height: size.height,
        child: Column(children: [
          SizedBox(
            height: 35,
          ),
          AppBarWiget(
            title: 'Lịch Sử Của Bạn',
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
          //Status list
          (isLoading)
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Container(
            height: 50,
            width: size.width,
            child: _listStatus(),
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(color: divince),
          ),
          Expanded(child: _listOrder())
          //Order List
        ]),
      ),
    );
  }

  Widget _statusTab(List<String> enumStatus) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return (enumStatus[index] == 'WAITING' || enumStatus[index] == 'CUSTOMERCANCELED'|| enumStatus[index] == 'DENIED') ? const SizedBox() : GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = index;
                status = enumStatus[index];
                currentStatus = enumStatus[index];
                listOrder.clear();
                pageNo = 0;
              });
              _searchOrder(0, PageSize, 'CREATEDDATE', false, status);
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
              child: AutoSizeText(convertStatus(enumStatus[index]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: (selectedTab == index) ? lightText : HintIcon)),
            ),
          );
        },
        itemCount: enumStatus.length);
  }

  Widget _listStatus() {
    return _statusTab(enumStatus);
  }

  Widget _listOrder() {
    return StreamBuilder<OrderState>(
      stream: orderStream,
      initialData: OrderInitial(),
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ListOrderSuccess) {
          listOrder = [...state.listOrder!];
          print("listOrder.length: ${listOrder.length}");
          return listOrder.isEmpty
              ? const Center(
            child: Text('Không tìm thấy đơn hàng'),
          )
              : ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            itemCount: listOrder.length,
            itemBuilder: (context, index) {
              return _orderTab(listOrder[index]);
              //return Text(listOrder[index].progressStatus!.toString());
            },
          );
        } else if (state is OrderFailure) {
          return const Center(
            child: Text('Không tìm thấy đơn hàng'),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _orderTab(OrderObject order) {

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: order, orderID: null, whereCall: 1),
            ));
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 160),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: tabBackground, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(children: [
              Container(
                  padding: EdgeInsets.zero,
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: order.progressStatus! == "RECEIVED" ? NetworkImage(order.receiptIMG ?? order.showPlantModel!.image) :
                        NetworkImage(order.showPlantModel!.image ?? NoIMG)),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 210,
                        height: 25,
                        child: Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                order.showPlantModel!.plantName ?? '',
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        convertStatus(order.progressStatus!),
                        style: const TextStyle(color: priceColor, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AutoSizeText(
                              'x ${order.showPlantModel!.quantity}',
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AutoSizeText(
                              '${f.format(order.showPlantModel!.plantPrice).toString()} đ',
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
            ]),
            const Divider(
              color: buttonColor,
              height: 20,
              thickness: 2,
            ),
            Row(
              children: [
                Text('${order.numOfPlant} sản phẩm ',
                    style: const TextStyle(
                      color: darkText,
                      fontSize: 16,
                    )),
                Spacer(),
                Text('${f.format(order.total)} đ',
                    style: const TextStyle(
                        color: priceColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500))
              ],
            ),
            const Divider(
              color: buttonColor,
              height: 20,
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AutoSizeText(
                  converDate(order),
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                //const SizedBox(width: 5,),
              ],
            ),
            const SizedBox(height: 5,),
            _bottomRow(order.progressStatus!, order),
          ],
        ),
      ),
    );
  }

  Widget _bottomRow(String status, OrderObject order) {
    return (status == 'APPROVED')
        ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 160,
          child: const AutoSizeText(NotiOrder2),
        ),
        GestureDetector(
          onTap: () {
            showdialogConfirm('PACKAGING', order, 'đống gói');
          },
          child: comfirmButton('đóng gói'),
        )
      ],
    )
        :
    (status == 'PACKAGING')
        ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 160,
          child: const AutoSizeText(NotiOrder3),
        ),
        GestureDetector(
          onTap: () {
            showdialogConfirm('DELIVERING', order, 'Giao hàng');
          },
          child: comfirmButton('Giao hàng'),
        )
      ],
    ):(status == 'DELIVERING')
        ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 160,
          child: const AutoSizeText(NotiOrder4),
        ),
        GestureDetector(
          onTap: () {
            showdialogConfirm('RECEIVED', order, 'Đã nhận');
          },
          child: comfirmButton('Đã nhận'),
        )
      ],
    ):
    (status == 'RECEIVED')
        ?  Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          child: const AutoSizeText(NotiOrder5),
        )
      ],
    ):
    (status == 'APPROVED')
        ?  Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          child: const AutoSizeText(NotiOrder1),
        )
      ],
    ):
    Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          child: const AutoSizeText(NotiOrder6),
        )
      ],
    );
  }

  Widget comfirmButton (title) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 40,
      //padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(50)),
      //margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: AutoSizeText(title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w800, color: lightText)),
    );
  }

  dynamic showdialogConfirm(String status, OrderObject order, confirmStatus/*, isReceived*/) {
    var size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          status == "RECEIVED" ? _pickImage(ImageSource.gallery) : null;
          return AlertDialog(
            title: Center(
              child: Text(
                'Tiến hành ' + confirmStatus,
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
                      print("currentStatus: " + currentStatus.toString());
                      if(status == "RECEIVED"){
                        Navigator.of(context).pop();
                        setState(() {
                          ChangeStatusOrder(order.id, status, imgURL.last);
                          listOrder.clear();
                        });
                        _searchOrder(
                            0, PageSize, 'CREATEDDATE', false, currentStatus);
                      }
                      else{
                        setState(() {
                          Navigator.of(context).pop();
                          ChangeStatusOrder(order.id, status, null);
                          listOrder.clear();
                        });
                        _searchOrder(
                            0, PageSize, 'CREATEDDATE', false, currentStatus);
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

}
