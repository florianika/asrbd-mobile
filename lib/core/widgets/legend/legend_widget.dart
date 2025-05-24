import 'package:asrdb/core/models/legend/legend.dart';
import 'package:flutter/material.dart';

class CombinedLegendWidget extends StatefulWidget {
  final Map<String, List<Legend>> buildingLegends;
  final String initialBuildingAttribute;
  final List<Legend> entranceLegends;
  final Function onChange;

  const CombinedLegendWidget({
    super.key,
    required this.buildingLegends,
    required this.initialBuildingAttribute,
    required this.entranceLegends,
    required this.onChange,
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
  late Animation<double> _legendAnimation;

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
    _legendAnimation = CurvedAnimation(
      parent: _legendAnimationController,
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
                    color: Colors.black.withOpacity(0.08),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        const Text(
                          'Legend',
                          style: TextStyle(
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
                          title: 'Buildings',
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
                                });
                              }
                            },
                          ),
                          content: buildingLegend.map((legend) => _buildLegendItem(legend, isBuilding: true)).toList(),
                        ),

                        const SizedBox(height: 16),

                        // Entrances Section
                        _buildSection(
                          title: 'Entrances',
                          isExpanded: _isEntranceSectionExpanded,
                          onToggle: _toggleEntranceSection,
                          animation: _entranceAnimation,
                          content: widget.entranceLegends
                              .map((legend) => _buildLegendItem(legend, isBuilding: false))
                              .toList(),
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
                Icons.map_outlined,
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
              children: content,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Legend legend, {bool isBuilding = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: isBuilding 
              ? CustomPaint(
                  painter: PolygonPainter(color: legend.color),
                )
              : Container(
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
  
  PolygonPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path();
    
    // Create a shape similar to the building polygon in the image
    // It looks like an angular, house-like shape
    path.moveTo(size.width * 0.15, size.height * 0.3); // Left side start
    path.lineTo(size.width * 0.5, size.height * 0.05); // Top peak
    path.lineTo(size.width * 0.85, size.height * 0.3); // Right side
    path.lineTo(size.width * 0.9, size.height * 0.85); // Bottom right
    path.lineTo(size.width * 0.1, size.height * 0.9); // Bottom left
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}