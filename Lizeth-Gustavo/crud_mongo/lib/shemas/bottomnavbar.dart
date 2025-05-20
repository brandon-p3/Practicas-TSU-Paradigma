import 'package:crud_mongo/shemas/fetch.dart';
import 'package:crud_mongo/shemas/pantallaextra.dart';
import 'package:crud_mongo/shemas/principal.dart';
import 'package:crud_mongo/utils/fuctionGlobals.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> Screens = [PrincipalScreen(), FetchData(), PantallaExtra() ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crud Ejemplo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.access_alarm),
            onPressed: () {
              closeSesion(context);
            },
          ),
        ],
      ),

      backgroundColor: Colors.white,
      body: Screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.red,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
          Icon(Icons.add, size:30, color: Colors.white),
    
        ],
      ),
    );
  }
}
