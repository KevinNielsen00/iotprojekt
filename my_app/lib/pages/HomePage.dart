import 'package:flutter/material.dart';
//import '../main.dart';
//import 'package:provider/provider.dart';
import '../widgets/appbar/appbar.dart';
import '../widgets/Homepage/TableSection.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarFunction("Home Page"),  
      body: const HomePageContent(), 
    );
  }
}

class HomePageContent extends StatelessWidget {
  final indexFunction;
  
  const HomePageContent({super.key, this.indexFunction});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //OverviewSection(),
          SizedBox(height: 16),
          MyTableSection(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}