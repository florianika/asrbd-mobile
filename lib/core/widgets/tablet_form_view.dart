import 'package:flutter/material.dart';
import 'dynamic_form.dart';

class TabletFormView extends StatefulWidget {
  final String url;

  const TabletFormView({super.key, required this.url});

  @override
  State<TabletFormView> createState() => _TabletFormViewState();
}

class _TabletFormViewState extends State<TabletFormView> {
  List<FieldSchema> _schema = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchFields(widget.url).then((fields) {
      final entity = getEntityFromUrl(widget.url);
      final filtered = fields
          .where((f) => entityFieldWhitelist[entity]?.contains(f.name) ?? false)
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
      appBar: AppBar(title: Text("Tablet Form - ${getEntityFromUrl(widget.url).toUpperCase()}")),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text("Tablet Menu", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Back"),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            flex: 2,
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: DynamicForm(schema: _schema),
            ),
          ),
        ],
      ),
    );
  }
}
