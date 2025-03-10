import 'package:flutter/material.dart';
import 'package:asrdb/core/widgets/side_menu.dart';

class HomeTablet extends StatefulWidget {
  const HomeTablet({super.key});

  @override
  State<HomeTablet> createState() => _HomeTabletState();
}

class _HomeTabletState extends State<HomeTablet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Example'),
      ),
      drawer: const SideMenu(),
      body: Row(children: <Widget>[
        // First column taking 70% of the width
        Flexible(
          flex: 6, // 70% width
          child: Container(
            color: Colors.blue,
            child: const Center(
                child:
                    Text('70% Width', style: TextStyle(color: Colors.white))),
          ),
        ),

        // Second column taking the remaining space (30%)
        Flexible(
          flex: 4, // 30% width
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            child: const Center(
                child: Text('Remaining 30%',
                    style: TextStyle(color: Colors.white))),
          ),
        ),
      ]),
    );
  }
}
