import 'package:asrdb/core/models/legend/legend.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CombinedLegendWidget extends StatefulWidget {
  final Map<String, List<Legend>> buildingLegends;
  final String initialBuildingAttribute;
  final List<Legend> entranceLegends;
  final Function onChange;
  final bool isSatellite;

  const CombinedLegendWidget({
    super.key,
    required this.buildingLegends,
    required this.initialBuildingAttribute,
    required this.entranceLegends,
    required this.onChange,
    required this.isSatellite,
  });

  @override
  State<CombinedLegendWidget> createState() => _CombinedLegendWidgetState();
}

class _CombinedLegendWidgetState extends State<CombinedLegendWidget>
    with TickerProviderStateMixin {
  late String _currentBuildingAttribute;
  bool _isBuildingSectionExpanded = true;
  bool _isEntranceSectionExpanded = false;
  bool _isWholeLegendExpanded = true;
  late AnimationController _buildingAnimationController;
  late AnimationController _entranceAnimationController;
  late AnimationController _legendAnimationController;
  late Animation<double> _buildingAnimation;
  late Animation<double> _entranceAnimation;
  
  final Set<String> _selectedBuildingLegendIds = {};

  @override
  void initState() {
    super.initState();
    _currentBuildingAttribute = widget.initialBuildingAttribute;

    _buildingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _entranceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _legendAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _buildingAnimation = CurvedAnimation(
      parent: _buildingAnimationController,
      curve: Curves.easeOut,
    );
    _entranceAnimation = CurvedAnimation(
      parent: _entranceAnimationController,
      curve: Curves.easeOut,
    );

    _buildingAnimationController.forward();
    _entranceAnimationController.reverse();
    _legendAnimationController.forward();
  }

  @override
  void dispose() {
    _buildingAnimationController.dispose();
    _entranceAnimationController.dispose();
    _legendAnimationController.dispose();
    super.dispose();
  }

  void _toggleBuildingSection() {
    setState(() {
      _isBuildingSectionExpanded = !_isBuildingSectionExpanded;
      if (_isBuildingSectionExpanded) {
        _buildingAnimationController.forward();
      } else {
        _buildingAnimationController.reverse();
      }
    });
  }

  void _toggleEntranceSection() {
    setState(() {
      _isEntranceSectionExpanded = !_isEntranceSectionExpanded;
      if (_isEntranceSectionExpanded) {
        _entranceAnimationController.forward();
      } else {
        _entranceAnimationController.reverse();
      }
    });
  }

  void _toggleWholeLegend() {
    setState(() {
      _isWholeLegendExpanded = !_isWholeLegendExpanded;
      if (_isWholeLegendExpanded) {
        _legendAnimationController.forward();
      } else {
        _legendAnimationController.reverse();
      }
    });
  }

  void _toggleBuildingLegendSelection(String legendId) {
    setState(() {
      if (_selectedBuildingLegendIds.contains(legendId)) {
        _selectedBuildingLegendIds.remove(legendId);
      } else {
        _selectedBuildingLegendIds.add(legendId);
      }
    });

    context.read<BuildingCubit>().filterBuildingsByLegends(
      _selectedBuildingLegendIds, 
      _currentBuildingAttribute
    );
  }

  void _clearAllSelections() {
    setState(() {
      _selectedBuildingLegendIds.clear();
    });

    context.read<BuildingCubit>().clearFilters();
  }

  String _getBuildingLegendId(Legend legend) {
    return legend.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final buildingLegend =
        widget.buildingLegends[_currentBuildingAttribute] ?? [];

    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: _isWholeLegendExpanded
            ? // Expanded Legend
            Container(
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate(Keys.legend),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF374151),
                            ),
                          ),
                          InkWell(
                            onTap: _toggleWholeLegend,
                            borderRadius: BorderRadius.circular(4),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.close,
                                color: Color(0xFF6B7280),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Buildings Section
                          _buildSection(
                            title: AppLocalizations.of(context)
                                .translate(Keys.legendBuildings),
                            isExpanded: _isBuildingSectionExpanded,
                            onToggle: _toggleBuildingSection,
                            animation: _buildingAnimation,
                            dropdown: DropdownButton<String>(
                              value: _currentBuildingAttribute,
                              underline: const SizedBox(),
                              isDense: true,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                              items: widget.buildingLegends.keys.map((attr) {
                                return DropdownMenuItem(
                                  value: attr,
                                  child: Text(
                                    attr[0].toUpperCase() + attr.substring(1),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    widget.onChange(val);
                                    _currentBuildingAttribute = val;
                                    _selectedBuildingLegendIds.clear();
                                  });
                                  context.read<BuildingCubit>().clearFilters();
                                }
                              },
                            ),
                            content: buildingLegend
                                .map((legend) => _buildBuildingLegendItem(
                                      legend,
                                      isSatellite: widget.isSatellite,
                                    ))
                                .toList(),
                            showClearButton: _selectedBuildingLegendIds.isNotEmpty,
                            onClear: _clearAllSelections,
                          ),

                          const SizedBox(height: 16),

                          // Entrances Section
                          _buildSection(
                            title: AppLocalizations.of(context)
                                .translate(Keys.legendEntrances),
                            isExpanded: _isEntranceSectionExpanded,
                            onToggle: _toggleEntranceSection,
                            animation: _entranceAnimation,
                            content: widget.entranceLegends
                                .map((legend) => _buildEntranceLegendItem(legend))
                                .toList(),
                            showClearButton: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : // Collapsed Floating Button
            FloatingActionButton(
                onPressed: _toggleWholeLegend,
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF374151),
                elevation: 3,
                child: const Icon(
                  Icons.info_outline,
                  size: 22,
                ),
              ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Animation<double> animation,
    Widget? dropdown,
    required List<Widget> content,
    bool showClearButton = false,
    VoidCallback? onClear,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
                Row(
                  children: [
                    if (dropdown != null) ...[
                      dropdown,
                      const SizedBox(width: 8),
                    ],
                    AnimatedRotation(
                      turns: isExpanded ? 0 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.expand_less,
                        color: Color(0xFF9CA3AF),
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: animation,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                ...content,
                if (showClearButton && onClear != null) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: onClear,
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.clear_all,
                            size: 16,
                            color: Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Clear All',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuildingLegendItem(Legend legend, {bool isSatellite = false}) {
    final legendId = _getBuildingLegendId(legend);
    final isSelected = _selectedBuildingLegendIds.contains(legendId);

    return InkWell(
      onTap: () => _toggleBuildingLegendSelection(legendId),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CustomPaint(
                painter: PolygonPainter(
                  color: legend.color,
                  isSatellite: isSatellite,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                legend.label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? const Color(0xFF374151) : const Color(0xFF6B7280),
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntranceLegendItem(Legend legend) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: legend.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              legend.label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PolygonPainter extends CustomPainter {
  final Color color;
  final bool isSatellite;

  PolygonPainter({required this.color, required this.isSatellite});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(size.width * 0.15, size.height * 0.3);
    path.lineTo(size.width * 0.5, size.height * 0.05);
    path.lineTo(size.width * 0.85, size.height * 0.3);
    path.lineTo(size.width * 0.9, size.height * 0.85);
    path.lineTo(size.width * 0.1, size.height * 0.9);
    path.close();

    // Fill: transparent in satellite mode
    final fillPaint = Paint()
      ..color = isSatellite ? Colors.transparent : color
      ..style = PaintingStyle.fill;

    // Border: thicker in satellite mode
    final borderPaint = Paint()
      ..color = color
      ..strokeWidth = isSatellite ? 3.0 : 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant PolygonPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isSatellite != isSatellite;
}