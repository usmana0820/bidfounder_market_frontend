import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../navigation/app_router.dart';
import '../../widgets/app_scaffold.dart';

/// Set Password Screen
class SetPasswordScreen extends StatelessWidget {
  final String? phoneNumber;

  const SetPasswordScreen({super.key, this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);
    
    return AppScaffold(
      title: AppStrings.setPassword,
      showBackButton: true,
      showCart: false,
      showBottomNav: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.setPasswordTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRouter.login);
              },
              child: const Text(AppStrings.createAccount),
            ),
          ],
        ),
      ),
    );
  }
}

