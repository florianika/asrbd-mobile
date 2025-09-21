class EsriTypeConversion {
  static dynamic convert(String esriType, dynamic value) {
    switch (esriType) {
      case 'esriFieldTypeBigInteger':
        return value != '' ? BigInt.from(value) : null;
      case 'esriFieldTypeDate':
        throw UnimplementedError('Date conversion not implemented');
      case 'esriFieldTypeDouble':
      case 'esriFieldTypeSingle':
        return double.parse(value.toString());
      case 'esriFieldTypeInteger':
      case 'esriFieldTypeOID':
      case 'esriFieldTypeSmallInteger':
        return value != '' ? int.parse(value.toString()) : null;
      case 'geometry':
        return 'esriFieldTypeGeometry';
      default:
        return value.toString();
    }
  }
}
