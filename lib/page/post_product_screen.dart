import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostProductScreen extends StatefulWidget {
  const PostProductScreen({Key? key}) : super(key: key);

  @override
  _PostProductScreenState createState() => _PostProductScreenState();
}

class _PostProductScreenState extends State<PostProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final List<XFile?> _imageFiles = [];
  bool _isHovering = false;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile?> images = await picker.pickMultiImage();
    if (_imageFiles.length + images.length <= 5) {
      setState(() {
        _imageFiles.addAll(images);
      });
    } else {
      // Show an error message if more than 5 images are selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only select up to 5 images.')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  String _formatPrice(String value) {
    if (value.isEmpty) return '';
    value = value.replaceAll(RegExp(r'[^\d.]'), '');
    final parts = value.split('.');
    if (parts.length > 2) return value;
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';
    final formattedIntegerPart = integerPart.replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return '\$' + formattedIntegerPart + (decimalPart.isNotEmpty ? '.$decimalPart' : '');
  }

  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];
    List<Future<String>> uploadTasks = [];

    for (XFile? imageFile in _imageFiles) {
      if (imageFile != null) {
        uploadTasks.add(_uploadImage(imageFile));
      }
    }

    imageUrls = await Future.wait(uploadTasks);
    return imageUrls;
  }

  Future<String> _uploadImage(XFile imageFile) async {
    try {
      File file = File(imageFile.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('products/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print('Uploaded image URL: $downloadUrl'); // Log the uploaded image URL
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return '';
    }
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please attach at least one image.')),
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      // Upload images and get their URLs
      List<String> imageUrls = await _uploadImages();
      print('Image URLs: $imageUrls'); // Log the image URLs

      // Get the current user's ID
      User? user = FirebaseAuth.instance.currentUser;
      String writerId = user?.uid ?? 'unknown';

      // Save product to Firebase
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text.replaceAll('\$', '').replaceAll(',', '')),
        'imageUrls': imageUrls,
        'writer': writerId,
        'status': 'available',
        'cret_wk_dtm': FieldValue.serverTimestamp(),
      });

      // Clear the form
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
        _imageFiles.clear();
        _isUploading = false;
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!')),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(161, 32, 43, 1),
        iconTheme: IconThemeData(color: Colors.white), // Set back button color to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 30, color: Colors.grey),
                        Text('${_imageFiles.length}/5', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _imageFiles.asMap().entries.map((entry) {
                    int index = entry.key;
                    XFile? file = entry.value;
                    return Stack(
                      children: [
                        Image.file(
                          File(file!.path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              color: Colors.black54,
                              child: Icon(
                                CupertinoIcons.clear_circled,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a product name',
                    labelText: 'Product Name'
                    ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Product Description'
                    ),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    // Add input formatter to format the price
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final text = _formatPrice(newValue.text);
                      return newValue.copyWith(
                        text: text,
                        selection: TextSelection.collapsed(offset: text.length),
                      );
                    }),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value.replaceAll('\$', '').replaceAll(',', '')) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: MouseRegion(
                    onHover: (event) => setState(() => _isHovering = true),
                    onExit: (event) => setState(() => _isHovering = false),
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _submitProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isHovering
                            ? const Color.fromRGBO(161, 32, 43, 0.8) // Slightly darker color on hover
                            : const Color.fromRGBO(161, 32, 43, 1), // Original color
                      ),
                      child: _isUploading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'Add Product',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}