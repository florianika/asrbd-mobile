import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;

/// EPSG:6870 (Albania TM 2010) Coordinate Reference System configuration
///
/// This class provides all necessary configuration for using EPSG:6870 CRS
/// with flutter_map, including projection, resolutions, bounds, and CRS instance.
class Epsg6870Crs {
  Epsg6870Crs._(); // Private constructor to prevent instantiation

  /// EPSG:6870 projection definition
  static final proj4.Projection projection = proj4.Projection.add(
    'EPSG:6870',
    '+proj=tmerc +lat_0=0 +lon_0=20 +k=1 +x_0=500000 +y_0=0 '
        '+ellps=GRS80 +units=m +no_defs +type=crs',
  );

  /// Calculate resolutions from scale denominators
  /// Resolution = ScaleDenominator * 0.00028 (meters per pixel)
  static final List<double> resolutions = [
    2362355.915187724 * 0.00028, // zoom 0
    944942.3660750897 * 0.00028, // zoom 1
    472471.18303754483 * 0.00028, // zoom 2
    236235.59151877242 * 0.00028, // zoom 3
    94494.23660750895 * 0.00028, // zoom 4
    47247.118303754476 * 0.00028, // zoom 5
    23623.559151877238 * 0.00028, // zoom 6
    9449.423660750896 * 0.00028, // zoom 7
    4724.711830375448 * 0.00028, // zoom 8
    2362.355915187724 * 0.00028, // zoom 9
  ];

  /// CRS bounds in EPSG:6870 coordinates
  static final Bounds<double> bounds = Bounds<double>(
    const Point<double>(-5123200.0, -4511336.0), // bottom-left
    const Point<double>(4510883.0, 10002100.0), // top-right
  );

  /// Top-left corner origin from WMTS GetCapabilities
  static final Point<double> topLeftOrigin =
      const Point<double>(-5123200.0, 10002100.0);

  /// Custom CRS instance for EPSG:6870
  /// This handles ALL tile coordinate transformations automatically!
  static final Crs crs = Proj4Crs.fromFactory(
    code: 'EPSG:6870',
    proj4Projection: projection,
    resolutions: resolutions,
    bounds: bounds,
    origins: [topLeftOrigin],
  );

  /// Maximum zoom level based on available resolutions
  static final double maxZoom = 9.0; // (resolutions.length - 1).toDouble();
}
