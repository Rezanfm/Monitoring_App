import 'package:flutter/material.dart';
import 'package:monitoring_app/screens/home_screen.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // User dan Admin akan melihat HomeScreen yang sama untuk monitoring
    return const HomeScreen();
  }
}
