import 'package:flutter/material.dart';
import 'dynamic_form.dart';

void phoneFormView(BuildContext context, String url) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return FutureBuilder<List<FieldSchema>>(
              future: fetchFields(url),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    color: Colors.white,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                final entity = getEntityFromUrl(url);
                final filtered = snapshot.data!
                    .where((f) => entityFieldWhitelist[entity]?.contains(f.name) ?? false)
                    .toList();

                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(child: Icon(Icons.drag_handle, color: Colors.grey)),
                        const SizedBox(height: 10),
                        DynamicForm(schema: filtered),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    },
  );
}
