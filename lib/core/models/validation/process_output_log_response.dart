class ProcessOutputLogResponse {
  final List<ProcessOutputLogDto> processOutputLogDto;

  ProcessOutputLogResponse({
    required this.processOutputLogDto,
  });

  factory ProcessOutputLogResponse.fromJson(Map<String, dynamic> json) {
    return ProcessOutputLogResponse(
      processOutputLogDto: (json['processOutputLogDto'] as List<dynamic>)
          .map((item) =>
              ProcessOutputLogDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'processOutputLogDto':
          processOutputLogDto.map((item) => item.toJson()).toList(),
    };
  }
}

class ProcessOutputLogDto {
  final String id;
  final int ruleId;
  final String reference;
  final String bldId;
  final String? entId;
  final String? dwlId;
  final String entityType;
  final String variable;
  final String qualityAction;
  final String qualityStatus;
  final String qualityMessageAl;
  final String qualityMessageEn;
  final String errorLevel;
  final String createdUser;
  final String createdTimestamp;

  ProcessOutputLogDto({
    required this.id,
    required this.ruleId,
    required this.reference,
    required this.bldId,
    required this.entId,
    this.dwlId,
    required this.entityType,
    required this.variable,
    required this.qualityAction,
    required this.qualityStatus,
    required this.qualityMessageAl,
    required this.qualityMessageEn,
    required this.errorLevel,
    required this.createdUser,
    required this.createdTimestamp,
  });

  factory ProcessOutputLogDto.fromJson(Map<String, dynamic> json) {
    return ProcessOutputLogDto(
      id: json['id'] as String,
      ruleId: json['ruleId'] as int,
      reference: json['reference'] as String,
      bldId: json['bldId'] as String,
      entId: json['entId'] as String?,
      dwlId: json['dwlId'] as String?,
      entityType: json['entityType'] as String,
      variable: json['variable'] as String,
      qualityAction: json['qualityAction'] as String,
      qualityStatus: json['qualityStatus'] as String,
      qualityMessageAl: json['qualityMessageAl'] as String,
      qualityMessageEn: json['qualityMessageEn'] as String,
      errorLevel: json['errorLevel'] as String,
      createdUser: json['createdUser'] as String,
      createdTimestamp: json['createdTimestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ruleId': ruleId,
      'reference': reference,
      'bldId': bldId,
      'entId': entId,
      'dwlId': dwlId,
      'entityType': entityType,
      'variable': variable,
      'qualityAction': qualityAction,
      'qualityStatus': qualityStatus,
      'qualityMessageAl': qualityMessageAl,
      'qualityMessageEn': qualityMessageEn,
      'errorLevel': errorLevel,
      'createdUser': createdUser,
      'createdTimestamp': createdTimestamp,
    };
  }
}
