// package:astacala_rescue_mobile/screens/main_screen.dart

import 'package:astacala_rescue_mobile/cubits/auth/auth_cubit.dart';
import 'package:astacala_rescue_mobile/screens/account/account_screen.dart';
import 'package:astacala_rescue_mobile/screens/home/home_screen.dart';
import 'package:astacala_rescue_mobile/screens/report/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  // Fix: Changed 'static const' to 'final'.
  // This allows the list to hold non-const widgets like our updated HomeScreen.
  final List<Widget> _pages = <Widget>[
    const ReportScreen(), // ReportScreen can be const
    HomeScreen(),         // HomeScreen is not const
    const AccountScreen(),// AccountScreen can be const
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  final List<String> _titles = const <String>[
    'Pelaporan',
    'Astacala Rescue',
    'Akun',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          )
        ],
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Pelaporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF8B0000), // Dark Red
        onTap: _onItemTapped,
      ),
    );
  }
}