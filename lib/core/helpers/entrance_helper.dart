class EntranceHelper {
  static String? entranceLabel(
      String? entBuildingNumber, String? entEntranceNumber) {
    if (entBuildingNumber != null && entEntranceNumber != null) {
      return '$entBuildingNumber-$entEntranceNumber';
    }
    return entBuildingNumber ?? entEntranceNumber;
  }
}
