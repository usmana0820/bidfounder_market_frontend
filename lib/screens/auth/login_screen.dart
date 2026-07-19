import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../navigation/app_router.dart';
import '../../services/auth/auth_service.dart';
import '../../store/auth_store.dart';

/// Login Screen with gradient background, shape animations, and form fields
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final topPadding = isSmallScreen ? 40.0 : 80.0;
    final titleSize = screenWidth * 0.1; // Responsive title size
    final subtitleSize = screenWidth * 0.045;
    final contentPadding = screenWidth * 0.075; // Responsive padding
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
              SizedBox(height: topPadding),
              Padding(
                padding: EdgeInsets.all(contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        AppStrings.loginTitle,
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
                        AppStrings.welcomeBack,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: subtitleSize.clamp(14.0, 18.0),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1400),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to register screen for new user registration
                          Navigator.pushNamed(context, AppRouter.register);
                        },
                        child: Row(
                          children: [
                            Text(
                              AppStrings.noAccountQuestion,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: subtitleSize.clamp(12.0, 16.0),
                              ),
                            ),
                            Text(
                              AppStrings.registerHere,
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
                          // Password Field
                          FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: _buildPasswordField(),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1650),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRouter.forgotPassword);
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    color: const Color(AppColors.primary),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1700),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: MaterialButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                color: _isLoading
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
                                        AppStrings.login,
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
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
              return 'Please enter your password';
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

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Prepare login data
        final email = _emailController.text.trim();
        final password = _passwordController.text;

        // Print request data
        debugPrint('📤 Login API Request:');
        debugPrint('   Email: $email');
        debugPrint('   Password: ${'*' * password.length}');

        // Call login API
        final response = await AuthService.login(
          email: email,
          password: password,
        );

        // Print response
        debugPrint('✅ Login API Response:');
        debugPrint('   $response');

        if (mounted) {
          // Get auth store and load user profile
          final authStore = Provider.of<AuthStore>(context, listen: false);
          await authStore.loadProfile();

          setState(() {
            _isLoading = false;
          });

          // Navigate to dashboard on successful login
          Navigator.pushReplacementNamed(context, AppRouter.dashboard);
        }
      } catch (e) {
        // Print error
        debugPrint('❌ Login API Error:');
        debugPrint('   $e');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${e.toString()}'),
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
}
