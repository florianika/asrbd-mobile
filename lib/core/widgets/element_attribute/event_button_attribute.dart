import 'package:asrdb/core/enums/shape_type.dart';
import 'package:flutter/material.dart';

class EventButtonAttribute extends StatelessWidget {
  final Function onSave;
  final Function? onClose;
  final ShapeType selectedShapeType;
  final Function openDwelling;

  const EventButtonAttribute({
    super.key,
    required this.onSave,
    required this.onClose,
    required this.selectedShapeType,
    required this.openDwelling,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        onClose != null
            ? OutlinedButton.icon(
                onPressed: () => onClose!(),
                icon: const Icon(Icons.close, color: Colors.black),
                label:
                    const Text('Close', style: TextStyle(color: Colors.black)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              )
            : const SizedBox(),
        if (selectedShapeType == ShapeType.point)
          OutlinedButton.icon(
            onPressed: () => openDwelling(),
            icon: const Icon(Icons.home_work, color: Colors.black),
            label: const Text('Manage Dwelling',
                style: TextStyle(color: Colors.black)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ElevatedButton.icon(
          onPressed: () => onSave(),
          icon: const Icon(Icons.save),
          label: const Text('Save'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }
}
