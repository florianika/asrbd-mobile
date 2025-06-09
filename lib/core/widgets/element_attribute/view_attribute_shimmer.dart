import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ViewAttributeShimmer extends StatelessWidget {
  const ViewAttributeShimmer({super.key});

  Widget _buildShimmerLine(
      {double height = 20, double width = double.infinity}) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
        Icon(Icons.title, size: 18, color: Colors.grey.shade400),
        const SizedBox(width: 8),
        _buildShimmerLine(width: 100, height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(),
              _buildShimmerLine(height: 48), // Dropdown 1
              _buildShimmerLine(height: 48), // Dropdown 2

              const SizedBox(height: 24),
              _buildSectionTitle(),
              _buildShimmerLine(height: 48), // TextField 1
              _buildShimmerLine(height: 48), // TextField 2

              const SizedBox(height: 24),
              _buildSectionTitle(),
              _buildShimmerLine(height: 48), // TextField 3
              _buildShimmerLine(height: 48), // TextField 4
              _buildShimmerLine(height: 48), // TextField 5

              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShimmerLine(width: 100, height: 40),
                  _buildShimmerLine(width: 100, height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
