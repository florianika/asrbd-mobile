import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

/// Attribution required by the OpenStreetMap tile usage policy. It is shown
/// expanded for a few seconds and then collapses to an (i) button.
/// Renders nothing when [urlTemplate] is not an OpenStreetMap tile server.
class OsmAttribution extends StatelessWidget {
  final String urlTemplate;
  final AttributionAlignment alignment;

  const OsmAttribution({
    super.key,
    required this.urlTemplate,
    this.alignment = AttributionAlignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    if (!urlTemplate.contains('openstreetmap.org')) {
      return const SizedBox.shrink();
    }

    return RichAttributionWidget(
      alignment: alignment,
      showFlutterMapAttribution: false,
      popupInitialDisplayDuration: const Duration(seconds: 5),
      attributions: [
        TextSourceAttribution(
          'OpenStreetMap contributors',
          onTap: () => launchUrl(
            Uri.parse('https://www.openstreetmap.org/copyright'),
            mode: LaunchMode.externalApplication,
          ),
        ),
      ],
    );
  }
}
