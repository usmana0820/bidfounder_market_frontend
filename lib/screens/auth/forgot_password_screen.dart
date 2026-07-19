import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../navigation/app_router.dart';
import '../../services/auth/auth_service.dart';

/// Forgot Password Screen - Request password reset OTP
/// Matches login/register screen UI style
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  bool _isLoading = false;

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
        _emailController.text.contains('@');
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
                        AppStrings.forgotPasswordTitle,
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
                        AppStrings.forgotPasswordSubtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: subtitleSize.clamp(14.0, 16.0),
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
                          // Email Field
                          FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: _buildTextField(),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1450),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'We will send a 6-digit OTP code to your email address',
                                style: TextStyle(
                                  color: const Color(AppColors.grayMedium),
                                  fontSize: screenWidth * 0.03,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: MaterialButton(
                                onPressed: _isLoading || !_isFormValid
                                    ? null
                                    : _handleForgotPassword,
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
                                        AppStrings.sendOtp,
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

  Widget _buildTextField() {
    final hasFocus = _emailFocus.hasFocus;
    final hasValue = _emailController.text.isNotEmpty;
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
          controller: _emailController,
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: const TextStyle(
              color: Color(AppColors.grayPlaceholder),
            ),
            prefixIcon: Icon(
              Icons.email_outlined,
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Future<void> _handleForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final email = _emailController.text.trim();

        // Print request data
        debugPrint('📤 Forgot Password API Request:');
        debugPrint('   Email: $email');

        // Call forgot password API
        final response = await AuthService.forgotPassword(email: email);

        // Print response
        debugPrint('✅ Forgot Password API Response:');
        debugPrint('   $response');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP sent to your email address'),
              backgroundColor: Color(AppColors.success),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          );

          // Navigate to OTP verification screen for password reset
          Navigator.pushReplacementNamed(
            context,
            AppRouter.otpVerify,
            arguments: {
              'email': email,
              'isPasswordReset': true, // Flag to indicate this is for password reset
            },
          );
        }
      } catch (e) {
        // Print error
        debugPrint('❌ Forgot Password API Error:');
        debugPrint('   $e');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send OTP: ${e.toString()}'),
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
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Auto focus after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _emailFocus.requestFocus();
      }
    });
  }
}

