class Street {
  late String globalId;
  late int strType;
  late String strNameCore;

  Street();

  Street.create({
    required this.globalId,
    required this.strType,
    required this.strNameCore,
  });

  factory Street.fromJson(Map<String, dynamic> json) {
    return Street.create(
      globalId: json['GlobalID'] as String,
      strType: json['StrType'] as int,
      strNameCore: json['StrNameCore'] as String,
    );
  }
}
