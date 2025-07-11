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
    HomeScreen(), // HomeScreen is not const
    const AccountScreen(), // AccountScreen can be const
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _titles = const <String>[
    'Pelaporan',
    'Beranda',
    'Akun',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 1
          ? null
          : AppBar(
              title: Text(_titles[_selectedIndex]),
              backgroundColor: Colors.white,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              centerTitle: true,
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.logout, size: 20),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Konfirmasi Logout'),
                            content:
                                const Text('Apakah Anda yakin ingin keluar?'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<AuthCubit>().logout();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B0000),
                                ),
                                child: const Text('Keluar',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              activeIcon: Icon(Icons.description),
              label: 'Pelaporan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Akun',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF8B0000),
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          onTap: _onItemTapped,
        ),
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _selectedIndex = 0; // Navigate to report screen
                });
              },
              backgroundColor: const Color(0xFF8B0000),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.emergency),
              label: const Text('Lapor Darurat'),
              elevation: 6,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
