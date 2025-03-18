import 'dart:async';

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/enums/map_on_tap_type.dart';
import 'package:flutter/material.dart';
import 'package:asrdb/core/constants/app_config.dart';
import 'package:asrdb/features/home/presentation/layout/home_mobile.dart';
import 'package:asrdb/features/home/presentation/layout/home_tablet.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    implements ArcGISAuthenticationChallengeHandler {
  final ArcGISMapViewController _mapViewController =
      ArcGISMapView.createController();
  Feature? _selectedFeature;
  late final FeatureLayer _portalItemFeatureLayer;
  bool showInfo = false;
  GeometryEditorTool? _selectedTool;
  final _geometryEditor = GeometryEditor();
  late final ServiceFeatureTable _polygonServiceFeatureTable;
  late final FeatureLayer _polygonFeatureLayer;
  var _isDrawingActive = false;
  var _canUndo = false;
  var _canRedo = false;
  var _isLoading = false;

  late final SimpleFillSymbol _polygonSymbol;

  // Create drawing tools
  final _vertexTool = VertexTool();
  // final _freehandTool = FreehandTool();
  // final _rectangleShapeTool = ShapeTool(shapeType: ShapeToolType.rectangle);

  final _locationDataSource = SystemLocationDataSource();
  StreamSubscription? _locationSubscription;
  // A flag for when the map view is ready and controls can be used.
  var _ready = false;

  final _oauthUserConfiguration = OAuthUserConfiguration(
    portalUri: Uri.parse(EsriConfig.portalUrl),
    clientId: EsriConfig.clientId,
    redirectUri: Uri.parse(EsriConfig.redirectUrl),
  );

  @override
  void initState() {
    super.initState();
    // _mapViewController = ArcGISMapView.createController();
    // _selectedTool = _vertexTool;
    _geometryEditor.tool = _vertexTool;
    ArcGISEnvironment
        .authenticationManager.arcGISAuthenticationChallengeHandler = this;
  }

  @override
  void dispose() async {
    _locationDataSource.stop();
    _locationSubscription?.cancel();

    ArcGISEnvironment
        .authenticationManager.arcGISAuthenticationChallengeHandler = null;
    super.dispose();

    // Revoke OAuth tokens and remove all credentials to log out.
    await Future.wait(
      ArcGISEnvironment.authenticationManager.arcGISCredentialStore
          .getCredentials()
          .whereType<OAuthUserCredential>()
          .map((credential) => credential.revokeToken()),
    );
    ArcGISEnvironment.authenticationManager.arcGISCredentialStore.removeAll();
  }

  @override
  void handleArcGISAuthenticationChallenge(
    ArcGISAuthenticationChallenge challenge,
  ) async {
    //TODO: fetch credentials from auth service
    challenge.continueWithCredential(await TokenCredential.createWithChallenge(
      challenge,
      username: dotenv.env['ESRI_USERNAME'] ?? "",
      password: dotenv.env['ESRI_PASSWORD'] ?? "",
    ));
  }

  Future<void> onMapViewReady() async {
    final portal = Portal(Uri.parse(EsriConfig.portalUrl),
        connection: PortalConnection.authenticated);

    final portalItem = PortalItem.withPortalAndItemId(
      portal: portal,
      itemId: EsriConfig.baseMapItemId,
    );
    await portalItem.load();

    final portalItemBuilding = PortalItem.withPortalAndItemId(
        portal: portal, itemId: EsriConfig.dataItemId);
    await portalItemBuilding.load();

    _portalItemFeatureLayer = FeatureLayer.withItem(
      item: portalItemBuilding,
      layerId: EsriConfig.buildingLayerId,
    );
    await _portalItemFeatureLayer.load();

    final map = ArcGISMap.withItem(portalItem);
    map.operationalLayers.add(_portalItemFeatureLayer);
    _mapViewController.arcGISMap = map;

    //open map to the default location, then will try to change to the users location
    _mapViewController.setViewpoint(
      Viewpoint.withLatLongScale(
        latitude: EsriConfig.defaultLatitude,
        longitude: EsriConfig.defaultLongitude,
        scale: EsriConfig.scale,
      ),
    );

    try {
      // Start the location data source just to get the initial position
      await _locationDataSource.start();

      // Listen for the first location update
      _locationSubscription =
          _locationDataSource.onLocationChanged.listen((location) async {
        // Once we have a location, cancel the subscription since we only need one update
        await _locationSubscription?.cancel();
        _locationSubscription = null;

        // Center the map at the current location with a reasonable zoom level
        final point = location.position;

        _mapViewController.setViewpoint(
          Viewpoint.fromCenter(
            point,
            scale: EsriConfig.scale,
          ),
        );

        // Stop the location data source as we don't need it anymore
        await _locationDataSource.stop();
      });
    } on ArcGISException catch (e) {}

    ServiceGeodatabase serviceGeodatabase;
    try {
      serviceGeodatabase =
          ServiceGeodatabase.withPortalItem(portalItemBuilding);
      await serviceGeodatabase.load();

      // // Get the feature table from the service geodatabase
      _polygonServiceFeatureTable =
          serviceGeodatabase.getTable(layerId: EsriConfig.buildingLayerId)!;
      await _polygonServiceFeatureTable.load();

      _polygonFeatureLayer =
          FeatureLayer.withFeatureTable(_polygonServiceFeatureTable);
    } catch (e) {
      _showMessageDialog('Error _polygonServiceFeatureTable: $e');
    }

    // Add the graphics overlay

    // Configure polygon symbol
    final outlineSymbol = SimpleLineSymbol(
      style: SimpleLineSymbolStyle.solid,
      color: Colors.black,
      width: 2,
    );
    _polygonSymbol = SimpleFillSymbol(
      style: SimpleFillSymbolStyle.solid,
      color: Colors.blue.withOpacity(0.3),
      outline: outlineSymbol,
    );

    // Configure geometry editor
    // _geometryEditor.tool = _vertexTool;

    // Listen to geometry editor state changes
    _geometryEditor.onCanUndoChanged.listen((canUndo) {
      setState(() => _canUndo = canUndo);
    });

    _geometryEditor.onCanRedoChanged.listen((canRedo) {
      setState(() => _canRedo = canRedo);
    });

    _geometryEditor.onIsStartedChanged.listen((isStarted) {
      setState(() => _isDrawingActive = isStarted);
    });

    // Set the geometry editor to the map view
    _mapViewController.geometryEditor = _geometryEditor;

    setState(() => _ready = true);
  }

  void _savePolygon() async {
    try {
      // Get the geometry from the editor
      final geometry = _geometryEditor.stop();

      if (geometry != null) {
        // Create a feature
        final feature = _polygonServiceFeatureTable.createFeature();

        // Normalize the geometry (handles date line crossing)
        final normalizedGeometry =
            GeometryEngine.normalizeCentralMeridian(geometry);
        feature.geometry = normalizedGeometry;

        feature.attributes['BldQuality'] = 1;
        feature.attributes['BldMunicipality'] = "01";
        feature.attributes['BldLatitude'] = 0.0;
        feature.attributes['BldLongitude'] = 0.0;
        feature.attributes['BldStatus'] = 1;
        feature.attributes['BldType'] = 9;
        feature.attributes['BldCentroidStatus'] = 5;

        // Add feature to the local table
        await _polygonFeatureLayer.featureTable!.addFeature(feature);

        // Apply edits to sync with the server
        await _polygonServiceFeatureTable.serviceGeodatabase!.applyEdits();

        // Update the feature to get the server-assigned objectID
        feature.refresh();

        _showMessageDialog('Polygon saved successfully!');
      } else {
        _showMessageDialog('Error: No valid polygon geometry');
      }
    } catch (e) {
      _showMessageDialog('Error saving polygon: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> identifyAndSelectFeature(Offset localPosition) async {
    // Disable the UI while the async operations are in progress.
    setState(() => _ready = false);

    // Unselect any previously selected feature.
    if (_selectedFeature != null) {
      _portalItemFeatureLayer.unselectFeature(_selectedFeature!);
      setState(() {
        _selectedFeature = null;
      });
    }

    // Perform an identify operation on the feature layer at the tapped location.
    final identifyResult = await _mapViewController.identifyLayer(
      _portalItemFeatureLayer,
      screenPoint: localPosition,
      tolerance: 12.0,
      maximumResults: 1,
    );

    if (identifyResult.geoElements.isNotEmpty) {
      // If a feature is identified, select it.
      final feature = identifyResult.geoElements.first as ArcGISFeature;
      _portalItemFeatureLayer.selectFeature(feature);
      setState(() {
        _selectedFeature = feature;
        showInfo = true;
      });
    }
    // Re-enable the UI.
    setState(() => _ready = true);
  }

  void onTapHandler(Offset? localPosition, OnTapType tapType) async {
    if (tapType == OnTapType.featureSelected) {
      await identifyAndSelectFeature(localPosition!);
    } else if (tapType == OnTapType.addBuilding) {
      _geometryEditor.startWithGeometryType(GeometryType.polygon);
    } else if (tapType == OnTapType.undo) {
      _geometryEditor.undo();
    } else if (tapType == OnTapType.redo) {
      _geometryEditor.redo();
    } else if (tapType == OnTapType.save) {
      _savePolygon();

      setState(() {
        _isDrawingActive = false;
      });
    } else if (tapType == OnTapType.cancel) {
      _geometryEditor.stop();

      setState(() {
        _isDrawingActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppConfig.tabletBreakpoint) {
          return HomeMobile(
            mapViewController: _mapViewController,
            onMapViewReady: onMapViewReady,
            itemData: _selectedFeature,
            showInfo: showInfo,
            onTapHandler: onTapHandler,
            isDrawing: _isDrawingActive,
          ); // Mobile layout
        } else {
          return HomeTablet(
            mapViewController: _mapViewController,
            onMapViewReady: onMapViewReady,
            itemData: _selectedFeature,
            showInfo: showInfo,
            onTapHandler: onTapHandler,
          ); // Tablet layout
        }
      },
    ));
  }
}
