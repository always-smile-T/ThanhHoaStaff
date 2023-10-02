// ignore_for_file: await_only_futures, unnecessary_null_comparison
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:thanhhoa_garden_staff_app/providers/notification/google_notification_provider.dart';
import 'package:thanhhoa_garden_staff_app/providers/schedule/workingProvider.dart';
//import '../../blocs/AppBlocObserver%20.dart';
import '../../blocs/authentication/auth_bloc.dart';
import '../../blocs/bonsai/bonsai_bloc.dart';

import '../../blocs/bonsai/category/cate_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/feedback/feedback_bloc.dart';
import '../../blocs/order/orderBloc.dart';
import '../../blocs/service/service_bloc.dart';
import '../../blocs/store/storeBloc.dart';
import '../../models/bonsai/bonsai.dart';
import '../../providers/authentication/authantication_provider.dart';
import '../../providers/bonsai/bonsai_provider.dart';
import '../../providers/cart/cart_provider.dart';
import '../../providers/bonsai/category_provider.dart';
import '../../providers/feedback/feedback_provider.dart';
import '../../providers/order/order_provider.dart';
import '../../providers/service/service_provider.dart';
import '../../providers/store/store_provider.dart';
import 'blocs/workingDate/workingDate_bloc.dart';
import 'firebase_options.dart';
import '../../screens/authentication/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../utils/helper/shared_prefs.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'notification.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

late SharedPreferences sharedPreferences;
// late AuthBloc authBloc;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
List<Bonsai> Listincart = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    AuthenticationProvider().setfcmToken(fcmToken);
  }).onError((err) {
    // Error getting token.
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen(showFlutterNotification);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken(
    vapidKey: "BGpdLRs......",
  );

  initializeDateFormatting('vi_VN');
  runApp( MyApp(notiToken: token.toString()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.notiToken});
  final notiToken;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var token = getTokenAuthenFromSharedPrefs();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleNotiProvide>(create: (_) => GoogleNotiProvide()),
        ListenableProvider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider()),
        ListenableProvider<ServiceProvider>(create: (_) => ServiceProvider()),
        ListenableProvider<BonsaiProvider>(create: (_) => BonsaiProvider()),
        ListenableProvider<CategoryProvider>(create: (_) => CategoryProvider()),
        ListenableProvider<CartProvider>(create: (_) => CartProvider()),
        ListenableProvider<FeedbackProvider>(create: (_) => FeedbackProvider()),
        ListenableProvider<StoreProvider>(create: (_) => StoreProvider()),
        ListenableProvider<OrderProvider>(create: (_) => OrderProvider()),
        ListenableProvider<WorkingDateProvider>(
            create: (_) => WorkingDateProvider()),
        ProxyProvider<AuthenticationProvider, AuthBloc>(
          update: (_, authProvider, __) => AuthBloc(authProvider: authProvider),
        ),
        ProxyProvider<ServiceProvider, ServiceBloc>(
            update: (_, serviceProvider, __) =>
                ServiceBloc(serviceProvider: serviceProvider)),
        ProxyProvider<BonsaiProvider, BonsaiBloc>(
            update: (_, bonsaiProvider, __) =>
                BonsaiBloc(BonsaiProvider: bonsaiProvider)),
        ProxyProvider<CategoryProvider, CategoryBloc>(
            update: (_, categoryProvider, __) =>
                CategoryBloc(categoryProvider: categoryProvider)),
        ProxyProvider<CartProvider, CartBloc>(
            update: (_, cartProvider, __) =>
                CartBloc(cartProvider: cartProvider)),
        ProxyProvider<FeedbackProvider, FeedbackBloc>(
            update: (_, feedbackProvider, __) =>
                FeedbackBloc(feedbackProvider: feedbackProvider)),
        ProxyProvider<StoreProvider, StoreBloc>(
            update: (_, storeProvider, __) =>
                StoreBloc(storeProvider: storeProvider)),
        ProxyProvider<OrderProvider, OrderBloc>(
            update: (_, orderProvider, __) =>
                OrderBloc(OrderProvider: orderProvider)),
        ProxyProvider<WorkingDateProvider, WorkingDateBloc>(
            update: (_, workingDateProvider, __) =>
                WorkingDateBloc(WorkingDateProvider: workingDateProvider)),
      ],
      child: MaterialApp(
        title: 'Thanh Hoa Garden',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(notiToken: notiToken),
      ),
    );
  }
}