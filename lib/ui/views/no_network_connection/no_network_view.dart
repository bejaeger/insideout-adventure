import 'package:flutter/material.dart';

class NoNetworkConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              'assets/icons/sem-internet.jpg',
            ),
            //fit: BoxFit.cover
          )),
        ),
      ),
    );
  }
}
