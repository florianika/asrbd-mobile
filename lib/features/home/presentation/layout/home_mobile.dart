import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:asrdb/core/widgets/side_menu.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  void _showCustomModal(BuildContext context) {
    showBarModalBottomSheet(
      context: context,
      expand: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9, // Max 90% height
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6, // Start at 60% of the screen
          minChildSize: 0.3, // Collapse to 30%
          maxChildSize: 0.9, // Expand to 90%
          expand: false, // Prevents taking full height
          builder: (context, scrollController) {
            return ListView.builder(
              controller: scrollController,
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.star),
                  title: Text("Item $index"),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Example'),
      ),
      drawer: const SideMenu(),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showCustomModal(context),
          child: const Text('Show Bottom Sheet'),
        ),
      ),
    );
  }
}
