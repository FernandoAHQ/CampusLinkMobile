import 'package:campuslink/services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  final networkService = NetworkService();

  @override
  void initState() {
    super.initState();
    requestRenew();
  }

  void requestRenew() async {
    final renewResponse = await networkService.renewToken();
    if (!(renewResponse['renewResponse'])) {
      navigateTo('/home');
    } else {
      navigateTo('/login');
    }
  }

  void navigateTo(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SvgPicture.asset(
        'assets/images/logo.svg',
        semanticsLabel: 'CampusLink Logo',
        height: 196.0,
      )),
    );
  }
}
