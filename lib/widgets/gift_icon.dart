import 'package:flutter/material.dart';

import '../navigation/app_router.dart';

/// Gift Icon Widget for prizes/draws section
class GiftIcon extends StatelessWidget {
  const GiftIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.card_giftcard, color: Colors.white),
      onPressed: () {
        // Navigate to prizes screen
        Navigator.pushNamed(context, AppRouter.prizes);
      },
      tooltip: 'Prizes & Draws',
    );
  }
}

