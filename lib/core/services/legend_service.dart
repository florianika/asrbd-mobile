import 'dart:convert';
import 'package:asrdb/core/enums/legent_type.dart';
import 'package:asrdb/core/models/legend/legend.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

class LegendService {
  final Map<LegendType, Map<String, List<Legend>>> _legendData = {};

  Future<void> loadLegendConfigs() async {
    await Future.wait([
      _loadConfigFile(
          'assets/legend/building_legend_config.json', LegendType.building),
      _loadConfigFile(
          'assets/legend/entrance_legend_config.json', LegendType.entrance),
    ]);
  }

  Future<void> _loadConfigFile(String path, LegendType type) async {
    final String jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> data = jsonDecode(jsonString);

    final Map<String, List<Legend>> parsed = data.map((styleKey, items) {
      final legendList = (items as Map<String, dynamic>).entries.map((entry) {
        final label = entry.key;
        final config = entry.value as Map<String, dynamic>;
        return Legend(
          label: label,
          color: hexToColor(config['color']).withOpacity(0.5),
          value: config['value'],
        );
      }).toList();
      return MapEntry(styleKey, legendList);
    });

    _legendData[type] = parsed;
  }

  List<Legend> getLegendForStyle(LegendType type, String styleAttribute) {
    return _legendData[type]?[styleAttribute] ??
        _legendData[type]?['DEFAULT'] ??
        [];
  }

  Color? getColorForValue(LegendType type, String styleAttribute, int value) {
    final legends = getLegendForStyle(type, styleAttribute);
    final match = legends.firstWhere(
      (legend) => legend.value.toString() == value.toString(),
      orElse: () => Legend(label: '', color: Colors.transparent, value: -999),
    );
    return match.value == -999 ? null : match.color;
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  static Color hexToColor(String hexString, [double alpha = 1.0]) {
    // Clean the hex string
    String cleanHex = hexString.replaceAll('#', '').toUpperCase();
    
    // Handle 3-digit hex codes (expand to 6 digits)
    if (cleanHex.length == 3) {
      cleanHex = cleanHex.split('').map((char) => char + char).join();
    }
    
    // Validate hex string
    if (cleanHex.length != 6) {
      throw ArgumentError('Invalid hex color format. Expected format: #RRGGBB or RRGGBB');
    }
    
    // Clamp alpha value
    alpha = alpha.clamp(0.0, 1.0);
    
    // Convert alpha to 0-255 range
    int alphaInt = (alpha * 255).round();
    
    // Parse RGB values
    int red = int.parse(cleanHex.substring(0, 2), radix: 16);
    int green = int.parse(cleanHex.substring(2, 4), radix: 16);
    int blue = int.parse(cleanHex.substring(4, 6), radix: 16);
    
    return Color.fromARGB(alphaInt, red, green, blue);
  }
}
