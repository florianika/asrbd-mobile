import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:math' as math;

class OfflineMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Maps Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OfflineMapPage(),
    );
  }
}

class OfflineMapPage extends StatefulWidget {
  @override
  _OfflineMapPageState createState() => _OfflineMapPageState();
}

class _OfflineMapPageState extends State<OfflineMapPage> {
  late MapController _mapController;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  bool loadingData = true;

  

  // Define the area to download (latitude, longitude, zoom level)
  final LatLng _centerPoint =
      const LatLng(40.5334645, 19.6263321); // New York City
  final int _minZoom = 10;
  final int _maxZoom = 15;

  GeoJsonParser geoJsonParser = GeoJsonParser(
    defaultMarkerColor: Colors.red,
    defaultPolygonBorderColor: Colors.red,
    defaultPolygonFillColor: Colors.red.withOpacity(0.1),
    defaultCircleMarkerColor: Colors.red.withOpacity(0.25),
  );
 
  // List<GeoJsonFeature> _features = [];

  bool myFilterFunction(Map<String, dynamic> properties) {
    _showPopup(context, "okkk");
    return false;
  }

  @override
  void initState() {
    _mapController = MapController();
    // geoJsonParser.filterFunction = myFilterFunction;

    _loadGeoJsonData().then((_) {
      setState(() {
        loadingData = false;
      });
    });
    super.initState();
  }

  void onTapMarkerFunction(Map<String, dynamic> map) {
    _showPopup(context, 'clicked');
    // ignore: avoid_print
    print('onTapMarkerFunction: $map');
  }

  Future<void> _loadGeoJsonData() async {
    try {
      // Load GeoJSON from assets
      const token =
          'WKWZqugoyjzbyFNAW3Jq54zwWp0ooyQwkCuy6zyBN_8eQ34DSHN2Eqg9OaGlVEUI5PgvhOF_1gWEyb7RqzG6GCINNG19bw40szUGtL22uMdm7iA6SIhClHr658sLktdcLUia0suEKY2i1bDiaKquOKwDUoDy_s2DUXm_zVAExBI.';
      var dio = Dio();

      var response = await dio.get(
          'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/1/query?where=1%3D1&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&defaultSR=&spatialRel=esriSpatialRelIntersects&distance=&units=esriSRUnit_Foot&relationParam=&outFields=BldQuality&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&havingClause=&gdbVersion=&historicMoment=&returnDistinctValues=false&returnIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&multipatchOption=xyFootprint&resultOffset=&resultRecordCount=&returnTrueCurves=false&returnExceededLimitFeatures=false&quantizationParameters=&returnCentroid=false&timeReferenceUnknownClient=false&maxRecordCountFactor=&sqlFormat=none&resultType=&featureEncoding=esriDefault&datumTransformation=&f=geojson&token=$token');

     
      geoJsonParser.parseGeoJson(response.data);
    } catch (e) {
      print('Error loading GeoJSON: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading GeoJSON: $e')),
      );
    }
  }

  Future<void> _downloadOfflineTiles() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      // Get the application documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String offlineMapPath = '${appDocDir.path}/offline_tiles';

      // Create directory if it doesn't exist
      await Directory(offlineMapPath).create(recursive: true);

      // Calculate tile coordinates for the specified area and zoom levels
      for (int zoom = _minZoom; zoom <= _maxZoom; zoom++) {
        final bounds = _calculateTileBounds(_centerPoint, zoom);

        for (int x = bounds['minX']!; x <= bounds['maxX']!; x++) {
          for (int y = bounds['minY']!; y <= bounds['maxY']!; y++) {
            // Construct tile URL (using OpenStreetMap for this example)
            final tileUrl = 'https://a.tile.openstreetmap.org/$zoom/$x/$y.png';

            // Create tile file path
            final tilePath = '$offlineMapPath/$zoom/$x/$y.png';

            // Create nested directories
            await Directory('$offlineMapPath/$zoom/$x').create(recursive: true);

            // Download tile
            await Dio().download(tileUrl, tilePath);

            // Update progress
            setState(() {
              _downloadProgress += 1 /
                  ((bounds['maxX']! - bounds['minX']! + 1) *
                      (bounds['maxY']! - bounds['minY']! + 1) *
                      (_maxZoom - _minZoom + 1));
            });
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Offline map downloaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading offline map: $e')),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Map<String, int> _calculateTileBounds(LatLng center, int zoom) {
    // Helper method to calculate tile coordinates for a given point and zoom level
    final tileSize = 256; // Standard tile size
    final worldSize = tileSize * math.pow(2, zoom);

    // Calculate tile coordinates for the center point
    final centerTileX =
        ((center.longitude + 180.0) / 360.0 * worldSize).floor();
    final centerTileY = ((1.0 -
                math.log(math.tan(center.latitude * pi / 180.0) +
                        1.0 / math.cos(center.latitude * pi / 180.0)) /
                    pi) /
            2.0 *
            worldSize)
        .floor();

    // Define a small area around the center point (e.g., 5x5 tiles)
    return {
      'minX': centerTileX - 2,
      'maxX': centerTileX + 2,
      'minY': centerTileY - 2,
      'maxY': centerTileY + 2,
    };
  }

  final ValueNotifier<Object?> hitNotifier = ValueNotifier<Object?>(null);

  List<LatLng> _convertCoordinates(List<LatLng> coordinates) {
    return coordinates
        .map<LatLng>((coord) => LatLng(coord.latitude, coord.longitude))
        .toList();
  }

  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; j = i++) {
      if (((polygon[i].latitude > point.latitude) !=
              (polygon[j].latitude > point.latitude)) &&
          (point.longitude <
              (polygon[j].longitude - polygon[i].longitude) *
                      (point.latitude - polygon[i].latitude) /
                      (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude)) {
        inside = !inside;
      }
    }
    return inside;
  }

  void _showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Popup Message"),
          content: Text(message), // Display the passed string
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _handleMapTap(TapPosition tapPosition, LatLng point) {
    try {
      var selectedFeatureManual = geoJsonParser.polygons.firstWhere(
        (feature) => _isPointInPolygon(point, feature.points),
        //  orElse: () => null
      );

      if (selectedFeatureManual != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Selected Polygon (Turf):'),
        ));
      }
    } catch (e) {
      _showPopup(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Maps Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _centerPoint,
                initialZoom: 14.0,
                maxZoom: 18.0,
                minZoom: 3.0,
                onTap: _handleMapTap,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),

                if (!loadingData)
                  PolygonLayer(
                    polygons: geoJsonParser.polygons,
                  ),
                // if (!loadingData) MarkerLayer(markers: geoJsonParser.markers),
                // if (!loadingData) CircleLayer(circles: geoJsonParser.circles),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _isDownloading ? null : _downloadOfflineTiles,
              child: Text('Download Offline Map'),
            ),
          ),
          if (_isDownloading)
            LinearProgressIndicator(
              value: _downloadProgress,
            ),
        ],
      ),
    );
  }
}
