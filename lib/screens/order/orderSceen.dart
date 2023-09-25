import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../components/appBar.dart';
import '../../constants/constants.dart';
import '../../models/cart/cart.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../models/cus/cus.dart';
import '../../models/order/distance.dart';
import '../../models/order/order.dart';
import '../../models/store/store.dart';
import '../../providers/authentication/authantication_provider.dart';
import '../../providers/authentication/user_provider.dart';
import '../../providers/order/order_provider.dart';
import '../../providers/store/my_store.dart';
import '../../models/authentication/user.dart' as UserObj;
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import '../../screens/order/mapScreen.dart';
import '../home/historyScreen.dart';

class OrderScreen extends StatefulWidget {
  List<OrderCart> listPlant;
  OrderScreen({super.key, required this.listPlant, required this.isDelivery});
  final isDelivery;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var f = NumberFormat("###,###,###", "en_US");
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  late CartBloc cartBloc;

  MapController _mapController = MapController();
  List<LatLng> _routePoints = [];
  double _distance = 0.0;
  double lat = 10.81471;
  double long = 106.6773817;
  var oneDecimal = const Duration(milliseconds: 100);

  AuthenticationProvider _authenticationProvider = AuthenticationProvider();
  OrderProvider _orderProvider = OrderProvider();
  List<Store> listStore = [];
  UserObj.User? user;
  late List <UserObj.User?> cus;
  Distance distancePrice = Distance();
  bool isFT = true;
  Map<String, dynamic> listDistance = {};
  Map<String, dynamic> storeDistance = {};
  Map<String, dynamic> distance = {};
  String storeName = '';
  String storeAddress = '';
  String? cusID = null;
  bool isAddress = true;
  bool isPhone = true;
  bool isName = true;
  bool isEmail = true;

  LatLng origin = LatLng(0, 0);

  bool isLoading = false;
  @override
  void initState() {
    cartBloc = Provider.of<CartBloc>(context, listen: false);
    getListStore();
    super.initState();
  }

  getDistancePrice() async {
    await _orderProvider.getDistancePrice().then((value) {
      if (value) {
        setState(() {
          distancePrice = _orderProvider.distancePrice!;
          isLoading = false;
        });
      }
    });
  }

  getUserInfor() async {
    await _authenticationProvider.getUserInfor().then((value) {
      if (value) {
        setState(() {
          user = _authenticationProvider.loggedInUser;
          /*_nameController.text = user!.fullName;
          _emailController.text = user!.email;
          _phoneController.text = user!.phone;
          _addressController.text = addressCus;*/
          //_addressController.text = user!.address;
        });
        getCoordinatesFromAddress(_addressController.text).then((value) {
          setState(() {
            origin = value;
            getDistanceThisStore().then((value) {
              distance = value;
              getDistancePrice();
            });
          });
        });
      }
    });
  }

