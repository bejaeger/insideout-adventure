import 'package:flutter/material.dart';

class NoNetworkConnectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  'assets/icons/sem-internet.jpg',
                ),
                //fit: BoxFit.cover
              )),
            ),
          ],
        ),
      ),
    );
  }
}
