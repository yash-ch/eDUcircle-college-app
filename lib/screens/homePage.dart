import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "NOTHING TO SEE HERE.",
          style: TextStyle(fontSize: 50),
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}
