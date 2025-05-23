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
  bool _isEntranceSectionExpanded = true;
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
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _entranceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _legendAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _buildingAnimation = CurvedAnimation(
      parent: _buildingAnimationController,
      curve: Curves.easeInOut,
    );
    _entranceAnimation = CurvedAnimation(
      parent: _entranceAnimationController,
      curve: Curves.easeInOut,
    );
    _legendAnimation = CurvedAnimation(
      parent: _legendAnimationController,
      curve: Curves.easeInOut,
    );
    
    _buildingAnimationController.forward();
    _entranceAnimationController.forward();
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
        width: 340,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with collapse button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade50,
                    Colors.blue.shade300,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.map_outlined,
                        color: Colors.blue,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Map Legend',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _toggleWholeLegend,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: AnimatedRotation(
                          turns: _isWholeLegendExpanded ? 0 : 0.5,
                          duration: const Duration(milliseconds: 300),
                          child: const Icon(
                            Icons.expand_less,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Animated content
            SizeTransition(
              sizeFactor: _legendAnimation,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  children: [
                    /// 🏢 Buildings Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: _toggleBuildingSection,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.business,
                                          color: Colors.orange,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Buildings',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                          child: DropdownButton<String>(
                                            value: _currentBuildingAttribute,
                                            underline: const SizedBox(),
                                            isDense: true,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
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
                                        ),
                                        const SizedBox(width: 8),
                                        AnimatedRotation(
                                          turns: _isBuildingSectionExpanded ? 0 : 0.5,
                                          duration: const Duration(milliseconds: 300),
                                          child: Icon(
                                            Icons.expand_less,
                                            color: Colors.grey.shade600,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizeTransition(
                            sizeFactor: _buildingAnimation,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Column(
                                children: buildingLegend.map(_buildLegendItem).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// 🚪 Entrances Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: _toggleEntranceSection,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.door_front_door,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Entrances',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    AnimatedRotation(
                                      turns: _isEntranceSectionExpanded ? 0 : 0.5,
                                      duration: const Duration(milliseconds: 300),
                                      child: Icon(
                                        Icons.expand_less,
                                        color: Colors.grey.shade600,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizeTransition(
                            sizeFactor: _entranceAnimation,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Column(
                                children: widget.entranceLegends
                                    .map(_buildLegendItem)
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Legend legend) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: legend.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              legend.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}