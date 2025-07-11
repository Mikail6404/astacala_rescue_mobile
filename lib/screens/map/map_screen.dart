import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  LatLng _currentLocation =
      const LatLng(-6.2088, 106.8456); // Default to Jakarta
  List<DisasterMarker> _disasterMarkers = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';

  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeOut),
    );
    _initializeMap();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation();
    _loadDisasterMarkers();
    _fabAnimationController.forward();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
        _mapController.move(_currentLocation, 13.0);
      }
    } catch (e) {
      // Handle location error silently, use default location
      print('Location error: $e');
    }
  }

  void _loadDisasterMarkers() {
    // TODO: Backend Integration - Replace with API call
    setState(() {
      _disasterMarkers = [
        DisasterMarker(
          id: '1',
          position: LatLng(_currentLocation.latitude + 0.01,
              _currentLocation.longitude + 0.01),
          type: 'earthquake',
          title: 'Gempa Bumi M 5.2',
          description:
              'Gempa bumi dengan magnitudo 5.2 terjadi 15 menit yang lalu',
          severity: 'high',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        DisasterMarker(
          id: '2',
          position: LatLng(_currentLocation.latitude - 0.005,
              _currentLocation.longitude + 0.015),
          type: 'flood',
          title: 'Banjir Bandang',
          description: 'Banjir setinggi 2 meter melanda kawasan perumahan',
          severity: 'medium',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        DisasterMarker(
          id: '3',
          position: LatLng(_currentLocation.latitude + 0.02,
              _currentLocation.longitude - 0.01),
          type: 'fire',
          title: 'Kebakaran Hutan',
          description: 'Kebakaran hutan seluas 50 hektar masih berlangsung',
          severity: 'high',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        DisasterMarker(
          id: '4',
          position: LatLng(_currentLocation.latitude - 0.015,
              _currentLocation.longitude - 0.005),
          type: 'landslide',
          title: 'Tanah Longsor',
          description: 'Longsor menutup akses jalan utama',
          severity: 'medium',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Bencana'),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _showLayerOptions,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 13.0,
              minZoom: 5.0,
              maxZoom: 18.0,
              onTap: (tapPosition, point) {
                // TODO: Add new disaster report at tapped location
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.astacala.rescue_mobile',
                tileBuilder: (context, tileWidget, tile) {
                  return ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.multiply,
                    ),
                    child: tileWidget,
                  );
                },
              ),
              if (!_isLoading) ...[
                // Current location marker
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                // Disaster markers
                MarkerLayer(
                  markers: _getFilteredMarkers().map((marker) {
                    return Marker(
                      point: marker.position,
                      child: GestureDetector(
                        onTap: () => _showDisasterDetails(marker),
                        child: _buildDisasterMarkerIcon(marker),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Memuat peta bencana...'),
                  ],
                ),
              ),
            ),
          // Legend
          Positioned(
            top: 16,
            right: 16,
            child: ScaleTransition(
              scale: _fabAnimation,
              child: _buildLegend(),
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "location",
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location, color: Color(0xFF8B0000)),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "add",
              backgroundColor: const Color(0xFF8B0000),
              onPressed: _addDisasterReport,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisasterMarkerIcon(DisasterMarker marker) {
    IconData iconData;
    Color color;

    switch (marker.type) {
      case 'earthquake':
        iconData = Icons.vibration;
        color = Colors.brown;
        break;
      case 'flood':
        iconData = Icons.water;
        color = Colors.blue;
        break;
      case 'fire':
        iconData = Icons.local_fire_department;
        color = Colors.red;
        break;
      case 'landslide':
        iconData = Icons.landscape;
        color = Colors.orange;
        break;
      default:
        iconData = Icons.warning;
        color = Colors.grey;
    }

    // Adjust opacity based on severity
    final opacity = marker.severity == 'high' ? 1.0 : 0.7;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(opacity),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        iconData,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legenda',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 8),
          _buildLegendItem(Icons.vibration, Colors.brown, 'Gempa'),
          _buildLegendItem(Icons.water, Colors.blue, 'Banjir'),
          _buildLegendItem(
              Icons.local_fire_department, Colors.red, 'Kebakaran'),
          _buildLegendItem(Icons.landscape, Colors.orange, 'Longsor'),
          const SizedBox(height: 4),
          _buildLegendItem(Icons.my_location, Colors.blue, 'Lokasi Anda'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  List<DisasterMarker> _getFilteredMarkers() {
    if (_selectedFilter == 'all') return _disasterMarkers;
    return _disasterMarkers
        .where((marker) => marker.type == _selectedFilter)
        .toList();
  }

  void _goToCurrentLocation() {
    _mapController.move(_currentLocation, 15.0);
  }

  void _addDisasterReport() {
    // TODO: Navigate to disaster report form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur lapor bencana akan segera tersedia'),
        backgroundColor: Color(0xFF8B0000),
      ),
    );
  }

  void _showDisasterDetails(DisasterMarker marker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildDisasterMarkerIcon(marker),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        marker.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatTimestamp(marker.timestamp),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(marker.description),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.directions),
                    label: const Text('Petunjuk Arah'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B0000),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.share),
                    label: const Text('Bagikan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Bencana',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFilterOption('all', 'Semua', Icons.all_inclusive),
            _buildFilterOption('earthquake', 'Gempa Bumi', Icons.vibration),
            _buildFilterOption('flood', 'Banjir', Icons.water),
            _buildFilterOption(
                'fire', 'Kebakaran', Icons.local_fire_department),
            _buildFilterOption('landslide', 'Tanah Longsor', Icons.landscape),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String value, String label, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: _selectedFilter == value ? const Icon(Icons.check) : null,
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showLayerOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Opsi Layer'),
        content: const Text(
            'Fitur layer tambahan akan tersedia di update mendatang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else {
      return '${difference.inDays} hari lalu';
    }
  }
}

// Model for disaster markers
class DisasterMarker {
  final String id;
  final LatLng position;
  final String type;
  final String title;
  final String description;
  final String severity;
  final DateTime timestamp;

  DisasterMarker({
    required this.id,
    required this.position,
    required this.type,
    required this.title,
    required this.description,
    required this.severity,
    required this.timestamp,
  });
}
