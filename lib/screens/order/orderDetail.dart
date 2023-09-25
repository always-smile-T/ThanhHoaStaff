import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/appBar.dart';
import '../../components/note.dart';
import '../../constants/constants.dart';
import '../../models/cart/cart.dart';
import '../../models/order/order.dart';
import '../../models/order_detail/order_detail.dart';
import '../../providers/contract/contract_provider.dart';
import '../../providers/order/order_provider.dart';
import '../../screens/order/deliveryScreen.dart';
import '../../utils/format/order.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderObject? order;
  String? orderID;
  int? whereCall;
  OrderDetailScreen({super.key, this.order, this.orderID, this.whereCall});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  var f = NumberFormat("###,###,###", "en_US");
  bool isloading = true;
  List<OrderDetail>? litsDetail = [];

  OrderProvider orderProvider = OrderProvider();

  double totalplantPrice = 0;
  double totalplantShip = 0;
  double totalShipPrice = 0;
  List <OrderDetailbyID>? orderbyID;
  @override
  void initState() {
    // TODO: implement initState
    if(widget.whereCall == 1){
      getOrderDetail();
    }else if(widget.whereCall == 2){
      getOrderDetailbyID();
    }
    super.initState();
  }
  getOrderDetailbyID() async {
    orderbyID = await fetchAOrder(widget.orderID!);
    setState(() {
      totalplantShip = orderbyID![0].showOrderModel!.totalShipCost!;
      totalShipPrice = orderbyID![0].showOrderModel!.distance! * orderbyID![0].showPlantModel!.shipPrice!;
      totalplantPrice = orderbyID![0].showOrderModel!.total! - totalplantShip - totalShipPrice;
      isloading = false;
    });
  }

  getOrderDetail() {
    orderProvider.getOrderDetail(widget.order!.id).then((value) {
      setState(() {
        litsDetail = orderProvider.detalList!;
        isloading = false;
        totalplantPrice = litsDetail!.fold(
            0.0,
                (sum, item) =>
            sum + item.showPlantModel!.plantPrice! * item.quantity!);
        totalplantShip = litsDetail!.fold(
            0.0,
                (sum, item) =>
            sum +
                item.showPlantModel!.shipPrice! *
                    item.showPlantModel!.quantity!);
        totalShipPrice = (widget.order!.distance) *
            widget.order!.showDistancePriceModel!.pricePerKm;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  AppBarWiget(
                    title: 'Thông tin đơn hàng',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.whereCall == 1 ? _ordertab(widget.order!, null, 1) : _ordertab(null ,orderbyID![0], 2),
                  Container(
                    height: 10,
                    decoration: const BoxDecoration(color: divince),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Thông tin sản phẩm',
                      style: TextStyle(
                          color: darkText,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  (isloading)
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : _infortab(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 10,
                    decoration: const BoxDecoration(color: divince),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _addressTab(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 10,
                    decoration: const BoxDecoration(color: divince),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  NoteOrder(Phone: widget.whereCall == 1 ? widget.order!.showStoreModel!.phone : orderbyID![0].showCustomerModel!.phone),
                  Container(
                    height: 10,
                    decoration: const BoxDecoration(color: divince),
                  ),
                  const SizedBox(
                    height: 65,
                  ),
                ],
              )),
          Positioned(
            bottom: 0,
            child: _floatingBar(),
          )
        ],
      ),
    );
  }

  Widget _ordertab(OrderObject? order, OrderDetailbyID? orderByID, whereCall) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(children: [
            Row(
              children: [
                const Text('Trạng Thái :'),
                whereCall == 1 ? Text(convertStatus(order!.progressStatus)) : Text(convertStatus(orderByID!.showOrderModel!.progressStatus!)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text('Thời gian: '),
                whereCall == 1 ? Text(converDate(order!)) : Text(converDateByID(orderByID!)) ,
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text('Trạng Thái thanh toán: '),
                whereCall == 1 ?  Text(order!.isPaid ? 'Đã thanh toán'
                    : 'Chưa thanh toán') : Text(orderByID!.showOrderModel!.isPaid! ? 'Đã thanh toán'
                    : 'Chưa thanh toán'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text('Mã đơn hàng: '),
                whereCall == 1 ? Text(order!.id.toString().substring(1)) : Text(orderByID!.showOrderModel!.id.toString().substring(1)),
              ],
            ),
          ]),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryScreen(order: order, orderbyID: orderbyID, whereCall : whereCall),
                  ));
            },
            child: Column(
              children: const [
                Text(
                  '>>',
                  style: TextStyle(color: buttonColor, fontSize: 30),
                ),
                Text(
                  'Xem chi tiết',
                  style: TextStyle(color: buttonColor, fontSize: 12),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget _listPlant(litsDetail, whereCall) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(left: 10, right: 10),
      itemCount: whereCall == 1 ? litsDetail.length : orderbyID!.length,
      itemBuilder: (context, index) {
        return whereCall == 1 ? _plantTab(litsDetail[index].showPlantModel!, 1, index) : _plantTab(null , 2, index);
      },
    );
  }

  Widget _plantTab(OrderCart? cart, whereCall, i) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Container(
            width: size.width,
            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.zero,
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage( whereCall == 1 ? cart!.image : orderbyID![i].showPlantModel!.image ??
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyRE2zZSPgbJThiOrx55_b4yG-J1eyADnhKw&usqp=CAU')),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(whereCall == 1 ? cart!.plantName : orderbyID![i].showPlantModel!.plantName,
                    style: const TextStyle(
                        color: darkText,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(whereCall == 1 ? 'x${cart!.quantity}' : 'x${orderbyID![i].showPlantModel!.quantity}'),
                      Text(whereCall == 1 ? '${f.format(cart!.quantity! * cart!.plantPrice!)} đ' : '${f.format(orderbyID![i].showPlantModel!.quantity! * orderbyID![i].showPlantModel!.plantPrice!)} đ')
                    ],
                  ),
                )
              ],
            )),
        const Divider(
          height: 2,
          thickness: 1,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget _infortab() {
    return Column(
      children: [
        Container(child: widget.whereCall == 2 ? _listPlant(litsDetail , 2) : _listPlant(litsDetail, 1)),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          height: 50,
          child: Row(children: [
            Text( widget.whereCall == 2 ? '${orderbyID!.length} sản phẩm':
                '${litsDetail!.fold(0, (sum, item) => sum + item.showPlantModel!.quantity!)} sản phẩm'),
            const Spacer(),
            Text('${f.format(totalplantPrice)} đ'),
          ]),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Phí vận chuyển cây : ', style: TextStyle()),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Phí giao hàng: ', style: TextStyle()),
                  ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${f.format(totalplantShip)} đ',
                      style: const TextStyle()),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${f.format(totalShipPrice)} đ',
                      style: const TextStyle()),
                  Text( widget.whereCall == 2 ? ' ( ${(orderbyID![0].showOrderModel!.distance)} Km )' : ' ( ${(widget.order!.distance)} Km )',
                      style: const TextStyle(color: Colors.red)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _addressTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Thông tin giao hàng',
            style: TextStyle(
                color: darkText, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(50)),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Tên người nhận : ',
                style: TextStyle(color: darkText, fontSize: 18),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.whereCall == 1 ? widget.order!.fullName : orderbyID![0].showOrderModel!.fullName,
                style: TextStyle(color: darkText, fontSize: 18),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(50)),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Số điện thoại : ',
                style: TextStyle(color: darkText, fontSize: 18),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.whereCall == 1 ? widget.order!.phone : orderbyID![0].showOrderModel!.phone,
                style: TextStyle(color: darkText, fontSize: 18),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(50)),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Địa chỉ người nhận : ',
                style: TextStyle(color: darkText, fontSize: 18),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            widget.whereCall == 2 ? orderbyID![0].showOrderModel!.address: widget.order!.address,
            style: const TextStyle(color: darkText, fontSize: 16),
          ),
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 7,
              width: 7,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(50)),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Địa chỉ cửa hàng : ',
                style: TextStyle(color: darkText, fontSize: 18),
              ),
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          child: AutoSizeText(
            widget.whereCall == 2 ? orderbyID![0].showStoreModel!.address : widget.order!.showStoreModel!.address,
            style: const TextStyle(color: darkText, fontSize: 16),
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
        children: [
          const Text('Tổng cộng : ',
              style: TextStyle(
                  color: darkText, fontSize: 16, fontWeight: FontWeight.w500)),
          (isloading)
              ? const Text('0đ',
              style: TextStyle(
                  color: priceColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500))
              : Text(
              '${f.format(totalplantPrice + totalplantShip + totalShipPrice)} đ',
              style: const TextStyle(
                  color: priceColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          /*const Spacer(),
          (isloading)
              ? Container()
              : Container(child: _bottomRow(widget.order.progressStatus))*/
        ],
      ),
    );
  }

  /*Widget _bottomRow(String status) {
    return (status == 'RECEIVED')
        ? Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const OrderHistoryScreen(),
            ));
          },
          child: Container(
            alignment: Alignment.center,
            width: 100,
            height: 50,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(50)),
            margin:
            const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: const AutoSizeText('Đánh giá',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: lightText)),
          ),
        )
      ],
    )
        : const SizedBox();
  }*/
}
