class FieldWorkStatus {
  final bool isFieldworkTime;
  final String? startTime;
  final int? fieldworkId;
  final String? msg;

  FieldWorkStatus({
    required this.isFieldworkTime,
    required this.startTime,
    required this.fieldworkId,
    this.msg,
  });

  factory FieldWorkStatus.fromJson(Map<String, dynamic> json) {
    return FieldWorkStatus(
      isFieldworkTime: json['isFieldworkTime'] ?? false,
      startTime: json['startTime'],
      fieldworkId: json['fieldworkId'],
    );
  }

  factory FieldWorkStatus.initial() {
    return FieldWorkStatus(
      isFieldworkTime: false,
      startTime: null,
      fieldworkId: null,
      msg: null,
    );
  }

  Map<String, dynamic> toJson() => {
        'isFieldworkTime': isFieldworkTime,
        'startTime': startTime,
        'fieldworkId': fieldworkId,
      };
}
