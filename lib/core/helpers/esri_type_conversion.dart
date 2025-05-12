class EsriTypeConversion {
  static dynamic convert(String esriType, dynamic value) {
    switch (esriType) {
      case 'esriFieldTypeBigInteger':
        return BigInt.from(value);
      case 'esriFieldTypeDate':
        throw UnimplementedError('Date conversion not implemented');
      case 'esriFieldTypeDouble':
      case 'esriFieldTypeSingle':
        return double.parse(value.toString());
      case 'esriFieldTypeInteger':
      case 'esriFieldTypeOID':
      case 'esriFieldTypeSmallInteger':
        return int.parse(value.toString());
      case 'geometry':
        return 'esriFieldTypeGeometry';
      default:
        return value.toString();
    }
  }
}
