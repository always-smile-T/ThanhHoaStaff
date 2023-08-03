// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import '../../models/bonsai/bonsai.dart';
import '../../providers/bonsai/bonsai_provider.dart';
import '../../blocs/bonsai/bonsai_event.dart';
import '../../blocs/bonsai/bonsai_state.dart';
class BonsaiBloc {
  final BonsaiProvider _BonsaiProvider;
  final StreamController<BonsaiState> _BonsaiStateController =
  StreamController<BonsaiState>();

  Stream<BonsaiState> get authStateStream =>
      _BonsaiStateController.stream.asBroadcastStream();
  StreamController<BonsaiState> get authStateController =>
      _BonsaiStateController;

  BonsaiBloc({required BonsaiProvider BonsaiProvider})
      : _BonsaiProvider = BonsaiProvider {
    _BonsaiStateController.add(BonsaiInitial());
  }
  void send(BonsaiEvent event) async {
    switch (event.runtimeType) {
      case GetAllBonsaiEvent:
        if (event.pageNo == 0) {
          _BonsaiStateController.add(BonsaiLoading());
        }
        await _BonsaiProvider.fetchBonsaiList(event).then((value) {
          if (value) {
            final listBonsai = _BonsaiProvider.listBonsai;
            List<Bonsai> fetchBonsaiList = [
              ...event.listBonsai!,
              ...listBonsai!
            ];
            _BonsaiStateController.add(
                ListBonsaiSuccess(listBonsai: fetchBonsaiList));
          } else {
            _BonsaiStateController.add(
                BonsaiFailure(errorMessage: 'Get Bonsai List Failed'));
          }
        });
        break;
      case GetByIDBonsaiEvent:
        _BonsaiStateController.add(BonsaiLoading());
        await _BonsaiProvider.getBonsaiByID(event.id!).then((value) {
          if (value) {
            final Bonsai = _BonsaiProvider.bonsai;
            _BonsaiStateController.add(BonsaiSuccess(bonsai: Bonsai));
          } else {
            _BonsaiStateController.add(
                BonsaiFailure(errorMessage: 'Get Bonsai Failed'));
          }
        });
        break;
    }
  }

  void dispose() {
    _BonsaiStateController.close();
  }
}
