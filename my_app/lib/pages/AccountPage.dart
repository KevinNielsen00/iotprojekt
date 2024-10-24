import 'package:flutter/material.dart';
import '../widgets/appbar/appbar.dart';



class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarFunction("Account Page"),  
      body: AccountPageContent(), 
    );
  }
}

class AccountPageContent extends StatelessWidget {
  const AccountPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          SizedBox(height: 16),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}