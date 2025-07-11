// Enhanced Report Wizard Screen - Feature 4
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:astacala_rescue_mobile/widgets/feedback_animations.dart';
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
  late Animation<double> _stepAnimation;

  int currentStep = 0;
  final int totalSteps = 5;

  // Form controllers and data
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _personnelCountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _disasterInfoController = TextEditingController();
  final _locationController = TextEditingController();
  final _coordinatesController = TextEditingController();
  final _victimCountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCondition;
  final List<String> _disasterConditions = ['Parah', 'Sedang', 'Kecil'];
  final List<String> _disasterTypes = [
    'Banjir',
    'Gempa Bumi',
    'Kebakaran',
    'Longsor',
    'Tsunami',
    'Angin Topan',
    'Erupsi Gunung',
    'Lainnya'
  ];
  String? _selectedDisasterType;

  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isFetchingLocation = false;
  LatLng? _selectedLocation;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _stepAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _stepAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _stepAnimationController,
      curve: Curves.easeInOut,
    ));
    _stepAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _stepAnimationController.dispose();
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
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _stepAnimationController.reset();
      _stepAnimationController.forward();
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
      _stepAnimationController.reset();
      _stepAnimationController.forward();
    }
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      final reportData = ReportData(
        teamName: _teamNameController.text,
        personnelCount: int.tryParse(_personnelCountController.text) ?? 0,
        phone: _phoneController.text,
        disasterInfo: _disasterInfoController.text,
        location: _locationController.text,
        coordinates: _coordinatesController.text,
        image: _selectedImages.isNotEmpty ? _selectedImages.first : null,
        disasterCondition: _selectedCondition,
        victimCount: int.tryParse(_victimCountController.text) ?? 0,
        description: _descriptionController.text,
      );

      context.read<ReportCubit>().submitReport(reportData);

      // Show success animation
      FeedbackAnimations.showSuccess(
        context,
        message: 'Laporan berhasil dikirim!',
        duration: const Duration(seconds: 3),
      );

      // Navigate back after delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _coordinatesController.text =
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      });

      FeedbackAnimations.showSuccess(
        context,
        message: 'Lokasi berhasil didapatkan!',
      );
    } catch (e) {
      FeedbackAnimations.showError(
        context,
        message: 'Error: ${e.toString()}',
      );
    } finally {
      setState(() {
        _isFetchingLocation = false;
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
        });

        FeedbackAnimations.showSuccess(
          context,
          message: '${pickedFiles.length} gambar berhasil dipilih!',
        );
      }
    } catch (e) {
      FeedbackAnimations.showError(
        context,
        message: 'Gagal memilih gambar: $e',
      );
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });

        FeedbackAnimations.showSuccess(
          context,
          message: 'Foto berhasil diambil!',
        );
      }
    } catch (e) {
      FeedbackAnimations.showError(
        context,
        message: 'Gagal mengambil foto: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Bencana'),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF8B0000),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: List.generate(totalSteps, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(
                          right: index < totalSteps - 1 ? 8 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: index <= currentStep
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
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
                  color: Colors.black.withOpacity(0.1),
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
                        side: const BorderSide(color: Color(0xFF8B0000)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Kembali',
                        style: TextStyle(
                          color: Color(0xFF8B0000),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: currentStep == totalSteps - 1
                        ? _submitReport
                        : _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B0000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      currentStep == totalSteps - 1
                          ? 'Kirim Laporan'
                          : 'Lanjutkan',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Tim',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B0000),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Masukkan informasi tim penyelamat',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _teamNameController,
              decoration: InputDecoration(
                labelText: 'Nama Tim',
                prefixIcon: const Icon(Icons.group, color: Color(0xFF8B0000)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF8B0000), width: 2),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Nama tim harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _personnelCountController,
              decoration: InputDecoration(
                labelText: 'Jumlah Personel',
                prefixIcon: const Icon(Icons.people, color: Color(0xFF8B0000)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF8B0000), width: 2),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Jumlah personel harus diisi';
                }
                if (int.tryParse(value!) == null) {
                  return 'Masukkan angka yang valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF8B0000)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF8B0000), width: 2),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Nomor telepon harus diisi';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisasterInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Bencana',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B0000),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Jelaskan situasi bencana yang terjadi',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: _selectedDisasterType,
            decoration: InputDecoration(
              labelText: 'Jenis Bencana',
              prefixIcon: const Icon(Icons.warning, color: Color(0xFF8B0000)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF8B0000), width: 2),
              ),
            ),
            items: _disasterTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDisasterType = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Pilih jenis bencana';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCondition,
            decoration: InputDecoration(
              labelText: 'Tingkat Keparahan',
              prefixIcon:
                  const Icon(Icons.crisis_alert, color: Color(0xFF8B0000)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF8B0000), width: 2),
              ),
            ),
            items: _disasterConditions.map((condition) {
              return DropdownMenuItem(
                value: condition,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: condition == 'Parah'
                            ? Colors.red
                            : condition == 'Sedang'
                                ? Colors.orange
                                : Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(condition),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCondition = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Pilih tingkat keparahan';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _victimCountController,
            decoration: InputDecoration(
              labelText: 'Perkiraan Jumlah Korban',
              prefixIcon:
                  const Icon(Icons.person_off, color: Color(0xFF8B0000)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF8B0000), width: 2),
              ),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Jumlah korban harus diisi';
              }
              if (int.tryParse(value!) == null) {
                return 'Masukkan angka yang valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _disasterInfoController,
            decoration: InputDecoration(
              labelText: 'Deskripsi Singkat',
              prefixIcon:
                  const Icon(Icons.description, color: Color(0xFF8B0000)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF8B0000), width: 2),
              ),
            ),
            maxLines: 3,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Deskripsi harus diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lokasi Bencana',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B0000),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tentukan lokasi kejadian bencana',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),

          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Alamat Lokasi',
              prefixIcon:
                  const Icon(Icons.location_on, color: Color(0xFF8B0000)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF8B0000), width: 2),
              ),
            ),
            maxLines: 2,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Alamat lokasi harus diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _coordinatesController,
                  decoration: InputDecoration(
                    labelText: 'Koordinat GPS',
                    prefixIcon:
                        const Icon(Icons.gps_fixed, color: Color(0xFF8B0000)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFF8B0000), width: 2),
                    ),
                  ),
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8B0000),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: _isFetchingLocation ? null : _getCurrentLocation,
                  icon: _isFetchingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.my_location, color: Colors.white),
                  tooltip: 'Dapatkan Lokasi Saat Ini',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Map widget
          if (_selectedLocation != null)
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: _selectedLocation!,
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
                      userAgentPackageName:
                          'com.example.astacala_rescue_mobile',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 40.0,
                          height: 40.0,
                          point: _selectedLocation!,
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xFF8B0000),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          if (_selectedLocation == null)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Dapatkan lokasi GPS untuk menampilkan peta',
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
      ),
    );
  }

  Widget _buildPhotosStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dokumentasi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B0000),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan foto situasi bencana',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _takePicture,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text(
                    'Ambil Foto',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickMultipleImages,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF8B0000)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon:
                      const Icon(Icons.photo_library, color: Color(0xFF8B0000)),
                  label: const Text(
                    'Pilih dari Galeri',
                    style: TextStyle(color: Color(0xFF8B0000)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_selectedImages.isNotEmpty) ...[
            Text(
              '${_selectedImages.length} foto dipilih',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
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
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 64,
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
                    Text(
                      'Tambahkan foto untuk dokumentasi',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review Laporan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B0000),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Periksa kembali informasi laporan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          _buildReviewCard('Informasi Tim', [
            'Nama Tim: ${_teamNameController.text}',
            'Jumlah Personel: ${_personnelCountController.text}',
            'Telepon: ${_phoneController.text}',
          ]),
          _buildReviewCard('Informasi Bencana', [
            'Jenis: ${_selectedDisasterType ?? '-'}',
            'Tingkat: ${_selectedCondition ?? '-'}',
            'Korban: ${_victimCountController.text}',
            'Deskripsi: ${_disasterInfoController.text}',
          ]),
          _buildReviewCard('Lokasi', [
            'Alamat: ${_locationController.text}',
            'Koordinat: ${_coordinatesController.text}',
          ]),
          _buildReviewCard('Dokumentasi', [
            'Jumlah Foto: ${_selectedImages.length}',
          ]),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              border: Border.all(color: Colors.amber),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: Colors.amber),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pastikan semua informasi sudah benar sebelum mengirim laporan.',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String title, List<String> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B0000),
              ),
            ),
            const SizedBox(height: 12),
            ...items
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ))
                ,
          ],
        ),
      ),
    );
  }
}
