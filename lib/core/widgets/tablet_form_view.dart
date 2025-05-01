import 'package:flutter/material.dart';
import 'dynamic_form.dart';

class TabletFormView extends StatefulWidget {
  final String entity;

  const TabletFormView({super.key, required this.entity});

  @override
  State<TabletFormView> createState() => _TabletFormViewState();
}

class _TabletFormViewState extends State<TabletFormView> {
  List<FieldSchema> _schema = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final url = getUrlFromEntity(widget.entity);
    fetchFields(url).then((fields) {
      final entityName = getEntityFromUrl(url);
      final filtered = fields
          .where((f) => entityFieldWhitelist[entityName]?.contains(f.name) ?? false)
          .toList();
      setState(() {
        _schema = filtered;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          
          const VerticalDivider(width: 1),
          Expanded(
            flex: 2,
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: DynamicForm(
                      schema: _schema,
                      onSave: (formValues) {
                        final json = {
                          "attributes": formValues,
                        };
                        debugPrint('Generated JSON: $json');
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
