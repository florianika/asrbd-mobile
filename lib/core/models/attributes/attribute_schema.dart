class AttributeSchema {
  final List<SchemaAttribute> attributes;

  AttributeSchema({required this.attributes});

  factory AttributeSchema.fromJson(Map<String, dynamic> json) {
    return AttributeSchema(
      attributes: (json['attributes'] as List<dynamic>)
          .map((item) => SchemaAttribute.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attributes': attributes.map((attr) => attr.toJson()).toList(),
    };
  }

  // Find attribute by name
  SchemaAttribute? getByName(String name) {
    try {
      return attributes.firstWhere((attr) => attr.name == name);
    } catch (e) {
      return null;
    }
  }
}

class SchemaAttribute {
  final String name;
  final AttributeLabel label;
  final AttributeDisplay display;
  final bool selectable;
  final bool internal;
  final String section;
  final dynamic order;

  SchemaAttribute({
    required this.name,
    required this.label,
    required this.display,
    required this.selectable,
    required this.internal,
    required this.section,
    required this.order,
  });

  factory SchemaAttribute.fromJson(Map<String, dynamic> json) {
    return SchemaAttribute(
      name: json['name'] as String,
      label: AttributeLabel.fromJson(json['label'] as Map<String, dynamic>),
      display: AttributeDisplay.fromJson(json['display'] as Map<String, dynamic>),
      selectable: _parseBool(json['selectable']),
      internal: _parseBool(json['internal']),
      section: json['section'] as String,
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'label': label.toJson(),
      'display': display.toJson(),
      'selectable': selectable,
      'internal': internal,
      'section': section,
      'order': order,
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return false;
  }
}

class AttributeLabel {
  final String en;
  final String al;

  AttributeLabel({
    required this.en,
    required this.al,
  });

  factory AttributeLabel.fromJson(Map<String, dynamic> json) {
    return AttributeLabel(
      en: json['en'] as String,
      al: json['al'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'al': al,
    };
  }
}

class AttributeDisplay {
  final String admin;
  final String supervisor;
  final String enumerator;

  AttributeDisplay({
    required this.admin,
    required this.supervisor,
    required this.enumerator,
  });

  factory AttributeDisplay.fromJson(Map<String, dynamic> json) {
    return AttributeDisplay(
      admin: json['admin'] as String,
      supervisor: json['supervisor'] as String,
      enumerator: json['enumerator'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin': admin,
      'supervisor': supervisor,
      'enumerator': enumerator,
    };
  }
}