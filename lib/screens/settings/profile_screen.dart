import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../navigation/app_router.dart';
import '../../store/auth_store.dart';
import '../../widgets/app_scaffold.dart';

/// Profile Screen - Displays and allows editing user profile
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;
  bool _isEditing = false;
  final _nameController = TextEditingController();
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    if (authStore.user == null) {
      await authStore.loadProfile();
    }
    if (mounted && authStore.user != null) {
      _nameController.text = authStore.user!.fullName;
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: const Color(AppColors.error),
          ),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Color(AppColors.error),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authStore = Provider.of<AuthStore>(context, listen: false);
      
      // Prepare update data
      File? profileImageFile;
      
      // If new image selected, prepare file for upload
      if (_selectedImagePath != null) {
        profileImageFile = File(_selectedImagePath!);
      }

      // Update profile (debug prints are in UserService)
      // If profileImageFile is provided, it will be uploaded via multipart/form-data
      final success = await authStore.updateProfile(
        fullName: _nameController.text.trim(),
        profileImage: profileImageFile,
      );

      if (!success) {
        throw Exception('Failed to update profile');
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isEditing = false;
          _selectedImagePath = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Color(AppColors.success),
          ),
        );
      }
    } catch (e) {
      // Error is already logged in UserService
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'),
            backgroundColor: const Color(AppColors.error),
          ),
        );
      }
    }
  }

  void _cancelEdit() {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    if (authStore.user != null) {
      _nameController.text = authStore.user!.fullName;
    }
    setState(() {
      _isEditing = false;
      _selectedImagePath = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Consumer<AuthStore>(
      builder: (context, authStore, _) {
        final user = authStore.user;
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
    final primaryColor = const Color(AppColors.primary);
    final secondaryColor = const Color(AppColors.secondary);
    final backgroundColor = isDark
        ? const Color(AppColors.darkBackground)
        : const Color(AppColors.background);

    return AppScaffold(
      title: AppStrings.profile,
      showBackButton: true,
      showCart: false,
      showBottomNav: false,
      rightAction: !_isEditing && user != null
          ? IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
          : null,
      body: authStore.isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Color(AppColors.error),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load profile',
                        style: TextStyle(
                          fontSize: 18,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadProfile,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Gradient Header Section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.03,
                          bottom: screenHeight * 0.04,
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryColor,
                              primaryColor.withValues(alpha: 0.8),
                              primaryColor.withValues(alpha: 0.6),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Avatar with edit option
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: _isEditing ? _pickImage : null,
                                  child: Container(
                                    width: screenWidth * 0.3.clamp(100.0, 140.0),
                                    height: screenWidth * 0.3.clamp(100.0, 140.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: _selectedImagePath != null
                                        ? ClipOval(
                                            child: Image.file(
                                              File(_selectedImagePath!),
                                              fit: BoxFit.cover,
                                              width: screenWidth * 0.3.clamp(100.0, 140.0),
                                              height: screenWidth * 0.3.clamp(100.0, 140.0),
                                              errorBuilder: (context, error, stackTrace) {
                                                debugPrint('❌ Error loading selected image: $error');
                                                return _buildAvatarInitial(user.fullName, isWhite: true);
                                              },
                                            ),
                                          )
                                        : user.profileImage != null && user.profileImage!.isNotEmpty
                                            ? _buildProfileImageWithFallback(
                                                user: user,
                                                screenWidth: screenWidth,
                                                primaryColor: primaryColor,
                                                isWhite: true,
                                              )
                                            : _buildAvatarInitial(user.fullName, isWhite: true),
                                  ),
                                ),
                                if (_isEditing)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: primaryColor,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 20,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.025),
                            // Name Field (editable when editing)
                            if (_isEditing)
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: _nameController,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white.withValues(alpha: 0.2),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Text(
                                user.fullName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      // Content Section
                      Transform.translate(
                        offset: const Offset(0, -20),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.all(screenWidth * 0.05.clamp(16.0, 24.0)),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Section Title
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.person_outline,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Personal Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // User Information Section
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(screenWidth * 0.04.clamp(16.0, 20.0)),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: borderColor.withValues(alpha: 0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Email
                                    _buildInfoRow(
                                      icon: Icons.email_outlined,
                                      label: 'Email',
                                      value: user.email,
                                      textColor: textColor,
                                      secondaryColor: secondaryColor,
                                      primaryColor: primaryColor,
                                      screenWidth: screenWidth,
                                    ),
                                    if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) ...[
                                      SizedBox(height: screenHeight * 0.02),
                                      Divider(color: borderColor.withValues(alpha: 0.3), height: 1),
                                      SizedBox(height: screenHeight * 0.02),
                                      // Phone Number
                                      _buildInfoRow(
                                        icon: Icons.phone_outlined,
                                        label: 'Phone Number',
                                        value: user.phoneNumber!,
                                        textColor: textColor,
                                        secondaryColor: secondaryColor,
                                        primaryColor: primaryColor,
                                        screenWidth: screenWidth,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            // Action Buttons
                            if (_isEditing) ...[
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: _isLoading ? null : _cancelEdit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: backgroundColor,
                                      foregroundColor: textColor,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: _isLoading ? null : _saveProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          )
                                        : const Text('Save'),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Settings Menu Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(screenWidth * 0.05.clamp(16.0, 24.0)),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.settings_outlined,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  AppStrings.settings,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Account Settings
                            _buildMenuItem(
                              title: AppStrings.accountSettings,
                              icon: Icons.account_circle_outlined,
                              onTap: () {
                                Navigator.pushNamed(context, AppRouter.accountSettings);
                              },
                              textColor: textColor,
                              borderColor: borderColor,
                              backgroundColor: backgroundColor,
                              primaryColor: primaryColor,
                            ),
                            // Notifications
                            _buildMenuItem(
                              title: AppStrings.notifications,
                              icon: Icons.notifications_outlined,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Notifications settings coming soon'),
                                  ),
                                );
                              },
                              textColor: textColor,
                              borderColor: borderColor,
                              backgroundColor: backgroundColor,
                              primaryColor: primaryColor,
                            ),
                            // Privacy
                            _buildMenuItem(
                              title: AppStrings.privacy,
                              icon: Icons.lock_outline,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Privacy settings coming soon'),
                                  ),
                                );
                              },
                              textColor: textColor,
                              borderColor: borderColor,
                              backgroundColor: backgroundColor,
                              primaryColor: primaryColor,
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      );
    },
    );
  }

  /// Build profile image with fallback to initial letter
  /// Tries to load the image from the primary URL, falls back to initial if it fails
  Widget _buildProfileImageWithFallback({
    required User user,
    required double screenWidth,
    required Color primaryColor,
    bool isWhite = false,
  }) {
    final imageSize = isWhite 
        ? screenWidth * 0.3.clamp(100.0, 140.0)
        : screenWidth * 0.25.clamp(80.0, 120.0);
    
    // If no profile image URL, show initial
    if (user.profileImageUrl == null || user.profileImageUrl!.isEmpty) {
      return _buildAvatarInitial(user.fullName, isWhite: isWhite);
    }
    
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: user.profileImageUrl!,
        fit: BoxFit.cover,
        width: imageSize,
        height: imageSize,
        placeholder: (context, url) => Container(
          width: imageSize,
          height: imageSize,
          color: primaryColor.withValues(alpha: 0.1),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          // Log error for debugging
          debugPrint('❌ Profile image failed to load:');
          debugPrint('   URL: $url');
          debugPrint('   Error: $error');
          debugPrint('   Profile Image: ${user.profileImage}');
          debugPrint('   Trying alternative paths...');
          
          // Try alternative paths if available
          final alternatives = user.profileImageUrlAlternatives;
          if (alternatives.length > 1) {
            debugPrint('   Alternative URLs: ${alternatives.sublist(1)}');
          }
          
          // Always fallback to initial letter avatar
          return _buildAvatarInitial(user.fullName, isWhite: isWhite);
        },
        httpHeaders: const {
          'Accept': 'image/*',
        },
        // Add cache configuration
        memCacheWidth: imageSize.toInt(),
        memCacheHeight: imageSize.toInt(),
        maxWidthDiskCache: imageSize.toInt() * 2,
        maxHeightDiskCache: imageSize.toInt() * 2,
      ),
    );
  }

  Widget _buildAvatarInitial(String name, {bool isWhite = false}) {
    final initial = name.isNotEmpty
        ? name[0].toUpperCase()
        : 'U';
    final textColor = isWhite ? Colors.white : const Color(AppColors.primary);
    return Center(
      child: Text(
        initial,
        style: TextStyle(
          color: textColor,
          fontSize: isWhite ? 50 : 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color secondaryColor,
    required Color primaryColor,
    required double screenWidth,
  }) {
    final iconSize = screenWidth * 0.05.clamp(18.0, 24.0);
    final labelSize = screenWidth * 0.03.clamp(11.0, 13.0);
    final valueSize = screenWidth * 0.04.clamp(14.0, 16.0);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.02.clamp(6.0, 10.0)),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: primaryColor,
          ),
        ),
        SizedBox(width: screenWidth * 0.03.clamp(10.0, 14.0)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: labelSize,
                  color: secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: screenWidth * 0.01.clamp(2.0, 6.0)),
              Text(
                value,
                style: TextStyle(
                  fontSize: valueSize,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color textColor,
    required Color borderColor,
    required Color backgroundColor,
    required Color primaryColor,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(color: borderColor.withValues(alpha: 0.2), width: 1),
                  ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: textColor.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
