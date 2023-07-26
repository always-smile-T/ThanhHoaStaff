import '../../models/bonsai/bonsai.dart';
import '../../models/order/order.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class ListOrderSuccess extends OrderState {
  final List<OrderObject>? listOrder;
  ListOrderSuccess({required this.listOrder});
}

class ListOrderDetailSuccess extends OrderState {
  final List<OrderDetail>? listOrderDetail;
  ListOrderDetailSuccess({required this.listOrderDetail});
}

class OrderSuccess extends OrderState {
  final OrderObject? Order;
  OrderSuccess({required this.Order});
}

class OrderFailure extends OrderState {
  final String errorMessage;
  OrderFailure({required this.errorMessage});
}

class OrderCancelSuccess extends OrderState {
  final String errorMessage;
  OrderCancelSuccess({required this.errorMessage});
}
