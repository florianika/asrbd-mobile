class EntranceFields {
  static const String entLatitude = 'EntLatitude';
  static const String entLongitude = 'EntLongitude';
  static const String externalCreator = 'external_creator';
  static const String externalEditor = 'external_editor';
  static const String entBldGlobalID = 'EntBldGlobalID';  
  static const String globalID = 'GlobalID';
  static const String objectID = 'OBJECTID';
  static const String entAddressID = 'EntAddressID';
  static const String entStrGlobalID = 'EntStrGlobalID';
  static const String createdUser = 'created_user';
  static const String createdDate = 'created_date';
  static const String lastEditedUser = 'last_edited_user';
  static const String lastEditedDate = 'last_edited_date'; 

  static const List<String> hiddenAttributes = [
    globalID,
    objectID,
    externalCreator,
    externalEditor,
    entBldGlobalID,
    entLatitude,
    entLongitude,
    entAddressID,
    entStrGlobalID,
    createdUser,
    createdDate,
    lastEditedUser,
    lastEditedDate
  ];
}
