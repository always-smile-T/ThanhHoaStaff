
import '../../../models/bonsai/bonsai.dart';

abstract class CartEvent {
  Bonsai? _bonsai;
  Bonsai? get bonsai => _bonsai;
}

class GetCart extends CartEvent {}

class AddtoCart extends CartEvent {
  @override
  Bonsai? bonsai;

  AddtoCart(this.bonsai) : super();
}

class RemovetoCart extends CartEvent {}
