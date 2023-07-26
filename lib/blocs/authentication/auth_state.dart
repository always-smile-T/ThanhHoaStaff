import '../../models/authentication/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User? user;
  AuthSuccess({required this.user});
}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure({required this.errorMessage});
}
