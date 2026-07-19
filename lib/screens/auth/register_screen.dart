import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_constants.dart';
import '../../navigation/app_router.dart';
import '../../services/auth/auth_service.dart';

/// Register Screen - Registration with email, phone number, full name, password
/// Matches phone_number_screen UI style
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _fullNameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isLoading = false;

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
        _emailController.text.contains('@') &&
        _phoneController.text.length == 10 &&
        _fullNameController.text.isNotEmpty &&
        _passwordController.text.length >= 6;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final titleSize = screenWidth * 0.1;
    final subtitleSize = screenWidth * 0.045;
    final contentPadding = screenWidth * 0.075;
    final formTopPadding = isSmallScreen ? 30.0 : 60.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(AppColors.primary),
              const Color(AppColors.primary).withValues(alpha: 0.9),
              const Color(AppColors.primary).withValues(alpha: 0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: EdgeInsets.all(contentPadding),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        AppStrings.registerTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSize.clamp(28.0, 40.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: Text(
                        AppStrings.registerSubtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: subtitleSize.clamp(14.0, 16.0),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1400),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate back to login screen
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Text(
                              AppStrings.haveAccountQuestion,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: subtitleSize.clamp(12.0, 16.0),
                              ),
                            ),
                            Text(
                              AppStrings.loginHere,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: subtitleSize.clamp(12.0, 16.0),
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(contentPadding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: formTopPadding),
                          // Full Name Field
                          FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: _buildTextField(
                              controller: _fullNameController,
                              focusNode: _fullNameFocus,
                              hintText: 'Enter your full name',
                              icon: Icons.person_outline,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          // Email Field
                          FadeInUp(
                            duration: const Duration(milliseconds: 1500),
                            child: _buildTextField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              hintText: 'Enter your email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          // Phone Number Field
                          FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: _buildPhoneField(),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1650),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${_phoneController.text.length}/10 digits',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  color: _phoneController.text.length == 10
                                      ? const Color(AppColors.success)
                                      : const Color(AppColors.grayMedium),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          // Password Field
                          FadeInUp(
                            duration: const Duration(milliseconds: 1700),
                            child: _buildPasswordField(),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1750),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _passwordController.text.isEmpty
                                    ? 'Password must be at least 6 characters'
                                    : '${_passwordController.text.length}/6+ characters',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  color: _passwordController.text.length >= 6
                                      ? const Color(AppColors.success)
                                      : const Color(AppColors.grayMedium),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1800),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: MaterialButton(
                                onPressed: _isLoading || !_isFormValid
                                    ? null
                                    : _handleRegister,
                                color: _isLoading || !_isFormValid
                                    ? const Color(AppColors.grayMedium)
                                    : const Color(AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        AppStrings.createAccount,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
    required TextCapitalization textCapitalization,
    String? Function(String?)? validator,
  }) {
    final hasFocus = focusNode.hasFocus;
    final hasValue = controller.text.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);
    final borderColor = isDark
        ? const Color(AppColors.darkBorder)
        : Colors.grey.shade200;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.primary).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: borderColor),
          ),
        ),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(AppColors.grayPlaceholder),
            ),
            prefixIcon: Icon(
              icon,
              color: hasFocus || hasValue
                  ? const Color(AppColors.primary)
                  : const Color(AppColors.grayMedium),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 18,
            ),
          ),
          validator: validator,
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);
    final borderColor = isDark
        ? const Color(AppColors.darkBorder)
        : Colors.grey.shade200;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.primary).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderColor),
              ),
            ),
            child: Row(
              children: [
                // +92 prefix (fixed)
                Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(AppColors.primary)
                        .withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '+92',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(AppColors.primary),
                    ),
                  ),
                ),
                // Phone input (10 digits)
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: '3001234567',
                      hintStyle: TextStyle(
                        color: Color(AppColors.grayPlaceholder),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 18,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    final hasFocus = _passwordFocus.hasFocus;
    final hasValue = _passwordController.text.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);
    final borderColor = isDark
        ? const Color(AppColors.darkBorder)
        : Colors.grey.shade200;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(AppColors.primary).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: borderColor),
          ),
        ),
        child: TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          obscureText: _obscurePassword,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: AppStrings.passwordPlaceholder,
            hintStyle: const TextStyle(
              color: Color(AppColors.grayPlaceholder),
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: hasFocus || hasValue
                  ? const Color(AppColors.primary)
                  : const Color(AppColors.grayMedium),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(AppColors.grayMedium),
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 18,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Prepare registration data
        final email = _emailController.text.trim();
        final phoneNumber = '92${_phoneController.text}';
        final fullName = _fullNameController.text.trim();
        final password = _passwordController.text;

        // Print request data
        debugPrint('📤 Register API Request:');
        debugPrint('   Email: $email');
        debugPrint('   Phone Number: $phoneNumber');
        debugPrint('   Full Name: $fullName');
        debugPrint('   Password: ${'*' * password.length}');

        // Call register API with phone number format: 92XXXXXXXXXX
        final response = await AuthService.register(
          email: email,
          phoneNumber: phoneNumber,
          fullName: fullName,
          password: password,
        );

        // Print response
        debugPrint('✅ Register API Response:');
        debugPrint('   $response');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Navigate to OTP verification screen
          Navigator.pushReplacementNamed(
            context,
            AppRouter.otpVerify,
            arguments: {
              'email': email,
              'phoneNumber': '+92${_phoneController.text}',
            },
          );
        }
      } catch (e) {
        // Print error
        debugPrint('❌ Register API Error:');
        debugPrint('   $e');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed: ${e.toString()}'),
              backgroundColor: const Color(AppColors.error),
              behavior: SnackBarBehavior.floating,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _fullNameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Auto focus after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _fullNameFocus.requestFocus();
      }
    });
  }
}

