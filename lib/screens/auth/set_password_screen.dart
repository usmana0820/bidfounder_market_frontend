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
    return AppScaffold(
      title: AppStrings.setPassword,
      showBackButton: true,
      showCart: false,
      showBottomNav: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppStrings.setPasswordTitle),
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

