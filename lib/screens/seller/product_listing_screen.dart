import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_constants.dart';
import '../../widgets/app_scaffold.dart';

/// Product Listing Screen - Seller can create a new product listing
class ProductListingScreen extends StatefulWidget {
  final String? categoryName;
  final String? subcategory;

  const ProductListingScreen({
    super.key,
    this.categoryName,
    this.subcategory,
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _locationController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _sizeController = TextEditingController();
  final _colorController = TextEditingController();
  final _shippingPriceController = TextEditingController();

  String? _selectedCategory;
  String? _selectedCondition;
  String _shippingType = 'free';
  final List<File> _images = [];
  bool _showCategoryDropdown = false;
  bool _showConditionDropdown = false;
  bool _showShippingDropdown = false;

  final List<String> _categories = [
    AppStrings.electronics,
    AppStrings.fashion,
    AppStrings.homeGarden,
    AppStrings.vehicles,
    AppStrings.sportsOutdoors,
    AppStrings.toysKidsBaby,
    AppStrings.booksMusicMedia,
    AppStrings.healthBeauty,
    AppStrings.collectiblesArt,
    AppStrings.petSupplies,
    AppStrings.musicalInstruments,
    AppStrings.industrialBusiness,
    AppStrings.miscellaneous,
  ];

  final List<String> _conditions = ['New', 'Used', 'Refurbished'];

  final List<Map<String, String>> _shippingTypes = [
    {'label': 'Free Shipping', 'value': 'free'},
    {'label': 'Paid Shipping', 'value': 'paid'},
    {'label': 'Pickup Only', 'value': 'pickup'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = ((screenWidth - 50) / 3).clamp(80.0, 120.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final borderColor = isDark
        ? const Color(AppColors.darkBorder)
        : const Color(AppColors.grayLight);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);
    final contentPadding = screenWidth * 0.04;

    return AppScaffold(
      title: 'Create Listing',
      showBackButton: true,
      showCart: false,
      showBottomNav: false,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(contentPadding),
          shrinkWrap: true,
          children: [
            // Product Title
            _buildSection(
              label: 'Product Title *',
              child: TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter product title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  filled: true,
                  fillColor: cardColor,
                ),
                style: TextStyle(color: textColor),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product title';
                  }
                  return null;
                },
              ),
              textColor: textColor,
            ),

            // Description
            _buildSection(
              label: 'Description *',
              child: TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter product description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  filled: true,
                  fillColor: cardColor,
                ),
                style: TextStyle(color: textColor),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              textColor: textColor,
            ),

            // Category
            _buildSection(
              label: 'Category *',
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showCategoryDropdown = !_showCategoryDropdown;
                        _showConditionDropdown = false;
                        _showShippingDropdown = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCategory ?? 'Select Category',
                            style: TextStyle(
                              color: _selectedCategory != null
                                  ? textColor
                                  : const Color(AppColors.grayPlaceholder),
                            ),
                          ),
                          Icon(
                            _showCategoryDropdown
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: const Color(AppColors.grayMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showCategoryDropdown)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                                _showCategoryDropdown = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: borderColor,
                                    width: index < _categories.length - 1 ? 1 : 0,
                                  ),
                                ),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
              textColor: textColor,
            ),

            // Condition
            _buildSection(
              label: 'Condition *',
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showConditionDropdown = !_showConditionDropdown;
                        _showCategoryDropdown = false;
                        _showShippingDropdown = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCondition ?? 'Select Condition',
                            style: TextStyle(
                              color: _selectedCondition != null
                                  ? textColor
                                  : const Color(AppColors.grayPlaceholder),
                            ),
                          ),
                          Icon(
                            _showConditionDropdown
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: const Color(AppColors.grayMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showConditionDropdown)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: _conditions.map((condition) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCondition = condition;
                                _showConditionDropdown = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: borderColor,
                                    width: condition != _conditions.last ? 1 : 0,
                                  ),
                                ),
                              ),
                              child: Text(
                                condition,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
              textColor: textColor,
            ),

            // Price & Quantity Row
            Row(
              children: [
                Expanded(
                  child: _buildSection(
                    label: 'Price (£) *',
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0.00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        filled: true,
                        fillColor: cardColor,
                      ),
                      style: TextStyle(color: textColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                    textColor: textColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSection(
                    label: 'Quantity',
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '1',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        filled: true,
                        fillColor: cardColor,
                      ),
                      style: TextStyle(color: textColor),
                    ),
                    textColor: textColor,
                  ),
                ),
              ],
            ),

            // Location & Postcode Row
            Row(
              children: [
                Expanded(
                  child: _buildSection(
                    label: 'City *',
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Enter city',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        filled: true,
                        fillColor: cardColor,
                      ),
                      style: TextStyle(color: textColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                    textColor: textColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSection(
                    label: 'Postcode *',
                    child: TextFormField(
                      controller: _postcodeController,
                      decoration: InputDecoration(
                        hintText: 'Enter postcode',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        filled: true,
                        fillColor: cardColor,
                      ),
                      style: TextStyle(color: textColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                    textColor: textColor,
                  ),
                ),
              ],
            ),

            // Brand & Model Row
            Row(
              children: [
                Expanded(
                  child: _buildSection(
                    label: 'Brand',
                    child: TextFormField(
                      controller: _brandController,
                      decoration: InputDecoration(
                        hintText: 'Enter brand',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        filled: true,
                        fillColor: cardColor,
                      ),
                      style: TextStyle(color: textColor),
                    ),
                    textColor: textColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSection(
                    label: 'Model',
                    child: TextFormField(
                      controller: _modelController,
                      decoration: InputDecoration(
                        hintText: 'Enter model',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        filled: true,
                        fillColor: cardColor,
                      ),
                      style: TextStyle(color: textColor),
                    ),
                    textColor: textColor,
                  ),
                ),
              ],
            ),

            // Size & Color Row
            Row(
              children: [
                Expanded(
                  child: _buildSection(
                    label: 'Size',
                    child: TextFormField(
                      controller: _sizeController,
                      decoration: InputDecoration(
                        hintText: 'Enter size',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        filled: true,
                        fillColor: cardColor,
                      ),
                      style: TextStyle(color: textColor),
                    ),
                    textColor: textColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSection(
                    label: 'Color',
                    child: TextFormField(
                      controller: _colorController,
                      decoration: InputDecoration(
                        hintText: 'Enter color',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        filled: true,
                        fillColor: cardColor,
                      ),
                      style: TextStyle(color: textColor),
                    ),
                    textColor: textColor,
                  ),
                ),
              ],
            ),

            // Shipping Details
            _buildSection(
              label: 'Shipping Type',
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showShippingDropdown = !_showShippingDropdown;
                        _showCategoryDropdown = false;
                        _showConditionDropdown = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _shippingTypes
                                    .firstWhere((s) => s['value'] == _shippingType)['label'] ??
                                'Select Shipping',
                            style: TextStyle(color: textColor),
                          ),
                          Icon(
                            _showShippingDropdown
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: const Color(AppColors.grayMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showShippingDropdown)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: _shippingTypes.map((shipping) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _shippingType = shipping['value']!;
                                if (_shippingType == 'free') {
                                  _shippingPriceController.clear();
                                }
                                _showShippingDropdown = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: borderColor,
                                    width: shipping != _shippingTypes.last ? 1 : 0,
                                  ),
                                ),
                              ),
                              child: Text(
                                shipping['label']!,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  if (_shippingType == 'paid')
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: _buildSection(
                        label: 'Shipping Price (£)',
                        child: TextFormField(
                          controller: _shippingPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '0.00',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            filled: true,
                            fillColor: cardColor,
                          ),
                          style: TextStyle(color: textColor),
                        ),
                        textColor: textColor,
                      ),
                    ),
                ],
              ),
              textColor: textColor,
            ),

            // Image Upload
            _buildSection(
              label: 'Upload Images (3-10) *',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ..._images.asMap().entries.map((entry) {
                        final index = entry.key;
                        final image = entry.value;
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                image,
                                width: imageSize,
                                height: imageSize,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      if (_images.length < 10)
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: imageSize,
                            height: imageSize,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: borderColor,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 24,
                                  color: const Color(AppColors.grayMedium),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add Image',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(AppColors.grayMedium),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${_images.length}/10 images uploaded',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(AppColors.grayMedium),
                      ),
                    ),
                  ),
                ],
              ),
              textColor: textColor,
            ),

            // Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'List Product',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access route arguments after context is available
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _selectedCategory = args['categoryName'] as String?;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    _postcodeController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _sizeController.dispose();
    _colorController.dispose();
    _shippingPriceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildSection({
    required String label,
    required Widget child,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              children: label.contains('*')
                  ? [
                      const TextSpan(
                        text: ' ',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_images.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least 3 images')),
      );
      return;
    }

    if (_selectedCategory == null || _selectedCondition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select category and condition')),
      );
      return;
    }

    // Handle form submission
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product listed successfully!')),
    );
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    if (_images.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can upload maximum 10 images')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        final remaining = 10 - _images.length;
        _images.addAll(
          pickedFiles.take(remaining).map((file) => File(file.path)),
        );
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }
}
