import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/pages/ProductsPage.dart';
import 'package:my_app/pages/HomePage.dart';
import 'package:my_app/pages/AddCustomerPage.dart';
import 'package:my_app/pages/AccountPage.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color.fromARGB(255, 45, 62, 218),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Color.fromARGB(255, 51, 67, 218),
          ),
          cardTheme: const CardTheme(
            color: Colors.white,
            elevation: 5,
            shadowColor: Colors.black,
          ),
          fontFamily: 'Karla',
        ),
        home: const BottomNavBar(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); 
    var selectedIndex = appState.selectedIndex;

    void onItemTapped(int index) {
      appState.onItemTapped(index); 
    }

    final themeColor = Theme.of(context).primaryColor;
    Widget page;
    
    switch (selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const AddCustomerPage();
        break;
      case 2:
        page = const ProductsPage();
        break;
      case 3:
        page = const AccountPage();
        break;
      default:
        throw UnimplementedError();
    }

    return Scaffold(
      body: Center(
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Add Customer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color.fromARGB(255, 105, 105, 105),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        onTap: onItemTapped,
      ),
    );
  }
}


