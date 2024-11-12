import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/data/repository/cart_service.dart';
import 'package:e_commerce_app/features/data/repository/favourite_service.dart';
import 'package:e_commerce_app/features/domain/repository/cart_repository.dart';
import 'package:e_commerce_app/features/presentation/bloc/search/search_bloc.dart';
import 'package:e_commerce_app/features/presentation/pages/about.dart';
import 'package:e_commerce_app/features/presentation/pages/payment_failed.dart';
import 'package:e_commerce_app/features/presentation/pages/payment_success.dart';
import 'package:e_commerce_app/firebase_options.dart';
import 'package:e_commerce_app/features/presentation/bloc/ForgotPassword/forgot_password_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/address_checkbox/address_checkbox_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/favourite/favourite_bloc.dart';
import 'package:e_commerce_app/features/presentation/pages/Home.Screen.dart';
import 'package:e_commerce_app/features/presentation/pages/address/address.dart';
import 'package:e_commerce_app/features/presentation/pages/home.dart';
import 'package:e_commerce_app/features/presentation/pages/orders.dart';
import 'package:e_commerce_app/features/presentation/pages/recovery.dart';
import 'package:e_commerce_app/features/presentation/pages/signin.dart';
import 'package:e_commerce_app/features/presentation/pages/signup.dart';
import 'package:e_commerce_app/features/presentation/pages/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String get userId {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CartRepository>(
          create: (context) => CartRepositoryImplementation(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          BlocProvider(
            create: (context) => ForgotPasswordBloc(),
          ),
          BlocProvider(
              create: (context) =>
                  CartBloc(RepositoryProvider.of<CartRepository>(context))),
          BlocProvider(
              create: (context) =>
                  FavouriteBloc(FavouritesRepositoryImplementation())),
          BlocProvider(create: (context) => AddressCheckboxBloc()),
          BlocProvider(
              create: (context) =>
                  ProductSearchBloc(FirebaseFirestore.instance)),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashWrapper(),
            theme: ThemeData(primaryColor: Colors.pink),
            initialRoute: "/",
            routes: {
              "/SplashWrapper": (context) => const SplashWrapper(),
              "/Login": (context) => const LoginWrapper(),
              "/Register": (context) => const RegisterWrapper(),
              "/Recovery": (context) => Recovery(),
              "/Home": (context) => const HomeWrapper(),
              "/HomeBottom": (context) => const HomeBottomnavigation(),
              "/MyOrders": (context) => const MyOrders(),
              "/ShippedAddress": (context) => ShippedAddress(
                    userId: userId,
                  ),
              "/About": (context) => const About(),
            }),
      ),
    );
  }
}
