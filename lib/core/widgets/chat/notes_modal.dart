import 'package:asrdb/core/widgets/chat/note_form_tablet.dart';
import 'package:flutter/material.dart';

Future<void> showNotesForm({required BuildContext context}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      final Color backgroundStart = Theme.of(context).colorScheme.surface;
      final Color backgroundEnd = Theme.of(context).colorScheme.surface;
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [backgroundStart, backgroundEnd],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: NotesWrapper(scrollController: scrollController),
          ),
        ),
      );
    },
  );
}
