import 'package:flutter/material.dart';
import '../../../core/enums/shape_type.dart';

class DwellingForm extends StatefulWidget {
  final ShapeType selectedShapeType;

  const DwellingForm({super.key, required this.selectedShapeType});

  @override
  State<DwellingForm> createState() => _DwellingFormState();
}

class _DwellingFormState extends State<DwellingForm> {
  final List<Map<String, dynamic>> _dwellingRows = [];

  void _addRow() {
    setState(() {
      _dwellingRows.add({
        'DwlCode': '',
        'DwlType': null,
        'NumRooms': '',
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dwelling Form", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Dwellings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _addRow,
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _dwellingRows.length,
                itemBuilder: (context, index) {
                  final row = _dwellingRows[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: row['DwlCode'],
                            decoration: const InputDecoration(labelText: 'Dwelling Code'),
                            onChanged: (value) => row['DwlCode'] = value,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<int>(
                            value: row['DwlType'],
                            decoration: const InputDecoration(labelText: 'Dwelling Type'),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('Apartment')),
                              DropdownMenuItem(value: 2, child: Text('House')),
                            ],
                            onChanged: (value) => setState(() => row['DwlType'] = value),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue: row['NumRooms'],
                            decoration: const InputDecoration(labelText: 'Number of Rooms'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => row['NumRooms'] = value,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _dwellingRows.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text("Remove", style: TextStyle(color: Colors.red)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
