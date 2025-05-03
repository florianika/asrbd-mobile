import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/widgets/element_attribute/element_attribute.dart';
import 'package:flutter/material.dart';

class TabletFormView extends StatefulWidget {
  final EntityType entity;
  final VoidCallback onClose;
  final Map<String, dynamic> initialData;

  const TabletFormView({super.key, required this.entity, required this.onClose, required this.initialData});

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
      // final filtered = fields
      //     .where((f) =>
      //         entityFieldWhitelist[entityName]?.contains(f.name) ?? false)
      //     .toList();
      setState(() {
        _schema = fields;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          const VerticalDivider(width: 1),
          Expanded(
            flex: 2,
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          inputDecorationTheme: const InputDecorationTheme(
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          textTheme: const TextTheme(
                            bodyMedium: TextStyle(color: Colors.black),
                          ),
                        ),
                        child: DynamicForm(
                          schema: _schema,
                          initialData: widget.initialData,
                          onSave: (formValues) {
                            final json = {
                              "attributes": formValues,
                            };
                            debugPrint('Generated JSON: $json');
                          },
                          onClose: widget.onClose,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}