import 'package:flutter/material.dart';

class MapLegend extends StatelessWidget {
  final Map<String, Color> legendItems;
  final String title;

  const MapLegend({
    super.key,
    required this.legendItems,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...legendItems.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: entry.value,
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(entry.key),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
