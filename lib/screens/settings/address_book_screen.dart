import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../models/address_model.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/button.dart';

/// Address Book Screen - Manage user addresses
class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  // Mock addresses - In real app, this would come from a store/service
  List<Address> _addresses = [
    Address(
      id: '1',
      label: 'Home',
      fullName: 'John Doe',
      phoneNumber: '+92 300 1234567',
      addressLine1: '123 Main Street',
      addressLine2: 'Apartment 4B',
      city: 'Lahore',
      state: 'Punjab',
      postalCode: '54000',
      country: 'Pakistan',
      isDefault: true,
    ),
    Address(
      id: '2',
      label: 'Work',
      fullName: 'John Doe',
      phoneNumber: '+92 300 1234567',
      addressLine1: '456 Business Avenue',
      city: 'Karachi',
      state: 'Sindh',
      postalCode: '75500',
      country: 'Pakistan',
      isDefault: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
    final backgroundColor = isDark
        ? const Color(AppColors.darkBackground)
        : const Color(AppColors.background);
    final primaryColor = const Color(AppColors.primary);

    return AppScaffold(
      title: 'Address Book',
      showBackButton: true,
      showCart: false,
      showBottomNav: false,
      body: Column(
        children: [
          Expanded(
            child: _addresses.isEmpty
                ? _buildEmptyState(textColor, primaryColor)
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _addresses.length,
                    itemBuilder: (context, index) {
                      return _buildAddressCard(
                        _addresses[index],
                        cardColor,
                        borderColor,
                        textColor,
                        backgroundColor,
                        primaryColor,
                        index,
                      );
                    },
                  ),
          ),
          // Add Address Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                top: BorderSide(color: borderColor, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: AppButton(
              title: 'Add New Address',
              onPress: () => _showAddEditAddressDialog(null),
              fullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 64,
            color: Color(AppColors.grayMedium),
          ),
          const SizedBox(height: 20),
          Text(
            'No addresses saved',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Add an address to get started',
            style: TextStyle(
              fontSize: 16,
              color: const Color(AppColors.grayMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(
    Address address,
    Color cardColor,
    Color borderColor,
    Color textColor,
    Color backgroundColor,
    Color primaryColor,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: address.isDefault ? primaryColor : borderColor,
          width: address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: address.isDefault
                      ? primaryColor.withValues(alpha: 0.1)
                      : backgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getLabelIcon(address.label),
                      size: 14,
                      color: address.isDefault ? primaryColor : textColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      address.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: address.isDefault ? primaryColor : textColor,
                      ),
                    ),
                    if (address.isDefault) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              // Edit Button
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: primaryColor,
                onPressed: () => _showAddEditAddressDialog(address),
              ),
              // Delete Button
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: const Color(AppColors.error),
                onPressed: () => _handleDeleteAddress(address),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            address.fullName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address.phoneNumber,
            style: TextStyle(
              fontSize: 14,
              color: const Color(AppColors.grayMedium),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            address.fullAddress,
            style: TextStyle(
              fontSize: 14,
              color: textColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLabelIcon(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'other':
        return Icons.location_on;
      default:
        return Icons.location_on;
    }
  }

  void _showAddEditAddressDialog(Address? address) {
    final isEdit = address != null;
    final primaryColor = const Color(AppColors.primary);
    final labelController = TextEditingController(text: address?.label ?? '');
    final fullNameController = TextEditingController(text: address?.fullName ?? '');
    final phoneController = TextEditingController(text: address?.phoneNumber ?? '');
    final addressLine1Controller = TextEditingController(text: address?.addressLine1 ?? '');
    final addressLine2Controller = TextEditingController(text: address?.addressLine2 ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    final stateController = TextEditingController(text: address?.state ?? '');
    final postalCodeController = TextEditingController(text: address?.postalCode ?? '');
    final countryController = TextEditingController(text: address?.country ?? 'Pakistan');
    bool isDefault = address?.isDefault ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEdit ? 'Edit Address' : 'Add New Address'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: labelController,
                      decoration: const InputDecoration(
                        labelText: 'Label (Home, Work, etc.)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: addressLine1Controller,
                      decoration: const InputDecoration(
                        labelText: 'Address Line 1',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: addressLine2Controller,
                      decoration: const InputDecoration(
                        labelText: 'Address Line 2 (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: cityController,
                            decoration: const InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: stateController,
                            decoration: const InputDecoration(
                              labelText: 'State',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: postalCodeController,
                            decoration: const InputDecoration(
                              labelText: 'Postal Code',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: countryController,
                            decoration: const InputDecoration(
                              labelText: 'Country',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      title: const Text('Set as default address'),
                      value: isDefault,
                      onChanged: (value) {
                        setDialogState(() {
                          isDefault = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (labelController.text.isEmpty ||
                        fullNameController.text.isEmpty ||
                        addressLine1Controller.text.isEmpty ||
                        cityController.text.isEmpty ||
                        stateController.text.isEmpty ||
                        postalCodeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all required fields'),
                          backgroundColor: Color(AppColors.error),
                        ),
                      );
                      return;
                    }

                    final newAddress = Address(
                      id: address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      label: labelController.text,
                      fullName: fullNameController.text,
                      phoneNumber: phoneController.text,
                      addressLine1: addressLine1Controller.text,
                      addressLine2: addressLine2Controller.text.isEmpty
                          ? null
                          : addressLine2Controller.text,
                      city: cityController.text,
                      state: stateController.text,
                      postalCode: postalCodeController.text,
                      country: countryController.text,
                      isDefault: isDefault,
                    );

                    setState(() {
                      if (isEdit) {
                        final index = _addresses.indexWhere((a) => a.id == address.id);
                        if (index != -1) {
                          _addresses[index] = newAddress;
                        }
                      } else {
                        _addresses.add(newAddress);
                      }

                      // If this is set as default, unset others
                      if (isDefault) {
                        for (var addr in _addresses) {
                          if (addr.id != newAddress.id) {
                            addr = Address(
                              id: addr.id,
                              label: addr.label,
                              fullName: addr.fullName,
                              phoneNumber: addr.phoneNumber,
                              addressLine1: addr.addressLine1,
                              addressLine2: addr.addressLine2,
                              city: addr.city,
                              state: addr.state,
                              postalCode: addr.postalCode,
                              country: addr.country,
                              isDefault: false,
                            );
                          }
                        }
                      }
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEdit ? 'Address updated' : 'Address added'),
                        backgroundColor: const Color(AppColors.success),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  child: const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleDeleteAddress(Address address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete this ${address.label} address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _addresses.removeWhere((a) => a.id == address.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address deleted'),
                  backgroundColor: Color(AppColors.success),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

