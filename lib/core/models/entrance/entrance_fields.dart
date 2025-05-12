class EntranceFields {
  static const String entLatitude = 'EntLatitude';
  static const String entLongitude = 'EntLongitude';
  static const String externalCreator = 'external_creator';
  static const String externalEditor = 'external_editor';
  static const String entBldGlobalID = 'EntBldGlobalID';
  static const String globalID = 'GlobalID';
  static const String objectID = 'OBJECTID';

  static const List<String> hiddenAttributes = [
    globalID,
    objectID,
    externalCreator,
    externalEditor,
    entBldGlobalID,
  ];
}
