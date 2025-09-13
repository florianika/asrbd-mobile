class FieldSchema {
  final String name;
  final String alias;
  final String type;
  final bool editable;
  final bool nullable;
  final bool required;
  final dynamic defaultValue;
  final List<Map<String, dynamic>>? codedValues;

  FieldSchema({
    required this.name,
    required this.alias,
    required this.type,
    required this.editable,
    required this.nullable,
    required this.required,
    this.defaultValue,
    this.codedValues,
  });

  factory FieldSchema.fromJson(Map<String, dynamic> json) {
    return FieldSchema(
      name: json['name'],
      alias: json['alias'] ?? json['name'],
      type: json['type'],
      editable: json['editable'] ?? false,
      nullable: json['nullable'] ?? true,
      required: json['required'] ?? false,
      defaultValue: json['defaultValue'],
      codedValues: (json['domain']?['codedValues'] as List?)
          ?.map((e) => {
                'code': e['code'],
                'name': e['name'],
              })
          .toList(),
    );
  }
}