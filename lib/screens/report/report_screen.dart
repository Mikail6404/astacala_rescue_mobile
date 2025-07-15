// package:astacala_rescue_mobile/screens/report/report_screen.dart

import 'dart:io';
import 'package:astacala_rescue_mobile/cubits/report/report_cubit.dart';
import 'package:astacala_rescue_mobile/cubits/report/report_state.dart';
import 'package:astacala_rescue_mobile/models/report_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the ReportCubit specifically to this screen.
    return BlocProvider(
      create: (context) => ReportCubit(),
      child: const ReportForm(),
    );
  }
}

class ReportForm extends StatefulWidget {
  const ReportForm({super.key});

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each text field
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

  bool _isFetchingLocation = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    // Dispose controllers to free up resources
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

  void _clearForm() {
    _formKey.currentState?.reset();
    _teamNameController.clear();
    _personnelCountController.clear();
    _phoneController.clear();
    _disasterInfoController.clear();
    _locationController.clear();
    _coordinatesController.clear();
    _victimCountController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedImage = null;
      _selectedCondition = null;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final reportData = ReportData(
        teamName: _teamNameController.text,
        personnelCount: int.tryParse(_personnelCountController.text) ?? 0,
        phone: _phoneController.text,
        disasterInfo: _disasterInfoController.text,
        location: _locationController.text,
        coordinates: _coordinatesController.text,
        image: _selectedImage,
        disasterCondition: _selectedCondition,
        victimCount: int.tryParse(_victimCountController.text) ?? 0,
        description: _descriptionController.text,
      );
      context.read<ReportCubit>().submitReport(reportData);
    }
  }

  // --- GPS Location Logic ---
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    try {
      // 1. Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // 2. Check for permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // 3. Get the current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // 4. Update the text field
      _coordinatesController.text =
          '${position.latitude}, ${position.longitude}';
    } catch (e) {
      // Show error message to the user
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      setState(() {
        _isFetchingLocation = false;
      });
    }
  }

  // --- Image Picking Logic ---
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Compress image to save space
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  // --- Show Dialog to Choose Camera or Gallery ---
  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: 'Ambil foto dengan kamera',
              button: true,
              child: ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ),
            Semantics(
              label: 'Pilih foto dari galeri',
              button: true,
              child: ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0), // Reduced from 16.0 to 12.0
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16, // Reduced from 18 to 16
            fontWeight: FontWeight.bold,
            color: Color(0xFF8B0000)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportSubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Laporan berhasil dikirim!'),
              backgroundColor: Colors.green,
            ),
          );
          _clearForm();
        } else if (state is ReportSubmissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengirim laporan: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SafeArea( // Add SafeArea
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0), // Reduced from 16.0 to 12.0
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pastikan data assessment yang dilaporkan telah akurat!',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500), // Reduced from 16 to 14
                  ),
                  const SizedBox(height: 8), // Add spacing
                  
                  // --- Team Relawan Section ---
                  _buildSectionHeader('Team Relawan'),
                  TextFormField(
                    controller: _teamNameController,
                    decoration: const InputDecoration(
                        labelText: 'Nama Team', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tim wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8), // Reduced from 12 to 8
                  TextFormField(
                    controller: _personnelCountController,
                    decoration: const InputDecoration(
                        labelText: 'Jumlah Personel',
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8), // Reduced from 12 to 8
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        labelText: 'No Telepon', border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                  ),
                  
                  // --- Disaster Information Section ---
                  _buildSectionHeader('Informasi Data Bencana'),
                  TextFormField(
                    controller: _disasterInfoController,
                    decoration: const InputDecoration(
                        labelText: 'Informasi singkat bencana',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8), // Reduced from 12 to 8
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                        labelText: 'Lokasi Bencana',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8), // Reduced from 12 to 8
                  
                  // --- New Image Upload Section ---
                  // Image Preview
                  if (_selectedImage != null)
                    Container(
                      height: 150, // Reduced from 200 to 150
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8), // Reduced from 12 to 8
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  
                  // Upload Button
                  Semantics(
                    label: _selectedImage == null ? 'Unggah foto lokasi bencana' : 'Ganti foto lokasi bencana',
                    button: true,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: Text(_selectedImage == null
                          ? 'Unggah Foto Lokasi Bencana'
                          : 'Ganti Foto'),
                      onPressed: _showImageSourceDialog,
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced from 12 to 8
                  
                  // --- New GPS Coordinate Field ---
                  TextFormField(
                    controller: _coordinatesController,
                    readOnly: true, // Make it read-only
                    decoration: InputDecoration(
                      labelText: 'Titik Koordinat Lokasi Bencana',
                      border: const OutlineInputBorder(),
                      suffixIcon: _isFetchingLocation
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Semantics(
                              label: 'Dapatkan lokasi GPS saat ini',
                              button: true,
                              child: IconButton(
                                icon: const Icon(Icons.my_location),
                                onPressed: _getCurrentLocation,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced from 12 to 8
                  
                  // --- Dropdown for Disaster Condition ---
                  DropdownButtonFormField<String>(
                    value: _selectedCondition,
                    decoration: const InputDecoration(
                      labelText: 'Kondisi Lokasi Bencana',
                      border: OutlineInputBorder(),
                    ),
                    items: _disasterConditions.map((String condition) {
                      return DropdownMenuItem<String>(
                        value: condition,
                        child: Text(condition),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCondition = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 8), // Reduced from 12 to 8
                  TextFormField(
                    controller: _victimCountController,
                    decoration: const InputDecoration(
                        labelText: 'Jumlah Korban', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8), // Reduced from 12 to 8
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        labelText: 'Deskripsi Terkait Data Lainnya',
                        border: OutlineInputBorder()),
                    maxLines: 3, // Reduced from 4 to 3
                  ),
                  const SizedBox(height: 16), // Reduced from 24 to 16
                  
                  // --- Submit Button ---
                  BlocBuilder<ReportCubit, ReportState>(
                    builder: (context, state) {
                      if (state is ReportSubmissionLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: Semantics(
                          label: 'Simpan laporan bencana',
                          button: true,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B0000),
                              padding: const EdgeInsets.symmetric(vertical: 14), // Reduced from 16 to 14
                            ),
                            onPressed: _submitForm,
                            child: const Text('Simpan Laporan',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}