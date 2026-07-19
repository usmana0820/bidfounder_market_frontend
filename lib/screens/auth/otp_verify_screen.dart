import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../navigation/app_router.dart';
import '../../services/auth/auth_service.dart';
import '../../store/auth_store.dart';

/// OTP Verify Screen with gradient background and animations
class OTPVerifyScreen extends StatefulWidget {
  final String? phoneNumber;

  const OTPVerifyScreen({super.key, this.phoneNumber});

  @override
  State<OTPVerifyScreen> createState() => _OTPVerifyScreenState();
}

class _OTPVerifyScreenState extends State<OTPVerifyScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool get _isOTPComplete => _otpCode.length == 4;

  String get _otpCode => _otpControllers.map((c) => c.text).join();

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
                        AppStrings.otpVerification,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSize.clamp(28.0, 40.0),
                          fontWeight: FontWeight.bold,
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
                    child: Column(
                      children: [
                        SizedBox(height: formTopPadding),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) {
                              return _buildOTPField(index);
                            }),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1450),
                          child: Builder(
                            builder: (context) {
                              final args = ModalRoute.of(context)?.settings.arguments;
                              final email = args is Map<String, dynamic> ? args['email'] as String? : null;
                              final phoneNumber = args is Map<String, dynamic> ? args['phoneNumber'] as String? : widget.phoneNumber;
                              
                              return Column(
                                children: [
                                  
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    'We sent a 4-digit code to',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(AppColors.grayMedium),
                                      fontSize: subtitleSize.clamp(12.0, 14.0),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Text(
                                    email ?? phoneNumber ?? "+92XXXXXXXXXX",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(AppColors.primary),
                                      fontSize: subtitleSize.clamp(14.0, 16.0),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                 
                                ],
                              );
                            },
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Didn't receive the code? ",
                                style: TextStyle(
                                  color: const Color(AppColors.grayMedium),
                                  fontSize: subtitleSize.clamp(12.0, 14.0),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('OTP resent successfully'),
                                      backgroundColor: Color(AppColors.success),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  AppStrings.setPassword,
                                  style: TextStyle(
                                    color: const Color(AppColors.primary),
                                    fontSize: subtitleSize.clamp(12.0, 14.0),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: MaterialButton(
                              onPressed: _isOTPComplete ? _handleVerify : null,
                              color: _isOTPComplete
                                  ? const Color(AppColors.primary)
                                  : const Color(AppColors.grayMedium),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Text(
                                AppStrings.verify,
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Auto focus first field after animation
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  Widget _buildOTPField(int index) {
    final hasValue = _otpControllers[index].text.isNotEmpty;
    final screenWidth = MediaQuery.of(context).size.width;
    final otpFieldSize = (screenWidth * 0.15).clamp(50.0, 70.0);
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
      width: otpFieldSize,
      height: otpFieldSize,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasValue
              ? const Color(AppColors.primary)
              : borderColor,
          width: hasValue ? 2 : 1,
        ),
        boxShadow: hasValue
            ? [
                BoxShadow(
                  color: const Color(AppColors.primary).withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        style: TextStyle(
          fontSize: otpFieldSize * 0.4,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        onChanged: (value) => _onOTPChanged(index, value),
      ),
    );
  }

  void _handleVerify() async {
    if (_isOTPComplete) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        // Get email from route arguments
        final args = ModalRoute.of(context)?.settings.arguments;
        final email = args is Map<String, dynamic> ? args['email'] as String? : null;

        if (email == null || email.isEmpty) {
          Navigator.pop(context); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email is required for OTP verification'),
              backgroundColor: Color(AppColors.error),
            ),
          );
          return;
        }

        // Print request data
        debugPrint('📤 Verify OTP API Request:');
        debugPrint('   Email: $email');
        debugPrint('   Code: $_otpCode');

        // Check if this is for password reset
        final isPasswordReset = args is Map<String, dynamic>
            ? args['isPasswordReset'] as bool? ?? false
            : false;

        // Verify OTP
        final response = await AuthService.verifyOtp(
          email: email,
          code: _otpCode,
        );

        // Print response
        debugPrint('✅ Verify OTP API Response:');
        debugPrint('   $response');

        if (mounted) {
          Navigator.pop(context); // Close loading

          if (isPasswordReset) {
            // Navigate to reset password screen
            Navigator.pushReplacementNamed(
              context,
              AppRouter.resetPassword,
              arguments: {
                'email': email,
              },
            );
          } else {
            // Get auth store and load user profile
            final authStore = Provider.of<AuthStore>(context, listen: false);
            await authStore.loadProfile();

            // Navigate to dashboard on successful verification
            Navigator.pushReplacementNamed(context, AppRouter.dashboard);
          }
        }
      } catch (e) {
        // Print error
        debugPrint('❌ Verify OTP API Error:');
        debugPrint('   $e');

        if (mounted) {
          Navigator.pop(context); // Close loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('OTP verification failed: ${e.toString()}'),
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

  void _onOTPChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }
}
