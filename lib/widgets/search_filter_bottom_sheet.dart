import 'package:flutter/material.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  const SearchFilterBottomSheet({super.key});

  @override
  State<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  String selectedDisasterType = 'Semua';
  String selectedUrgency = 'Semua';
  String selectedLocation = 'Semua';
  bool showOnlyActive = true;

  final List<String> disasterTypes = [
    'Semua',
    'Gempa Bumi',
    'Banjir',
    'Longsor',
    'Kebakaran',
    'Tsunami',
    'Angin Puting Beliung',
  ];

  final List<String> urgencyLevels = [
    'Semua',
    'Sangat Tinggi',
    'Tinggi',
    'Sedang',
    'Rendah',
  ];

  final List<String> locations = [
    'Semua',
    'Jakarta',
    'Bandung',
    'Surabaya',
    'Medan',
    'Semarang',
    'Yogyakarta',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Pencarian',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedDisasterType = 'Semua';
                          selectedUrgency = 'Semua';
                          selectedLocation = 'Semua';
                          showOnlyActive = true;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Disaster Type
                const Text(
                  'Jenis Bencana',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: disasterTypes.map((type) {
                    final isSelected = selectedDisasterType == type;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDisasterType = type;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF8B0000)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF8B0000)
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Urgency Level
                const Text(
                  'Tingkat Urgensi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: urgencyLevels.map((level) {
                    final isSelected = selectedUrgency == level;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedUrgency = level;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF8B0000)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF8B0000)
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          level,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Location
                const Text(
                  'Lokasi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedLocation,
                      isExpanded: true,
                      items: locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value!;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Show only active
                SwitchListTile(
                  title: const Text(
                    'Hanya tampilkan bencana aktif',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  value: showOnlyActive,
                  activeColor: const Color(0xFF8B0000),
                  onChanged: (value) {
                    setState(() {
                      showOnlyActive = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: 32),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'disasterType': selectedDisasterType,
                        'urgency': selectedUrgency,
                        'location': selectedLocation,
                        'showOnlyActive': showOnlyActive,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B0000),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Terapkan Filter',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
