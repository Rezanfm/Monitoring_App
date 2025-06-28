import 'package:flutter/material.dart';
import 'package:monitoring_app/screens/home_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // User dan Admin akan melihat HomeScreen yang sama untuk monitoring
    return const HomeScreen();
  }
}
