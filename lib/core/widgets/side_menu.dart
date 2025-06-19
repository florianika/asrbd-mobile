import 'package:asrdb/routing/route_manager.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('View maps'),
            onTap: () {
              Navigator.pushNamed(context, RouteManager.downloadedMapList);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Handle the tap
            },
          ),
        ],
      ),
    );
  }
}
