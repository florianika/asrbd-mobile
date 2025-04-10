import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class OfflineMap extends StatefulWidget {
  @override
  _OfflineMapState createState() => _OfflineMapState();
}

class _OfflineMapState extends State<OfflineMap> {
  late String tileDirPath;
  bool isInitialized = false;
  bool isDownloading = false;
  bool loadingData = false;
  bool isDrawing = false;
  Map<String, dynamic>? vanillaGeoJson;
  List<LatLng> _newPolygonPoints = [];
  MapController mapController = MapController();

  GeoJsonParser geoJsonParser = GeoJsonParser(
    defaultMarkerColor: Colors.red,
    defaultPolygonBorderColor: Colors.red,
    defaultPolygonFillColor: Colors.red.withOpacity(0.1),
    defaultCircleMarkerColor: Colors.red.withOpacity(0.25),
  );

  @override
  void initState() {
    super.initState();
    _initialize();

    _loadGeoJsonData().then((_) {
      setState(() {
        loadingData = false;
      });
    });

    // hitNotifier.addListener(handleTap);
  }

  void _showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Popup Message"),
          content: Text(message), // Display the passed string
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void handleOnTap(TapPosition tapPosition, LatLng point) {
    try {
      var selectedFeatureManual = geoJsonParser.polygons
          .where(
            (feature) => _isPointInPolygon(point, feature.points),
          )
          .firstOrNull;

      if (selectedFeatureManual != null) {
        var response = findPolygonPropertiesByCoordinates(
            vanillaGeoJson!, selectedFeatureManual.points);
        if (response != null)
          _showPopup(context, response!['BldQuality'].toString());
        else
          _showPopup(context, "proprety not found");
      }
    } catch (e) {
      _showPopup(context, e.toString());
    }
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

  Future<void> _loadGeoJsonData() async {
    try {
      // Load GeoJSON from assets
      const token =
          '1nqXSOCvuOn3RMZ1lazgKicryBrHcsXzrO_uisu9wazxWkJOcSKBut3nrG7gSO_0mv7OGqIibp2qg7Xcm6RXnskbdEfywH1EXRpZE_owhkcKpninDxMVAsEsvXEhPD0ktJLF8-svgqnKzxUccf8xTxR0wqtIqnXAV2yLHGs2Uwk.';
      var dio = Dio();

      var response = await dio.get(
          'https://salstatstaging.tddev.it/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/1/query?where=1%3D1&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&defaultSR=&spatialRel=esriSpatialRelIntersects&distance=&units=esriSRUnit_Foot&relationParam=&outFields=BldQuality&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&havingClause=&gdbVersion=&historicMoment=&returnDistinctValues=false&returnIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&multipatchOption=xyFootprint&resultOffset=&resultRecordCount=&returnTrueCurves=false&returnExceededLimitFeatures=false&quantizationParameters=&returnCentroid=false&timeReferenceUnknownClient=false&maxRecordCountFactor=&sqlFormat=none&resultType=&featureEncoding=esriDefault&datumTransformation=&f=geojson&token=$token');
      vanillaGeoJson = response.data;
      geoJsonParser.parseGeoJson(response.data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading GeoJSON: $e')),
      );
    }
  }

  Map<String, dynamic>? findPolygonPropertiesByCoordinates(
      Map<String, dynamic> geoJson, List<LatLng> searchCoordinates) {
    for (var feature in geoJson['features']) {
      var geom = feature['geometry'];

      if (geom['type'] == 'Polygon') {
        var polygonCoordinates =
            geom['coordinates'][0]; // Outer boundary coordinates

        // Convert polygon coordinates to LatLng list
        List<LatLng> polygonLatLngList = polygonCoordinates
            .map<LatLng>((coords) => LatLng(coords[1],
                coords[0])) // Converting [longitude, latitude] to LatLng
            .toList();

        // Compare the LatLng list (ignoring the order for simplicity)
        if (_compareLatLngLists(polygonLatLngList, searchCoordinates)) {
          return feature['properties'];
        }
      }
    }
    return null; // Return null if no matching polygon is found
  }

// Helper function to compare two lists of LatLng objects
  bool _compareLatLngLists(List<LatLng> list1, List<LatLng> list2) {
    if (list1.length != list2.length) return false;

    // Compare each LatLng element
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].latitude != list2[i].latitude ||
          list1[i].longitude != list2[i].longitude) {
        return false;
      }
    }
    return true;
  }

  Future<void> _initialize() async {
    Directory tileDir = await getApplicationDocumentsDirectory();
    tileDirPath = '${tileDir.path}/tiles';
    setState(() => isInitialized = true);
  }

  Future<void> startDownload() async {
    setState(() => isDownloading = true);

    TileDownloader downloader = TileDownloader();
    //40.534406,19.6338131
    await downloader.downloadTiles(
      minLat: 40.532495, maxLat: 40.5346641, // Min & Max Latitude
      minLng: 19.6342099, maxLng: 19.6346445, // Min & Max Longitude
      minZoom: 10, maxZoom: 15, // Zoom levels
    );

    setState(() => isDownloading = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Download Complete!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offline Map")),
      body: isInitialized
          ? Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(40.534406, 19.6338131),
                    initialZoom: 13.0,
                    onTap: (tapPosition, point) => {
                      if (!isDrawing)
                        handleOnTap(tapPosition, point)
                      else
                        _onAddPolygon(point)
                    },
                  ),
                  children: [
                    TileLayer(
                      tileProvider: FileTileProvider(tileDirPath),
                    ),
                    PolygonLayer(
                      polygons: geoJsonParser.polygons,
                    ),
                    PolygonLayer(
                      polygons: [
                        Polygon(
                          points: _newPolygonPoints,
                          color: Colors.blue.withOpacity(0.4),
                          borderColor: Colors.blue,
                          borderStrokeWidth: 2,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: _buildMarkers(),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton.extended(
                    onPressed: isDownloading ? null : startDownload,
                    label: isDownloading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Download Tiles"),
                    icon: const Icon(Icons.download),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 50,
                  child: FloatingActionButton.extended(
                    onPressed: () => {
                      setState(() {
                        isDrawing = !isDrawing;
                      })
                    },
                    label: Text(isDrawing ? "Draw Polygon" : "Drawing"),
                    icon: const Icon(Icons.draw),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void _onAddPolygon(LatLng position) {
    setState(() {
      _newPolygonPoints.add(position);
    });
  }

  // List<Marker> _buildMarkers() {
  //   return _newPolygonPoints.map((point) {
  //     return Marker(
  //       width: 30.0,
  //       height: 30.0,
  //       point: point,
  //       child: GestureDetector(
  //         onPanUpdate: (details) {
  //          setState(() {

  //           // final screenPoint = mapController.camera.latLngToScreenPoint(point);

  //           // final newPoint = mapController.camera.pointToLatLng(
  //           //   screenPoint,
  //           // );

  //           //   int index = _newPolygonPoints.indexOf(point);
  //           //   _newPolygonPoints[index] = newPoint;
  //           //
  //             int index = _newPolygonPoints.indexOf(point);
  //             final RenderBox box = context.findRenderObject() as RenderBox;
  //            final localPosition = box.globalToLocal(details.globalPosition);

  //            final newPoint = mapController.camera.pointToLatLng(
  //             Point(localPosition.dx, localPosition.dy)
  //           );

  //           // Update the point in the list
  //           _newPolygonPoints[index] = newPoint;
  //           });
  //         },
  //         child: const Icon(Icons.circle, size: 20, color: Colors.red),
  //       ),
  //     );
  //   }).toList();
  // }

  List<Marker> _buildMarkers() {
    return _newPolygonPoints.map((point) {
      return Marker(
        width: 50.0,
        height: 50.0,
        point: point,
        child: Draggable(
          feedback: Icon(Icons.circle, size: 20, color: Colors.red.withOpacity(0.5)),
          childWhenDragging: Container(), // Hide original marker during drag
          onDragEnd: (details) {
            setState(() {
              int index = _newPolygonPoints.indexOf(point);

              // Get the RenderBox of the map
              final RenderBox mapRenderBox = context.findRenderObject() as RenderBox;

              // Get the top-left position of the map in global coordinates
              final mapPosition = mapRenderBox.localToGlobal(Offset.zero);

              // Convert global drag position to local map-relative position
              final localDropPosition = details.offset - mapPosition;

              // Convert local screen position to LatLng
              final newPoint = mapController.camera.pointToLatLng(
                Point(localDropPosition.dx, localDropPosition.dy),
              );

              // Update the point in the polygon list
              _newPolygonPoints[index] = newPoint;
            });
          },
          child: const Icon(Icons.circle, size: 20, color: Colors.red),
        ),
      );
    }).toList();
  }
}

class FileTileProvider extends TileProvider {
  final String tileDirPath;

  FileTileProvider(this.tileDirPath);

  @override
  ImageProvider<Object> getImage(
      TileCoordinates coordinates, TileLayer options) {
    String filePath =
        "$tileDirPath/${coordinates.z}/${coordinates.x}/${coordinates.y}.png";
    File file = File(filePath);

    if (file.existsSync()) {
      return FileImage(file);
    } else {
      String url =
          "https://tile.openstreetmap.org/${coordinates.z}/${coordinates.x}/${coordinates.y}.png";
      return NetworkImage(url);
    }
  }
}

class TileDownloader {
  final Dio dio = Dio();
  late Directory tileDir;

  Future<void> initialize() async {
    tileDir = await getApplicationDocumentsDirectory();
  }

  Future<void> downloadTiles({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
    required int minZoom,
    required int maxZoom,
  }) async {
    await initialize();

    for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
      int xStart = lngToTileX(minLng, zoom);
      int xEnd = lngToTileX(maxLng, zoom);
      int yStart = latToTileY(maxLat, zoom);
      int yEnd = latToTileY(minLat, zoom);

      for (int x = xStart; x <= xEnd; x++) {
        for (int y = yStart; y <= yEnd; y++) {
          String url = "https://tile.openstreetmap.org/$zoom/$x/$y.png";
          await saveTile(url, zoom, x, y);
        }
      }
    }
  }

  Future<void> saveTile(String url, int zoom, int x, int y) async {
    String dirPath = '${tileDir.path}/tiles/$zoom/$x';
    String filePath = '$dirPath/$y.png';

    File file = File(filePath);
    if (await file.exists()) return; // Skip if already downloaded

    try {
      var response = await dio.get(url,
          options: Options(responseType: ResponseType.bytes));
      await Directory(dirPath).create(recursive: true);
      await file.writeAsBytes(response.data);
      print("Downloaded: $filePath");
    } catch (e) {
      print("Failed to download $url: $e");
    }
  }

  int lngToTileX(double lng, int zoom) =>
      ((lng + 180) / 360 * (1 << zoom)).floor();
  int latToTileY(double lat, int zoom) {
    double latRad = lat * (pi / 180);
    return ((1 - (log(tan(latRad) + 1 / cos(latRad)) / pi)) / 2 * (1 << zoom))
        .floor();
  }
}
