import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Prodify/controller/AuthController.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerWidget extends StatefulWidget {
  final String? initialImage;
  const ImagePickerWidget({super.key, this.initialImage});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
  String? _networkOrBase64Image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _networkOrBase64Image = widget.initialImage;
  }

  Future<void> _pickImage() async {
    // Minta izin galeri (Android 13+)
    final status = await Permission.photos.request();
    // Android 12 ke bawah
    final legacyStatus = await Permission.storage.request();

    if (status.isGranted || legacyStatus.isGranted) {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _networkOrBase64Image = null;
        });

        final controller = Get.find<AuthController>();
        controller.attachment.value = pickedFile.path;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin akses galeri ditolak")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (_image != null) {
      imageWidget = Image.file(_image!, height: 150, fit: BoxFit.cover);
    } else if (_networkOrBase64Image != null &&
        _networkOrBase64Image!.isNotEmpty) {
      if (_networkOrBase64Image!.startsWith('http')) {
        imageWidget = Image.network(_networkOrBase64Image!,
            height: 150, fit: BoxFit.cover);
      } else if (_networkOrBase64Image!.startsWith('data:image')) {
        final base64Data = _networkOrBase64Image!.split(',').last;
        imageWidget = Image.memory(base64Decode(base64Data),
            height: 150, fit: BoxFit.cover);
      } else {
        imageWidget = Image.memory(base64Decode(_networkOrBase64Image!),
            height: 150, fit: BoxFit.cover);
      }
    } else {
      imageWidget = const Text("Belum ada gambar");
    }
    return Column(
      children: [
        imageWidget,
        const SizedBox(height: 10),
        if (_image != null || _networkOrBase64Image != null)
          SizedBox(
            width: 170,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _image = null;
                  _networkOrBase64Image = null;
                });
                final controller = Get.find<AuthController>();
                controller.attachment.value = '';
              },
              icon: const Icon(Icons.delete),
              label: const Text("Hapus Gambar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        const SizedBox(height: 10),
        SizedBox(
          width: 170,
          child: ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text("Pilih Gambar"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF80CBC4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
