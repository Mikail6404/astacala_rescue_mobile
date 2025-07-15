// Enhanced Report Wizard Screen - Multi-step disaster reporting with GPS and photos
// This provides a comprehensive, user-friendly disaster reporting experience

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:astacala_rescue_mobile/widgets/feedback_animations.dart';
import 'package:astacala_rescue_mobile/widgets/micro_interactions.dart';
import 'package:astacala_rescue_mobile/cubits/report/report_cubit.dart';
import 'package:astacala_rescue_mobile/models/report_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportWizardScreen extends StatefulWidget {
  const ReportWizardScreen({super.key});

  @override
  State<ReportWizardScreen> createState() => _ReportWizardScreenState();
}

class _ReportWizardScreenState extends State<ReportWizardScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _stepAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _stepAnimation;
  late Animation<double> _progressAnimation;

  int currentStep = 0;
  final int totalSteps = 5;

  // Form controllers and data
  final _teamNameController = TextEditingController();
  final _personnelCountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _disasterInfoController = TextEditingController();
  final _locationController = TextEditingController();
  final _coordinatesController = TextEditingController();
  final _victimCountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedDisasterType;
  String? _selectedSeverity;
  LatLng? _selectedLocation;
  final List<File> _selectedImages = [];
  bool _isLocationLoading = false;

  final List<String> _disasterTypes = [
    'Gempa Bumi',
    'Banjir',
    'Kebakaran',
    'Tanah Longsor',
    'Angin Topan',
    'Tsunami',
    'Lainnya',
  ];

  final List<String> _severityLevels = [
    'Ringan',
    'Sedang',
    'Berat',
    'Sangat Berat',
  ];

  @override
  void initState() {
    super.initState();
    _stepAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _stepAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _stepAnimationController, curve: Curves.easeInOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 0.2).animate(
      CurvedAnimation(
          parent: _progressAnimationController, curve: Curves.easeInOut),
    );

    _stepAnimationController.forward();
    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _stepAnimationController.dispose();
    _progressAnimationController.dispose();
    _teamNameController.dispose();
    _personnelCountController.dispose();
    _phoneController.dispose();
    _disasterInfoController.dispose();
    _locationController.dispose();
    _coordinatesController.dispose();
    _victimCountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (currentStep < totalSteps - 1) {
      if (_validateCurrentStep()) {
        setState(() {
          currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _updateProgress();
        _stepAnimationController.reset();
        _stepAnimationController.forward();
      }
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();
      _stepAnimationController.reset();
      _stepAnimationController.forward();
    }
  }

  void _updateProgress() {
    final progress = (currentStep + 1) / totalSteps;
    _progressAnimationController.animateTo(progress);
  }

  bool _validateCurrentStep() {
    switch (currentStep) {
      case 0: // Team Info
        if (_teamNameController.text.isEmpty ||
            _personnelCountController.text.isEmpty ||
            _phoneController.text.isEmpty) {
          FeedbackAnimations.showError(
              context, 'Mohon lengkapi semua field tim');
          return false;
        }
        return true;
      case 1: // Disaster Info
        if (_selectedDisasterType == null ||
            _selectedSeverity == null ||
            _disasterInfoController.text.isEmpty) {
          FeedbackAnimations.showError(
              context, 'Mohon lengkapi informasi bencana');
          return false;
        }
        return true;
      case 2: // Location
        if (_selectedLocation == null) {
          FeedbackAnimations.showError(context, 'Mohon pilih lokasi kejadian');
          return false;
        }
        return true;
      case 3: // Photos
        if (_selectedImages.isEmpty) {
          FeedbackAnimations.showError(context, 'Mohon ambil minimal 1 foto');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _submitReport() {
    if (_validateCurrentStep()) {
      // TODO: Backend Integration - Submit report to API
      final reportData = ReportData(
        teamName: _teamNameController.text,
        personnelCount: int.tryParse(_personnelCountController.text) ?? 0,
        phone: _phoneController.text,
        disasterInfo: _disasterInfoController.text,
        location: _locationController.text,
        coordinates: _selectedLocation != null
            ? '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}'
            : '',
        victimCount: int.tryParse(_victimCountController.text) ?? 0,
        description: _descriptionController.text,
        // Enhanced wizard fields
        disasterType: _selectedDisasterType,
        severity: _selectedSeverity,
        gpsLocation: _selectedLocation,
        images: _selectedImages,
        additionalNotes: _descriptionController.text,
      );

      context.read<ReportCubit>().submitReport(reportData);
      FeedbackAnimations.showSuccess(context, 'Laporan berhasil dikirim!');

      // Navigate back after short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Buat Laporan Bencana'),
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
      ),
      body: Column(
        children: [
          // Progress Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8B0000),
                  const Color(0xFF8B0000).withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6,
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Step Indicator
                AnimatedBuilder(
                  animation: _stepAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (_stepAnimation.value * 0.2),
                      child: Text(
                        'Langkah ${currentStep + 1} dari $totalSteps',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  _getStepTitle(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildTeamInfoStep(),
                _buildDisasterInfoStep(),
                _buildLocationStep(),
                _buildPhotosStep(),
                _buildReviewStep(),
              ],
            ),
          ),

          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF8B0000)),
                      ),
                      child: const Text('Kembali'),
                    ),
                  ),
                if (currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: AnimatedButton(
                    text: currentStep == totalSteps - 1
                        ? 'Kirim Laporan'
                        : 'Lanjut',
                    onPressed: currentStep == totalSteps - 1
                        ? _submitReport
                        : _nextStep,
                    icon: currentStep == totalSteps - 1
                        ? Icons.send
                        : Icons.arrow_forward,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (currentStep) {
      case 0:
        return 'Informasi Tim';
      case 1:
        return 'Detail Bencana';
      case 2:
        return 'Lokasi Kejadian';
      case 3:
        return 'Dokumentasi';
      case 4:
        return 'Review & Kirim';
      default:
        return '';
    }
  }

  Widget _buildTeamInfoStep() {
    return MicroInteractions.cardRevealAnimation(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan informasi tim relawan yang menangani kejadian ini',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildInputField(
              controller: _teamNameController,
              label: 'Nama Tim',
              hint: 'Contoh: Tim SAR Jakarta',
              icon: Icons.group,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _personnelCountController,
              label: 'Jumlah Personel',
              hint: 'Jumlah anggota tim',
              icon: Icons.people,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _phoneController,
              label: 'Nomor Koordinator',
              hint: 'Nomor HP yang bisa dihubungi',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisasterInfoStep() {
    return MicroInteractions.cardRevealAnimation(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jelaskan detail bencana yang terjadi',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildDropdownField(
              label: 'Jenis Bencana',
              value: _selectedDisasterType,
              items: _disasterTypes,
              onChanged: (value) =>
                  setState(() => _selectedDisasterType = value),
              icon: Icons.warning_amber,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Tingkat Keparahan',
              value: _selectedSeverity,
              items: _severityLevels,
              onChanged: (value) => setState(() => _selectedSeverity = value),
              icon: Icons.trending_up,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _disasterInfoController,
              label: 'Deskripsi Kejadian',
              hint: 'Jelaskan detail bencana yang terjadi...',
              icon: Icons.description,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _victimCountController,
              label: 'Perkiraan Jumlah Korban',
              hint: 'Jumlah korban yang terdampak',
              icon: Icons.person_outline,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationStep() {
    return MicroInteractions.cardRevealAnimation(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tentukan lokasi kejadian bencana',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter:
                        _selectedLocation ?? const LatLng(-6.2088, 106.8456),
                    initialZoom: 15.0,
                    onTap: (tapPosition, point) {
                      setState(() {
                        _selectedLocation = point;
                        _coordinatesController.text =
                            '${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}';
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.astacala.rescue_mobile',
                    ),
                    if (_selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLocation!,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedButton(
              text: _isLocationLoading
                  ? 'Mendapatkan Lokasi...'
                  : 'Gunakan Lokasi Saat Ini',
              onPressed: _isLocationLoading ? null : _getCurrentLocation,
              icon: Icons.my_location,
              isLoading: _isLocationLoading,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _locationController,
              label: 'Alamat/Deskripsi Lokasi',
              hint: 'Contoh: Jl. Sudirman No. 1, Jakarta Pusat',
              icon: Icons.location_on,
            ),
            if (_selectedLocation != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Koordinat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                        style: TextStyle(color: Colors.green[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosStep() {
    return MicroInteractions.cardRevealAnimation(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ambil foto dokumentasi kejadian',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AnimatedButton(
                    text: 'Kamera',
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: Icons.camera_alt,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AnimatedButton(
                    text: 'Galeri',
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icons.photo_library,
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_selectedImages.isNotEmpty) ...[
              Text(
                'Foto yang dipilih (${_selectedImages.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(_selectedImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImages.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ] else ...[
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.grey[300]!, style: BorderStyle.solid),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Belum ada foto dipilih',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
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
    );
  }

  Widget _buildReviewStep() {
    return MicroInteractions.cardRevealAnimation(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review informasi sebelum mengirim laporan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildReviewCard(
              title: 'Informasi Tim',
              children: [
                _buildReviewRow('Nama Tim', _teamNameController.text),
                _buildReviewRow(
                    'Jumlah Personel', _personnelCountController.text),
                _buildReviewRow('Nomor Koordinator', _phoneController.text),
              ],
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              title: 'Detail Bencana',
              children: [
                _buildReviewRow('Jenis Bencana', _selectedDisasterType ?? '-'),
                _buildReviewRow('Tingkat Keparahan', _selectedSeverity ?? '-'),
                _buildReviewRow('Deskripsi', _disasterInfoController.text),
                _buildReviewRow('Jumlah Korban', _victimCountController.text),
              ],
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              title: 'Lokasi',
              children: [
                _buildReviewRow('Alamat', _locationController.text),
                if (_selectedLocation != null)
                  _buildReviewRow(
                    'Koordinat',
                    '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              title: 'Dokumentasi',
              children: [
                _buildReviewRow(
                    'Jumlah Foto', '${_selectedImages.length} foto'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF8B0000)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8B0000), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF8B0000)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8B0000), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLocationLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          FeedbackAnimations.showError(context, 'Layanan lokasi tidak aktif');
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            FeedbackAnimations.showError(context, 'Izin lokasi ditolak');
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          FeedbackAnimations.showError(context, 'Izin lokasi ditolak permanen');
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _coordinatesController.text =
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      });

      if (mounted) {
        FeedbackAnimations.showSuccess(context, 'Lokasi berhasil didapatkan');
      }
    } catch (e) {
      if (mounted) {
        FeedbackAnimations.showError(context, 'Gagal mendapatkan lokasi: $e');
      }
    } finally {
      setState(() => _isLocationLoading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();

      if (source == ImageSource.gallery) {
        // Single image selection from gallery for now
        // TODO: Future enhancement - implement multiple selection
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _selectedImages.add(File(image.path));
          });
          if (mounted) {
            FeedbackAnimations.showSuccess(
                context, 'Foto berhasil ditambahkan');
          }
        }
      } else {
        // Single image from camera
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _selectedImages.add(File(image.path));
          });
          if (mounted) {
            FeedbackAnimations.showSuccess(context, 'Foto berhasil diambil');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        FeedbackAnimations.showError(context, 'Gagal mengambil foto: $e');
      }
    }
  }
}
