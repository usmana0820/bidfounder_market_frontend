import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../navigation/app_router.dart';
import '../../services/auth/auth_service.dart';

/// Reset Password Screen - Set new password after OTP verification
/// Matches login/register screen UI style
class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  bool get _isFormValid {
    return _passwordController.text.length >= 6 &&
        _passwordController.text == _confirmPasswordController.text;
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
                        AppStrings.resetPasswordTitle,
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
                        AppStrings.resetPasswordSubtitle,
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
                          // New Password Field
                          FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: _buildPasswordField(),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1450),
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
                          SizedBox(height: screenHeight * 0.02),
                          // Confirm Password Field
                          FadeInUp(
                            duration: const Duration(milliseconds: 1500),
                            child: _buildConfirmPasswordField(),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1550),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _confirmPasswordController.text.isEmpty
                                    ? 'Re-enter your password to confirm'
                                    : _passwordController.text ==
                                            _confirmPasswordController.text
                                        ? 'Passwords match ✓'
                                        : 'Passwords do not match',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  color: _confirmPasswordController.text.isNotEmpty &&
                                          _passwordController.text ==
                                              _confirmPasswordController.text
                                      ? const Color(AppColors.success)
                                      : const Color(AppColors.grayMedium),
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
                                    : _handleResetPassword,
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
                                        AppStrings.resetPasswordAction,
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
            hintText: 'Enter new password',
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

  Widget _buildConfirmPasswordField() {
    final hasFocus = _confirmPasswordFocus.hasFocus;
    final hasValue = _confirmPasswordController.text.isNotEmpty;
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
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocus,
          obscureText: _obscureConfirmPassword,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: 'Confirm new password',
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
                _obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(AppColors.grayMedium),
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
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
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final newPassword = _passwordController.text;

        // Print request data
        debugPrint('📤 Reset Password API Request:');
        debugPrint('   Email: ${widget.email}');
        debugPrint('   New Password: ${'*' * newPassword.length}');

        // Call reset password API
        final response = await AuthService.resetPassword(
          email: widget.email,
          newPassword: newPassword,
        );

        // Print response
        debugPrint('✅ Reset Password API Response:');
        debugPrint('   $response');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successful'),
              backgroundColor: Color(AppColors.success),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          );

          // Navigate back to login screen
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.login,
            (route) => false,
          );
        }
      } catch (e) {
        // Print error
        debugPrint('❌ Reset Password API Error:');
        debugPrint('   $e');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset failed: ${e.toString()}'),
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Auto focus after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _passwordFocus.requestFocus();
      }
    });
  }
}

