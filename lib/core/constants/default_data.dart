class DefaultData {
  //BldCentroidStatus and EntPointStatus,  "name": "4 | Vlera nga terreni",
  static const int fieldData = 4;

  //BldQuality, "name": "9 | Të dhëna të patestuara",
  static const int untestedData = 9;

  //BldStatus, "name": "4 | Ekzistuese"
  static const int bldStatusExisting = 9;

  //BldType, "name": "9 | Lloj i panjohur ndërtese"
  static const int bldTypeUnknown = 9;

  //BldClass, "name": "999 | Kategoria e ndërtesës e panjohur"
  static const int bldClassUnknown = 999;

  //BldWasteWater, "name": "9 | I panjohur"
  static const int bldWasteWaterUnknown = 9;

  //BldElectricity, "name": "9 | I panjohur"
  static const int bldElectricityUnknown = 9;

  //BldPipedGas, "name": "9 | I panjohur"
  static const int bldPipedGasUnknown = 9;

  //BldElevator, "name": "9 | I panjohur"
  static const int bldElevatorUnknown = 9;

  //EntQuality, "name": "9 | Të dhëna të patestuara"
  static const int entQualityUntested = 9;

  //EntPointStatus, "name": "1 | Vlera zëvendësuese"
  static const int entPointStatus = 1;

  //BldCentroidStatus, "name": "1 | Vlera zëvendësuese"
  static const int bldCentroidStatus = 1;

  //DwlQuality, "name": "9 | Të dhëna të patestuara",
  static const int dwlQualityUntested = 9;

  //DwlStatus, "name": "4 | Ekzistuese",
  static const int dwlStatusExisting = 4;

  //DwlType, "name": "9 | Lloj i banesës i panjohur"
  static const int dwlTypeUnknown = 4;

  //DwlOwnership, "name": "99 | Pronësia e panjohur"
  static const int dwlOwnershipUnknown = 99;

  //DwlOccupancy, "name": "99 | Përdorimi nuk dihet"
  static const int dwlOccupancyUnknown = 99;

  //DwlToilet, "name": "99 | Lloji i tualetit i panjohur"
  static const int dwlToiletUnknown = 99;

  //DwlBath, "name": "9 | I panjohur"
  static const int dwlBathUnknown = 9;

  //DwlHeatingFacility, "name": "99 | Lloji i ngrohjes i panjohur",
  static const int dwlHeatingFacilityUnkown = 99;

  //DwlHeatingEnergy, "name": "99 | Lloji i energjisë për ngrohje i panjohur"
  static const int dwlHeatingEnergyUnkown = 99;

  //DwlAirConditioner, "name": "9 | I panjohur"
  static const int dwlAirConditionerUnkown = 9;

  //DwlSolarPanel, "name": "9 | I panjohur"
  static const int dwlSolarPanelUnkown = 9;

  //BldReview, "name": "2 | Rishikimi i aprovuar",
  static const int reviewApproved = 2;

  //BldReview, "name": "3 | Rishikimi i ekzekutuar",
  static const int reviewExecuted = 3;

  //BldQuality, "name": "1 | Të dhëna pa gabime",
  static const int dataWithoutErrors = 1;

  //BldReview, "name": "6 | Kërkohet rishikim"
  static const int reviewRequired = 6;

  //BldReview, "name": "5 | Rishikimi i rihapur"
  static const int reviewReopened = 5;

  //BldReview, "name": "4 | Rishikimi në pritje"
  static const int pendingReview = 4;

  // --- BldQuality / EntQuality / DwlQuality (ArcGIS domain "dm_quality") ---
  // Derived by the QMS from the worst quality action found on the building and
  // its entrances and dwellings: none -> 1, ADR -> 2, MISS -> 3,
  // QUE/ERR -> 4, ESS -> 5.

  //"0 | Të dhëna të fshira"
  static const int qualityDeleted = 0;

  //"1 | Të dhëna pa gabime"
  static const int qualityErrorFree = 1;

  //"2 | Të dhëna statistikore pa gabime"
  static const int qualityStatisticalErrorFree = 2;

  //"3 | Mungesa në të dhënat statistikore"
  static const int qualityStatisticalGaps = 3;

  //"4 | Të dhëna statistikore kontradiktore"
  static const int qualityStatisticalInconsistent = 4;

  //"5 | Të dhëna jo të gatshme për statistika"
  static const int qualityNotReadyForStatistics = 5;

  //"9 | Të dhëna të patestuara"
  static const int qualityUntested = 9;

  /// Quality codes that mean the data still needs work before it can be used
  /// for statistics (statuses 3, 4 and 5).
  static const List<int> qualityProblemCodes = [
    qualityStatisticalGaps,
    qualityStatisticalInconsistent,
    qualityNotReadyForStatistics,
  ];
}
