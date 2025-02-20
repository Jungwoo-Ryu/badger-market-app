import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile?> images = await picker.pickMultiImage();
    if (images.length <= 3) {
      setState(() {
        _imageFiles.addAll(images);
      });
    } else {
      // Show an error message if more than 3 images are selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only select up to 3 images.')),
      );
    }
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      // Save product to Firebase
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'imageUrls': _imageFiles.map((file) => file?.path).toList(),
      });

      // Clear the form
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
        _imageFiles.clear();
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
        title: Text('Add Product'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
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
                  decoration: InputDecoration(labelText: 'Product Description'),
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
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Images (up to 3)'),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _imageFiles.map((file) {
                    return file != null
                        ? Image.file(
                            File((file as XFile).path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container();
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitProduct,
                    child: Text('Add Product'),
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