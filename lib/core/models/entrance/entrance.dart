class Entrance {
  final int entStreet;
  final String entCensus2023;
  final String globalID;
  final String entBuildingID;
  final String entAddressID;
  final int entQuality;
  final int entPointStatus;
  final String entBuildingNumber;
  final String entEntranceNumber;
  final int entTown;
  final int entZipCode;
  final int entDwellingRecs;
  final int entDwellingExpec;
  final int objectID;

  Entrance({
    required this.entStreet,
    required this.entCensus2023,
    required this.globalID,
    required this.entBuildingID,
    required this.entAddressID,
    required this.entQuality,
    required this.entPointStatus,
    required this.entBuildingNumber,
    required this.entEntranceNumber,
    required this.entTown,
    required this.entZipCode,
    required this.entDwellingRecs,
    required this.entDwellingExpec,
    required this.objectID,
  });

  factory Entrance.fromJson(Map<String, dynamic> json) {
    return Entrance(
      entStreet: json['EntStreet'],
      entCensus2023: json['EntCensus2023'],
      globalID: json['GlobalID'],
      entBuildingID: json['EntBuildingID'],
      entAddressID: json['EntAddressID'],
      entQuality: json['EntQuality'],
      entPointStatus: json['EntPointStatus'],
      entBuildingNumber: json['EntBuildingNumber'],
      entEntranceNumber: json['EntEntranceNumber'],
      entTown: json['EntTown'],
      entZipCode: json['EntZipCode'],
      entDwellingRecs: json['EntDwellingRecs'],
      entDwellingExpec: json['EntDwellingExpec'],
      objectID: json['OBJECTID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EntStreet': entStreet,
      'EntCensus2023': entCensus2023,
      'GlobalID': globalID,
      'EntBuildingID': entBuildingID,
      'EntAddressID': entAddressID,
      'EntQuality': entQuality,
      'EntPointStatus': entPointStatus,
      'EntBuildingNumber': entBuildingNumber,
      'EntEntranceNumber': entEntranceNumber,
      'EntTown': entTown,
      'EntZipCode': entZipCode,
      'EntDwellingRecs': entDwellingRecs,
      'EntDwellingExpec': entDwellingExpec,
      'OBJECTID': objectID,
    };
  }
}
