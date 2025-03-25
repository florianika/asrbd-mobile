//
// Copyright 2024 Esri
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/enums/map_on_tap_type.dart';
import 'package:asrdb/features/home/presentation/widget/menu_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

class DownloadPreplannedMapArea extends StatefulWidget {
  const DownloadPreplannedMapArea({super.key});

  @override
  State<DownloadPreplannedMapArea> createState() =>
      _DownloadPreplannedMapAreaState();
}

class _DownloadPreplannedMapAreaState extends State<DownloadPreplannedMapArea>
    implements ArcGISAuthenticationChallengeHandler {
  // Create a controller for the map view.
  final _mapViewController = ArcGISMapView.createController();
  // Prepare an offline map task and map for the online web map.
  late OfflineMapTask _offlineMapTask;
  late ArcGISMap _webMap;
  // The location to save offline maps to.
  Directory? _downloadDirectory;
  // Create a Map to track preplanned map areas and their associated download jobs.
  final _preplannedMapAreas =
      <PreplannedMapArea, DownloadPreplannedOfflineMapJob?>{};
  // A flag for when the map view is ready and controls can be used.
  var _ready = false;
  // A flag for when the map selection UI should be displayed.
  var _mapSelectionVisible = false;

  bool showInfo = false;
  GeometryEditorTool? _selectedTool;
  final _geometryEditor = GeometryEditor();
  late final ServiceFeatureTable _polygonServiceFeatureTable;
  late final FeatureLayer _polygonFeatureLayer;
  var _isDrawingActive = false;
  var _canUndo = false;
  var _canRedo = false;
  var _isLoading = false;

  Feature? _selectedFeature;

  late final SimpleFillSymbol _polygonSymbol;
  late final PortalItem _portalItem;

  final _vertexTool = VertexTool();
  // final _freehandTool = FreehandTool();
  // final _rectangleShapeTool = ShapeTool(shapeType: ShapeToolType.rectangle);

  final _locationDataSource = SystemLocationDataSource();
  StreamSubscription? _locationSubscription;
  // A flag for when the map view is ready and controls can be used.

  @override
  void initState() {
    super.initState();

    _geometryEditor.tool = _vertexTool;
    ArcGISEnvironment
        .authenticationManager.arcGISAuthenticationChallengeHandler = this;
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

  @override
  void dispose() async {
    // Delete downloaded offline maps on exit.
    _downloadDirectory?.deleteSync(recursive: true);
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

  Future<void> identifyAndSelectFeature(Offset localPosition) async {
    // Disable the UI while the async operations are in progress.
    setState(() => _ready = false);

    try {
      var layers = _webMap.operationalLayers;
      _showMessageDialog(layers.length.toString());
      _showMessageDialog(layers[0].subLayerContents[0].name);

      FeatureLayer buildings = layers[0].subLayerContents[0] as FeatureLayer;
      // (layers.firstWhere((x) => x.id == "64658d3e33d74e6ab47fc0725f1e93af")
      //     as FeatureLayer);

      // Unselect any previously selected feature.
      // if (_selectedFeature != null) {
      //   buildings.unselectFeature(_selectedFeature!);

      //   setState(() {
      //     _selectedFeature = null;
      //   });
      // }

      // Perform an identify operation on the feature layer at the tapped location.
      final identifyResult = await _mapViewController.identifyLayer(
        buildings as Layer,
        screenPoint: localPosition,
        tolerance: 12.0,
        maximumResults: 1,
      );

      if (identifyResult.geoElements.isNotEmpty) {
        // If a feature is identified, select it.
        final feature = identifyResult.geoElements.first as ArcGISFeature;
        // buildings.
        buildings.selectFeature(feature);

        setState(() {
          _selectedFeature = feature;
          showInfo = true;
        });
      }
    } catch (error) {
      _showMessageDialog(error.toString());
    }
    // Re-enable the UI.
    setState(() => _ready = true);
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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  // Add a map view to the widget tree and set a controller.
                  child: ArcGISMapView(
                    controllerProvider: () => _mapViewController,
                    onMapViewReady: onMapViewReady,
                    onTap: (Offset offset) =>
                        onTapHandler(offset, OnTapType.featureSelected),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Create a button to open the map selection view.
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => _mapSelectionVisible = true),
                      child: const Text('Select Map'),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
                bottom: 20,
                right: 20,
                child: MenuOptions(
                  handleOnTap: onTapHandler,
                  isDrawing: _isDrawingActive,
                )),
            // Display the name of the current map.
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.black.withOpacity(0.7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // Use the name of the item if available.
                    _mapViewController.arcGISMap?.item?.title ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            // Display a progress indicator and prevent interaction until state is ready.
            Visibility(
              visible: !_ready,
              child: SizedBox.expand(
                child: Container(
                  color: Colors.white30,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
      // Display a list of available maps in a bottom sheet.
      bottomSheet:
          _mapSelectionVisible ? buildMapSelectionSheet(context) : null,
    );
  }

  void onMapViewReady() async {
    // Configure the directory to download offline maps to.
    _downloadDirectory = await createDownloadDirectory();

    // Create a map using a webmap from a portal item.
    final portal = Portal(Uri.parse(EsriConfig.portalUrl),
        connection: PortalConnection.authenticated);

    await portal.load();

    final licenseInfo = await portal.fetchLicenseInfo();

    ArcGISEnvironment.setLicenseUsingInfo(licenseInfo);

    _portalItem = PortalItem.withPortalAndItemId(
      portal: portal,
      itemId: EsriConfig.baseMapItemId,
    );

    await _portalItem.load();
    _webMap = ArcGISMap.withItem(_portalItem);

    // Create and load an offline map task using the portal item.
    _offlineMapTask = OfflineMapTask.withPortalItem(_portalItem);
    await _offlineMapTask.load();

    // Get the preplanned map areas from the offline map task and load each.
    final preplannedMapAreas = await _offlineMapTask.getPreplannedMapAreas();
    for (final mapArea in preplannedMapAreas) {
      await mapArea.load();
      // Add each map area as a key in the Map, setting the Job to null initially.
      _preplannedMapAreas[mapArea] = null;
    }

    // Initially set the web map to the map view controller.
    _mapViewController.arcGISMap = _webMap;

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

    // Upate the state with the preplanned map areas and set the UI state to ready.
    setState(() => _ready = true);
  }

  // Builds a map selection widget with a list of available maps.
  Widget buildMapSelectionSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20.0,
        20.0,
        20.0,
        max(
          20.0,
          View.of(context).viewPadding.bottom /
              View.of(context).devicePixelRatio,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Select Map', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _mapSelectionVisible = false),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          // Create a list tile for the web map.
          ListTile(
            title: const Text('Web Map (online)'),
            trailing: _mapViewController.arcGISMap == _webMap
                ? const Icon(Icons.check)
                : null,
            onTap: () => _mapViewController.arcGISMap != _webMap
                ? setMapAndViewpoint(_webMap)
                : null,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Preplanned Map Areas:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _preplannedMapAreas.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                child: buildMapAreaListTile(
                  _preplannedMapAreas.keys.toList()[index],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Builds a list tile for each preplanned area and updates the UI depending on the status of the job.
  Widget buildMapAreaListTile(PreplannedMapArea mapArea) {
    final title = Text(mapArea.portalItem.title);
    final job = _preplannedMapAreas[mapArea];

    // If a job has been associated with the preplanned area, check the status and display the relevant UI.
    if (job != null) {
      if (job.status == JobStatus.started) {
        return ListTile(
          enabled: false,
          title: title,
          trailing: Column(
            children: [
              // When the job is started, display the progress.
              CircularProgressIndicator(value: job.progress.toDouble() / 100.0),
              Text('${job.progress}%'),
            ],
          ),
        );
      } else if (job.status == JobStatus.succeeded && job.result != null) {
        // When the job has succeeded, get the result and then get the map from the result.
        final map = job.result!.offlineMap;
        return ListTile(
          title: title,
          trailing: _mapViewController.arcGISMap == map
              ? const Icon(Icons.check)
              : null,
          onTap: () => setMapAndViewpoint(map),
        );
      } else if (job.status == JobStatus.failed) {
        return ListTile(
          enabled: false,
          title: title,
          trailing: const Icon(Icons.error),
        );
      }
    }

    // Otherwise display a default list tile to initiate downloading the offline map.
    return ListTile(
      title: title,
      trailing: const Icon(Icons.download),
      onTap: () => downloadOfflineMap(mapArea),
    );
  }

  // Download an offline map for a provided preplanned map area.
  void downloadOfflineMap(PreplannedMapArea mapArea) async {
    // Create default parameters using the map area.
    final defaultDownloadParams = await _offlineMapTask
        .createDefaultDownloadPreplannedOfflineMapParameters(mapArea);

    // Set the required update mode. This sample map is not setup for updates so we use noUpdates.
    defaultDownloadParams.updateMode = PreplannedUpdateMode.noUpdates;

    // Create a directory for the map in the downloads directory.
    final mapDir = Directory(
      '${_downloadDirectory!.path}${Platform.pathSeparator}${mapArea.portalItem.title}',
    );
    mapDir.createSync();

    // Create and run a job to download the offline map using the default params and download path.
    final downloadMapJob =
        _offlineMapTask.downloadPreplannedOfflineMapWithParameters(
      parameters: defaultDownloadParams,
      downloadDirectoryUri: mapDir.uri,
    );

    // Associate the job with the map area and update the UI.
    setState(() => _preplannedMapAreas[mapArea] = downloadMapJob);
    // Update the UI when the progress changes.
    downloadMapJob.onProgressChanged.listen((_) => setState(() {}));
    downloadMapJob.run();
  }

  // Create the directory for downloading offline map areas into.
  Future<Directory> createDownloadDirectory() async {
    final documentDir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory(
      '${documentDir.path}${Platform.pathSeparator}preplanned_map_sample',
    );
    if (downloadDir.existsSync()) {
      downloadDir.deleteSync(recursive: true);
    }
    downloadDir.createSync();
    return downloadDir;
  }

  // Sets the provided map to the map view and updates the viewpoint.
  void setMapAndViewpoint(ArcGISMap map) {
    // Set the map to the map view and update the UI to reflect the newly selected map.
    _mapViewController.arcGISMap = map;
    setState(() {});

    if (map != _webMap) {
      // If the map is one of the offline maps,
      // build an envelope zoomed into the extent of the map to better see the features.
      final envBuilder = EnvelopeBuilder.fromEnvelope(
        map.initialViewpoint!.targetGeometry.extent,
      )..expandBy(0.5);
      final viewpoint = Viewpoint.fromTargetExtent(envBuilder.toGeometry());
      // Set the viewpoint to the mapview controller.
      _mapViewController.setViewpoint(viewpoint);
    }
  }
}
