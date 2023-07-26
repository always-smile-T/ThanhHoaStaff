// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import '../../blocs/order/orderEvent.dart';
import '../../blocs/order/orderState.dart';
import '../../models/order/order.dart';
import '../../providers/order/order_provider.dart';

class OrderBloc {
  final OrderProvider _OrderProvider;
  final StreamController<OrderState> _OrderStateController =
  StreamController<OrderState>();

  Stream<OrderState> get authStateStream =>
      _OrderStateController.stream.asBroadcastStream();
  StreamController<OrderState> get authStateController => _OrderStateController;

  OrderBloc({required OrderProvider OrderProvider})
      : _OrderProvider = OrderProvider {
    _OrderStateController.add(OrderInitial());
  }
  void send(OrderEvent event) async {
    switch (event.runtimeType) {
      case GetAllOrderEvent:
        if (event.pageNo == 0) {
          _OrderStateController.add(OrderLoading());
        }
        await _OrderProvider.getOrderList(event).then((value) {
          if (value) {
            final listOrder = _OrderProvider.list;
            List<OrderObject> fetchOrderList = [
              ...event.listOrder!,
              ...listOrder!
            ];
            _OrderStateController.add(
                ListOrderSuccess(listOrder: fetchOrderList));
          } else {
            _OrderStateController.add(
                OrderFailure(errorMessage: 'Get Order List Failed'));
          }
        });
        break;
      case GetAllOrderDetailEvent:
        if (event.pageNo == 0) {
          _OrderStateController.add(OrderLoading());
        }
        await _OrderProvider.getOrderDetailByFeedback(event).then((value) {
          if (value) {
            final listOrderDetail = _OrderProvider.detalList;
            List<OrderDetail> fetchOrderDetailList = [
              ...event.listOrderDetial!,
              ...listOrderDetail!
            ];
            _OrderStateController.add(
                ListOrderDetailSuccess(listOrderDetail: fetchOrderDetailList));
          } else {
            _OrderStateController.add(
                OrderFailure(errorMessage: 'Get Order List Failed'));
          }
        });
        break;
      case CancelOrderEvent:
        await _OrderProvider.cancelOrder(event).then((value) {
          if (value) {
            send(GetAllOrderEvent(
                pageNo: 0,
                pageSize: 10,
                sortBy: 'CREATEDDATE',
                sortAsc: false,
                listOrder: []));
            _OrderStateController.add(
                OrderCancelSuccess(errorMessage: 'Update Success'));
          } else {
            _OrderStateController.add(
                OrderFailure(errorMessage: 'Update Failed'));
          }
        });
        break;
    }
  }

  void dispose() {
    _OrderStateController.close();
  }
}