  getCusInfor(phone) async {
    List<Cus> cus;
    cus = (await fetchCusInfor(phone))!;
    print(cus.toString());
    if(cus.isEmpty){
      setState(() {
        isLoading = true;
        _visibility = false;
        cusID = null;
        _nameController.text = '';
        _emailController.text = '';
        _phoneController.text = '';
        _addressController.text = '';
        isName = true;
        isAddress = true;
        isEmail = true;
        isPhone = true;
      });
      Fluttertoast.showToast(
          msg: "Không tìm thấy số điện thoại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: buttonColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
    setState(() {
      isLoading = true;
      _visibility = false;
      cusID = cus[0].userID.toString();
      _nameController.text = cus[0].fullName!;
      _emailController.text = cus[0].email!;
      _phoneController.text = cus[0].phone!;
      _addressController.text = cus[0].address!;
      isName = true;
      isAddress = true;
      isEmail = true;
      isPhone = true;
      });}
  }

  Future<LatLng> getCoordinatesFromAddress(String address) async {
    LatLng latLng = LatLng(0.0, 0.0);
    GeoData data = await Geocoder2.getDataFromAddress(
        address: address, googleMapApiKey: GG_API_Key, language: 'vi');
    latLng = isFT ?  LatLng(0.0, 0.0) : LatLng(data.latitude, data.longitude);

    return latLng;
  }

  setAdress(String address, LatLng orgin) {
    setState(() {
      origin = orgin;
      _addressController.text = address;
      isLoading = true;
      getDistanceThisStore().then((value) {
        distance = value;
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  getListStore() async {
    isLoading = widget.isDelivery ? true : false;
    getUserInfor();
    setState(() {

    });
    /*await _storeProvider.getStore().then((value) {
      if (value) {
        setState(() {
          *//*listStore = _storeProvider.list!;
          listStore = _storeProvider.list!;*//*
        });
      }
      getUserInfor();
    });*/
  }


  Future<Map<String, double>> getDistanceThisStore() async {
    print("first time");
    Map<String, double> Distance = {};
    var fetchStoreID = await FetchMyStoreID();
    String myStoreID = FormatStoreID(fetchStoreID.toString());
    var myStore = await FetchInfoMyStore(myStoreID);
    await getCoordinatesFromAddress(myStore.address).then((value) async {
      await getDistance(origin, value).then((value) {
        storeDistance[myStore.address] = value + .0;
      });
    });
    double thevalue = storeDistance.values.first;
    String thekey = myStoreID;
    storeName = myStore.storeName;
    storeAddress = myStore.address;
    storeDistance.forEach((k, v) {
      if (v < thevalue) {
        thevalue = v;
        thekey = k;
      }
    });
    Distance[thekey] = double.parse((thevalue / 1000).toStringAsFixed(1));
    return Distance;
  }


  Future<double> getDistance(LatLng origin, LatLng destination) async {
    late var distance;
    try {
      final res = await http.get(Uri.parse(
          'https://api.mapbox.com/directions/v5/mapbox/driving/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?alternatives=false&annotations=state_of_charge%2Cduration&geometries=geojson&language=vi&overview=simplified&steps=true&access_token=sk.eyJ1IjoicGV4aW5ocHJvMjYiLCJhIjoiY2xpOXhpNHRwNGFxNzNrbnRrM2ZscjRnbSJ9.F9fRoMST9bhfFDgoZWZ5dQ'));
      print("res.statusCode: " + res.statusCode.toString());
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);

        distance = jsondata['routes'][0]['distance'] ?? 0.0;
      }
    } on HttpException catch (e) {
      print(e.message);
    }
    return distance + .0;
  }



  @override
  void dispose() {
    //cartBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          SingleChildScrollView(
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 35,
              ),
              AppBarWiget(
                title: 'Xác Nhận Thanh Toán',
              ),
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
              Container(child: _listPlant(widget.listPlant)),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 50,
                child: Row(children: [
                  Text(
                      '${widget.listPlant.fold(0, (sum, item) => sum + item.quantity!)} sản phẩm'),
                  const Spacer(),
                  Text(
                      '${f.format(widget.listPlant.fold(0.0, (sum, item) => sum + item.plantPrice! * item.quantity!))} đ'),
                ]),
              ),
              Container(
                height: 10,
                decoration: const BoxDecoration(color: divince),
              ),
              (user == null)
                  ? const SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shipTab(widget.listPlant),
                  Container(
                    height: 10,
                    decoration: const BoxDecoration(color: divince),
                  ),
                  _paymentTab()
                ],
              ),
              Container(
                height: 90,
              ),
            ]),
          ),
          Positioned(bottom: 0, child: _floatingBar()),
        ],
      ),
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
          (isLoading && widget.isDelivery)
              ? const Text('0đ',
              style: TextStyle(
                  color: priceColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500))
              : ((isLoading == false) && widget.isDelivery) ? Text(
              '${f.format((widget.listPlant.fold(0.0, (sum, item) => sum + item.plantPrice! * item.quantity!)) + (widget.listPlant.fold(0.0, (sum, item) => sum + item.shipPrice! * item.quantity!)) + ((distance.values.first) * distancePrice.pricePerKm ?? 0))} đ',
              style: const TextStyle(
                  color: priceColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)) : Text(
              '${f.format((widget.listPlant.fold(0.0, (sum, item) => sum + item.plantPrice! * item.quantity!)))} đ',
              style: const TextStyle(
                  color: priceColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          const Spacer(),
          (isLoading && widget.isDelivery)
              ? Container()
              : GestureDetector( ////1214
            onTap: () {
              if(countSpaces(_addressController.text) >= 30 || _addressController.text.length >= 150){
                setState(() {
                  isAddress = false;
                });
              } else {
                setState(() {
                  isAddress = true;
                });
              }
              if(_phoneController.text.length >= 11 || checkStartsWithZero(_phoneController.text) == false){
                setState(() {
                  isPhone = false;
                });
              }else {
                setState(() {
                  isPhone = true;
                });
              }
              if(validateEmail(_emailController.text) == false || _emailController.text.length >= 50){
                setState(() {
                  isEmail = false;
                });
              }else {
                setState(() {
                  isEmail = true;
                });
              }
              if(_nameController.text.length >= 50){
                setState(() {
                  isName = false;
                });
              } else{
                setState(() {
                  isName = true;
                });
              }
              if((isPhone == true) &&( isEmail == true) && (isAddress == true) && (isName == true)){
                (_nameController.text == '') ? (_nameController.text = 'Khách hàng') : _nameController.text;
                (_emailController.text == '') ? (_emailController.text = '(không)') : _emailController.text;
                (_phoneController.text == '') ? (_phoneController.text = '(không)') : _phoneController.text;
                (_addressController.text == '') ? (_addressController.text = '(khách hàng tự đem cây về)') : _addressController.text;
                List<Map<String, dynamic>> plant = [];
                String method = COD ? 'Thanh toán tiền mặt' : 'Thanh toán trực tuyến';
                double dis = widget.isDelivery ? distance.values.first : 0.0;
                OrderObject order = OrderObject(
                    fullName: _nameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    paymentMethod: method,
                    distance: dis);

                for (var data in widget.listPlant) {
                  plant.add(data.toJson());
                } ////Create Order API
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Center(
                        child: Text(
                          'Xác Nhận Đơn Hàng',
                          style:
                          TextStyle(color: buttonColor, fontSize: 25),
                        ),
                      ),
                      content: SizedBox(
                        height: 395,
                        width: size.width - 10,
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _rowInfor('Tên', order.fullName),
                                const SizedBox(
                                  height: 10,
                                ),
                                _rowInfor('Email', order.email),
                                const SizedBox(
                                  height: 10,
                                ),
                                _rowInfor('Số điện thoại', order.phone),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 7,
                                      width: 7,
                                      decoration: BoxDecoration(
                                          color: buttonColor,
                                          borderRadius:
                                          BorderRadius.circular(50)),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Địa chỉ: ',
                                      style: TextStyle(
                                          color: buttonColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: size.width - 10,
                                  child: AutoSizeText(
                                    '\t\t' + order.address,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Thông tin đơn hàng : ',
                                  style: TextStyle(
                                      color: buttonColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(children: [
                                  Text(
                                      '${widget.listPlant.fold(0, (sum, item) => sum + item.quantity!)} sản phẩm'),
                                  const Spacer(),
                                  const Text('Giá: '),
                                  Text(
                                    '${f.format(widget.listPlant.fold(0.0, (sum, item) => sum + item.plantPrice! * item.quantity!))} đ',
                                    style: const TextStyle(color: priceColor),
                                  ),
                                ]),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [widget.isDelivery ? const Text('Phí giao hàng: ') : const Text('Khách hàng tự vận chuyển')],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                widget.isDelivery ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: const [
                                          Text('Phí vận chuyển cây : ',
                                              style: TextStyle(
                                                  color: darkText,
                                                  fontSize: 16)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text('Phí giao hàng: ',
                                              style: TextStyle(
                                                  color: darkText,
                                                  fontSize: 16)),
                                        ]),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                            '${f.format(widget.listPlant.fold(0.0, (sum, item) => sum + item.shipPrice! * item.quantity!))} đ',
                                            style: const TextStyle(
                                                color: priceColor)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            '${f.format(distance.values.first * distancePrice.pricePerKm ?? 0)} đ',
                                            style: const TextStyle(
                                                color: priceColor)),
                                        Text(
                                            ' ( ${(distance.values.first)} Km )',
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 15)),
                                      ],
                                    )
                                  ],
                                ) : const SizedBox(),
                                widget.isDelivery ? Center(
                                  child: Column(children: [
                                    const Text('Tổng cộng : ',
                                        style: TextStyle(
                                            color: darkText,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        '${f.format((widget.listPlant.fold(0.0, (sum, item) => sum + item.plantPrice! * item.quantity!)) + (widget.listPlant.fold(0.0, (sum, item) => sum + item.shipPrice! * item.quantity!)) + ((distance.values.first) * distancePrice.pricePerKm ?? 0))} đ',
                                        style: const TextStyle(
                                            color: priceColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  ]),
                                ) : const SizedBox()
                              ]),
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
                                    borderRadius:
                                    BorderRadius.circular(50)),
                                child: const Text('Quay lại',
                                    style: TextStyle(
                                        color: lightText,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                OverlayLoadingProgress.start(context);
                                if(!COD){
                                  vnPayPayment(order, plant);
                                }
                                else{
                                  var data = order.createOrder(plant, widget.isDelivery ? distance.keys.first : user!.storeID,
                                      widget.isDelivery ? distancePrice.distancePriceID : 'DP002', user!.userID, null, cusID);
                                  _orderProvider
                                      .createOrder(data)
                                      .then((value) {
                                    if (value) {
                                      cartBloc.send(GetCart());
                                      Fluttertoast.showToast(
                                          msg: "Tạo Đơn Hàng Thành Công",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: buttonColor,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (context) => HistoryScreen(index: 0),
                                      ));
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Tạo Đơn Hàng Thất Bại",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                    OverlayLoadingProgress.stop();
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 110,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: buttonColor,
                                    borderRadius:
                                    BorderRadius.circular(50)),
                                child: const Text('Xác Nhận',
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
                  },
                );
              } else {

              }
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              width: 130,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(50)),
              child: const Text(
                'Đặt hàng',
                style: TextStyle(
                    color: lightText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listPlant(List<OrderCart> listPlant) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: listPlant.length,
      itemBuilder: (context, index) {
        return _plantTab(listPlant[index]);
      },
    );
  }

  Widget _plantTab(OrderCart cart) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
            width: size.width,
            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
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
                          image: NetworkImage(cart.image ??
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyRE2zZSPgbJThiOrx55_b4yG-J1eyADnhKw&usqp=CAU')),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(cart.plantName,
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
                      Text('x${cart.quantity}'),
                      Text('${f.format(cart.quantity! * cart.plantPrice!)} đ')
                    ],
                  ),
                )
              ],
            )),
        const Divider(
          height: 2,
          color: Colors.grey,
        )
      ],
    );
  }
  bool _visibility = false;
  Widget _shipTab(List<OrderCart> listPlant) {
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
        //sdt
        Stack(
          children: [
            _textFormField("Số điện thoại người nhận", 'Nhập số điện thoại', false,
                null, _phoneController),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.15,
              top: 25,
              child: GestureDetector(
                onTap: () {
                  getCusInfor(_phoneController.text);
                },
                child: Icon(Icons.search, color: buttonColor,),
              ),
            )
          ],
        ),
        isPhone ? const SizedBox() : const Center(child: Text('Số điện thoại không hợp lệ' , style: TextStyle(fontSize: 10, color: ErorText),)),
        //Full name
        _textFormField("Tên người nhận", 'Nhập tên người nhận', false, null,
            _nameController),
        isName ? const SizedBox() : const Center(child: Text('Tên quá dài/ không hợp lệ' , style: TextStyle(fontSize: 10, color: ErorText),)),
        //Email
        _textFormField("Email người nhận", 'Nhập Email người nhận', false, null,
            _emailController),
        isEmail ? const SizedBox() : const Center(child: Text('Email không hợp lệ' , style: TextStyle(fontSize: 10, color: ErorText),)),
        //address
        _textFormField(
            "Địa chỉ giao hàng", 'Bấm vào đây để chọn địa chỉ !!!', false, widget.isDelivery ? () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MapScreen(callback: setAdress),
          ));
        } : null , _addressController),
        isAddress ? const SizedBox() : const Center(child: Text('địa chỉ quá dài/ không hợp lệ' , style: TextStyle(fontSize: 10, color: ErorText),)),
        Container(
          padding: const EdgeInsets.all(10),
          child:  Text(widget.isDelivery ? 'Kiểm tra phí giao hàng: ' : 'Khách hàng tự vận chuyển',
            style: const TextStyle(
                color: darkText, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        widget.isDelivery ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if(countSpaces(_addressController.text) >= 30 || _addressController.text.length >= 120 || _addressController.text == ''){
                  setState(() {
                    isAddress = false;
                  });
                }else
                {
                  setState(() {
                    _addressController == null ? (_visibility = false) : (_visibility = true);
                    isFT = false;
                    isAddress = true;
                    getListStore();
                  });
                }
              },
              child: checkDeliveryFee('Kiểm tra phí giao hàng'),
            ),
          ],
        ) : const SizedBox(),
        /*_addressController == null ? const Text('Vui lòng nhập địa chỉ', style: TextStyle(
          color: Colors.red,
          fontSize: 12,
        )) : const SizedBox(),*/
        Visibility(
          visible: _visibility,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: const Text(
                  'Thông tin giao hàng',
                  style: TextStyle(
                      color: darkText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              (!isLoading && widget.isDelivery)
                  ? Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Cửa hàng : ',
                            style: TextStyle(
                                color: darkText, fontSize: 16)),
                        Text(
                            storeName,
                            style: const TextStyle(
                                color: darkText, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Container(
                      width: MediaQuery.of(context).size.width - 10,
                      child:  AutoSizeText(
                          '(' + storeAddress + ')',
                          style: const TextStyle(
                              color: darkText, fontSize:12)),
                    ),
                    const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Phí vận chuyển cây : ',
                                  style: TextStyle(
                                      color: darkText, fontSize: 16)),
                              SizedBox(height: 5,),
                              Text('Phí giao hàng: ',
                                  style: TextStyle(
                                      color: darkText, fontSize: 16)),
                            ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                '${f.format(widget.listPlant.fold(0.0, (sum, item) => sum + item.shipPrice! * item.quantity!))} đ',
                                style: const TextStyle(
                                    color: darkText, fontSize: 16)),
                            const SizedBox(height: 5,),

                            Text(
                                '${f.format((distance.values.first) * distancePrice.pricePerKm ?? 0)} đ',
                                style: const TextStyle(
                                    color: darkText, fontSize: 16)),
                            Text(' ( ${(distance.values.first)} Km )',
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 15)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
                  : const Center(
                child: CircularProgressIndicator(),
              ),
              /*Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text('Phí vận chuyển: (${distancePrice.pricePerKm} / km)',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ))
              ),*/

            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: const Text(
            'Phương thức thanh toán',
            style: TextStyle(
                color: darkText, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: COD,
              onChanged: (value) {
                setState(() {
                  COD = value!;
                });
              },
            ),
            const SizedBox(
              width: 20,
            ),
            const Text('Tiền Mặt')
          ],
        ),
        Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: !COD,
              onChanged: (value) {
                setState(() {
                  COD = !value!;
                });
              },
            ),
            const SizedBox(
              width: 20,
            ),
            const Text('Trực tuyến')
          ],
        )
      ],
    );
  }

  Widget _textFormField(String label, String hint, bool readonly,
      Function()? onTap, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              autofocus: false,
              readOnly: readonly,
              controller: controller,
              onTap: onTap,
              decoration: InputDecoration(
                labelText: label,
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

  Widget _rowInfor(String title, String value) {
    return Row(
      children: [
        Container(
          height: 7,
          width: 7,
          decoration: BoxDecoration(
              color: buttonColor, borderRadius: BorderRadius.circular(50)),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          '$title :  ',
          style: const TextStyle(
              color: buttonColor, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        Expanded(
            child: AutoSizeText(
              value,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 18,
              ),
            ))
      ],
    );
  }

  bool COD = true;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return buttonColor;
  }

  Widget checkDeliveryFee (title){
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: buttonColor),
      child: Center(
        child: Text(title,
          style: const TextStyle(
              color: lightText,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  vnPayPayment(order, plant) {
    double priceTotal = widget.isDelivery ? ((widget.listPlant.fold(
        0.0, (sum, item) => sum + item.plantPrice! * item.quantity!)) +
        (widget.listPlant
            .fold(0.0, (sum, item) => sum + item.shipPrice! * item.quantity!)) +
        (distance.values.first) * distancePrice.pricePerKm) : ((widget.listPlant
        .fold(
        0.0, (sum, item) => sum + item.plantPrice! * item.quantity!)));
    Map<String, dynamic> map =
    ({'amount': priceTotal, 'reason': '${cusID}-Thanh Toan Truc Tuyen'});
    OrderProvider().payment(map).then((value) {
      if (value.isNotEmpty) {
        VNPAYFlutter.instance.show(
            paymentUrl: value,
            onPaymentSuccess: (params) {
              var data = order.createOrder(plant,
                  widget.isDelivery ? distance.keys.first : user!.storeID,
                  widget.isDelivery ? distancePrice.distancePriceID : 'DP002',
                  user!.userID, params['vnp_TransactionNo'], cusID);
              _orderProvider.createOrder(data).then((value) {
                if (value) {
                  cartBloc.send(GetCart());
                  Fluttertoast.showToast(
                      msg: "Tạo Đơn Hàng Thành Công",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: buttonColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HistoryScreen(index: 0),
                  ));
                } else {
                  Fluttertoast.showToast(
                      msg: "Tạo Đơn Hàng Thất Bại",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                OverlayLoadingProgress.stop();
              });
            }, //on mobile transaction success
            onPaymentError: (params) {
              Fluttertoast.showToast(
                  msg: "Thanh Toán Thất Bại",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }, //on mobile transaction error
            onWebPaymentComplete: () {} //only use in web
        );
      } else {
        Fluttertoast.showToast(
            msg: "Lỗi hệ thống",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  int countSpaces(String text) {
    List<String> words = text.split(" ");
    int spaceCount = words.length - 1;
    return spaceCount;
  }

  bool checkStartsWithZero(String input) {
    return input.startsWith('0');
  }

  bool validateEmail(String input) {
    // Nếu input là null hoặc chuỗi rỗng, coi là hợp lệ
    if (input == null || input.isEmpty) {
      return true;
    }

    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(input);
  }
}