import 'dart:async';
import 'dart:convert';

import '../../providers/authentication/authantication_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc {
  final AuthenticationProvider _authProvider;
  final StreamController<AuthState> _authStateController =
  StreamController<AuthState>();

  Stream<AuthState> get authStateStream => _authStateController.stream;
  StreamController<AuthState> get authStateController => _authStateController;

  AuthBloc({required AuthenticationProvider authProvider})
      : _authProvider = authProvider {
    _authStateController.add(AuthInitial());
  }
  // FirebaseAuth auth = FirebaseAuth.instance;
  void send(AuthEvent event) async {
    switch (event.runtimeType) {
      case LoginEvent:
        {
          _authStateController.add(AuthLoading());
          Map<String, String?> params =
          ({'username': event.user, 'password': event.pass});
          await _authProvider.login(params).then((success) async {
            if (success) {
              await _authProvider.getUserInfor().then((value) {
                if (value) {
                  final user = _authProvider.loggedInUser;
                  _authStateController.add(AuthSuccess(user: user));
                } else {
                  _authStateController.add(AuthFailure(
                      errorMessage: 'Tải thông tin người dùng thất bại'));
                }
              });
            } else {
              _authStateController.add(AuthFailure(
                  errorMessage: 'Tài khoản hoặc mật khẩu không đúng'));
            }
          });
        }
        break;
      case LoginWithGGEvent:
        {
          _authStateController.add(AuthLoading());
          await _authProvider.loginWithGG().then((value) async {
            if (value != null) {
              Map<String, String?> params =
              ({'loginType': 'EMAIL', 'email': value});
              await _authProvider
                  .loginWithGGorPhone(params)
                  .then((value) async {
                if (value) {
                  await _authProvider.getUserInfor().then((value) {
                    if (value) {
                      final user = _authProvider.loggedInUser;
                      _authStateController.add(AuthSuccess(user: user));
                    } else {
                      _authStateController.add(AuthFailure(
                          errorMessage: 'Tải thông tin người dùng thất bại'));
                    }
                  });
                } else {
                  _authStateController
                      .add(AuthFailure(errorMessage: 'Email chưa đăng kí'));
                }
              });
            } else {
              _authStateController.add(AuthFailure(
                  errorMessage: 'Đăng nhập email không thành công'));
            }
          });
        }
        break;
      case LogoutEvent:
        {
          _authProvider.logout();
          _authStateController.add(AuthInitial());
        }
        break;
    }
  }

  void dispose() {
    _authStateController.close();
  }
}
