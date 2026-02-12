import 'package:asrdb/core/helpers/string_helper.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:asrdb/core/models/note/note_model.dart';
import 'package:asrdb/core/services/note_service.dart';
import 'package:asrdb/features/home/presentation/note_cubit.dart';
import 'package:asrdb/main.dart';

class NotesWrapper extends StatelessWidget {
  final ScrollController? scrollController;

  const NotesWrapper({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final building = context.read<AttributesCubit>();
    final buildingGlobalId = building.currentBuildingGlobalId!;
    return BlocProvider(
      create: (context) =>
          NoteCubit(sl<NoteService>())..getNotes(buildingGlobalId),
      child: NotesWidget(
        scrollController: scrollController,
      ),
    );
  }
}

class NotesWidget extends StatefulWidget {
  final ScrollController? scrollController;
  const NotesWidget({super.key, this.scrollController});
  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  ScrollController? _internalScrollController;
  late ScrollController _effectiveScrollController;

  late AnimationController _sendButtonAnimationController;
  late Animation<double> _sendButtonScaleAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      _effectiveScrollController = widget.scrollController!;
    } else {
      _internalScrollController = ScrollController();
      _effectiveScrollController = _internalScrollController!;
    }
    _sendButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _sendButtonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
          parent: _sendButtonAnimationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _sendButtonAnimationController.dispose();
    _internalScrollController?.dispose();
    super.dispose();
  }

  void _postNote(BuildContext context) {
    final userService = sl<UserService>();
    final userName =
        '${userService.userInfo?.uniqueName ?? ''} ${userService.userInfo?.familyName ?? ''}';
    final userId = '${userService.userInfo?.nameId}';
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _showSnackBar(
          AppLocalizations.of(context).translate(Keys.noteCannotBeEmpty));
      return;
    }
    final rawId = context.read<AttributesCubit>();
    final buildingGlobalId = rawId.currentBuildingGlobalId;
    if (buildingGlobalId == '' || buildingGlobalId == null) {
      _showSnackBar(
          AppLocalizations.of(context).translate(Keys.noteNoBuildingSelected));
      return;
    }
    _sendButtonAnimationController
        .forward()
        .then((_) => _sendButtonAnimationController.reverse());
    context.read<NoteCubit>().postNote(
        buildingGlobalId.removeCurlyBraces()!, text, userName, userId);
    _controller.clear();
  }

  String _formatDate(DateTime timestamp) {
    return DateFormat('MMM dd, yyyy – HH:mm').format(timestamp);
  }

  TextStyle _sectionHeaderStyle(ColorScheme colorScheme) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: colorScheme.primary,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                "Shenimet e Nderteses",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInputCard(colorScheme, context),
            const SizedBox(height: 15),
            Divider(
                height: 1, color: colorScheme.outline.withValues(alpha: 0.5)),
            const SizedBox(height: 10),
            SizedBox(
              height: 450,
              child: BlocBuilder<NoteCubit, NoteState>(
                builder: (context, state) {
                  if (state is NoteLoading) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: colorScheme.primary));
                  } else if (state is NoteLoaded) {
                    if (state.notes.isEmpty) {
                      return _buildEmptyState(colorScheme);
                    }
                    final now = DateTime.now();
                    final todayNotes = state.notes
                        .where((n) =>
                            n.createdTimestamp.year == now.year &&
                            n.createdTimestamp.month == now.month &&
                            n.createdTimestamp.day == now.day)
                        .toList();

                    final earlierNotes = state.notes
                        .where((n) => !(n.createdTimestamp.year == now.year &&
                            n.createdTimestamp.month == now.month &&
                            n.createdTimestamp.day == now.day))
                        .toList();

                    return ListView(
                      controller: _effectiveScrollController,
                      children: [
                        if (todayNotes.isNotEmpty) ...[
                            Text(
                              AppLocalizations.of(context)
                                .translate(Keys.notesToday),
                              style: _sectionHeaderStyle(colorScheme)),
                          const SizedBox(height: 6),
                          ...todayNotes.map((note) => NoteCard(
                              note: note,
                              formatDate: _formatDate,
                              colorScheme: colorScheme)),
                          const SizedBox(height: 12),
                        ],
                        if (earlierNotes.isNotEmpty) ...[
                            Text(
                              AppLocalizations.of(context)
                                .translate(Keys.notesEarlier),
                              style: _sectionHeaderStyle(colorScheme)),
                          const SizedBox(height: 6),
                          ...earlierNotes.map((note) => NoteCard(
                              note: note,
                              formatDate: _formatDate,
                              colorScheme: colorScheme)),
                        ],
                      ],
                    );
                  } else if (state is NoteError) {
                    return Center(child: Text(state.message));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(ColorScheme colorScheme, BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: 5,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText:
                      AppLocalizations.of(context).translate(Keys.notesHint),
                  hintStyle: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 15),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                ),
                style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
              ),
            ),
            const SizedBox(width: 10),
            ScaleTransition(
              scale: _sendButtonScaleAnimation,
              child: FloatingActionButton(
                onPressed: () => _postNote(context),
                mini: true,
                backgroundColor: colorScheme.secondary,
                child: const Icon(Icons.send_rounded),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notes,
              size: 60, color: colorScheme.primary.withValues(alpha: 0.4)),
          const SizedBox(height: 10),
            Text(AppLocalizations.of(context).translate(Keys.notesEmpty),
              style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.7))),
        ],
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final Note note;
  final Function(DateTime) formatDate;
  final ColorScheme colorScheme;

  const NoteCard(
      {super.key,
      required this.note,
      required this.formatDate,
      required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.2),
        borderRadius: BorderRadius.circular(15),
        color: colorScheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.noteText,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
                child: Text(
                  AppLocalizations.of(context)
                    .translate(Keys.noteByOn)
                    .replaceAll('{user}', note.createdUser)
                    .replaceAll(
                      '{date}', formatDate(note.createdTimestamp)),
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurface.withValues(alpha: 0.7))),
            )
          ],
        ),
      ),
    );
  }
}
