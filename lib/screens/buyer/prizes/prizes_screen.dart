import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../widgets/app_scaffold.dart';

/// Prize Model
class Prize {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double entryFee;
  final int totalParticipants;
  final int maxParticipants;
  final DateTime endDate;
  final bool isActive;
  final String? winnerName;

  Prize({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.entryFee,
    required this.totalParticipants,
    required this.maxParticipants,
    required this.endDate,
    required this.isActive,
    this.winnerName,
  });
}

/// Prizes Screen - Users can participate in draws by spending $1
/// Winners are randomly chosen from participants
class PrizesScreen extends StatefulWidget {
  const PrizesScreen({super.key});

  @override
  State<PrizesScreen> createState() => _PrizesScreenState();
}

class _PrizesScreenState extends State<PrizesScreen> {
  final List<Prize> _activePrizes = [];
  final List<Prize> _pastPrizes = [];
  bool _isLoading = false;
  String _selectedTab = 'active'; // 'active' or 'past'

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);
    final backgroundColor = isDark
        ? const Color(AppColors.darkBackground)
        : const Color(AppColors.background);
    final borderColor = isDark
        ? const Color(AppColors.darkBorder)
        : const Color(AppColors.grayLight);

    return AppScaffold(
      title: 'Prizes & Draws',
      showBackButton: true,
      showCart: false,
      showGift: false,
      showBottomNav: false,
      roundedCorners: true, // Rounded corners for prizes screen
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    'Active Draws',
                    'active',
                    _selectedTab == 'active',
                    textColor,
                    cardColor,
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    'Past Draws',
                    'past',
                    _selectedTab == 'past',
                    textColor,
                    cardColor,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _selectedTab == 'active'
                ? _buildActivePrizesList(textColor, cardColor, borderColor, backgroundColor)
                : _buildPastPrizesList(textColor, cardColor, borderColor),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPrizes();
  }

  Widget _buildActivePrizesList(
    Color textColor,
    Color cardColor,
    Color borderColor,
    Color backgroundColor,
  ) {
    if (_activePrizes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.card_giftcard,
              size: 64,
              color: const Color(AppColors.grayMedium),
            ),
            const SizedBox(height: 16),
            Text(
              'No active draws available',
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _activePrizes.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          duration: Duration(milliseconds: 300 + (index * 100)),
          child: _buildPrizeCard(
            _activePrizes[index],
            textColor,
            cardColor,
            borderColor,
            backgroundColor,
            isActive: true,
          ),
        );
      },
    );
  }

  Widget _buildPastPrizesList(
    Color textColor,
    Color cardColor,
    Color borderColor,
  ) {
    if (_pastPrizes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: const Color(AppColors.grayMedium),
            ),
            const SizedBox(height: 16),
            Text(
              'No past draws available',
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _pastPrizes.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          duration: Duration(milliseconds: 300 + (index * 100)),
          child: _buildPrizeCard(
            _pastPrizes[index],
            textColor,
            cardColor,
            borderColor,
            cardColor,
            isActive: false,
          ),
        );
      },
    );
  }

  Widget _buildPrizeCard(
    Prize prize,
    Color textColor,
    Color cardColor,
    Color borderColor,
    Color backgroundColor, {
    required bool isActive,
  }) {
    final daysRemaining = prize.endDate.difference(DateTime.now()).inDays;
    final progress = prize.totalParticipants / prize.maxParticipants;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prize Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.asset(
                  prize.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: const Color(AppColors.grayLight),
                      child: const Icon(Icons.image, size: 50),
                    );
                  },
                ),
                if (isActive)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(AppColors.success),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Prize Title
                Text(
                  prize.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                // Prize Description
                Text(
                  prize.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                // Participants Progress
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Participants',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withValues(alpha: 0.7),
                          ),
                        ),
                        Text(
                          '${prize.totalParticipants} / ${prize.maxParticipants}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: backgroundColor,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Entry Fee and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(AppColors.primary).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            size: 16,
                            color: Color(AppColors.primary),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '\$${prize.entryFee.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(AppColors.warning).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Color(AppColors.warning),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              daysRemaining > 0
                                  ? '$daysRemaining days left'
                                  : 'Ending soon',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(AppColors.warning),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (prize.winnerName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(AppColors.success).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.emoji_events,
                              size: 16,
                              color: Color(AppColors.success),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Winner: ${prize.winnerName}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(AppColors.success),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Participate Button
                if (isActive)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _handleParticipate(prize),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Participate for \$1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    String label,
    String value,
    bool isSelected,
    Color textColor,
    Color cardColor,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(AppColors.primary) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Future<void> _handleParticipate(Prize prize) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Participate in Draw?'),
        content: Text(
          'You will be charged \$${prize.entryFee.toStringAsFixed(2)} to participate in the "${prize.title}" draw. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppColors.primary),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        // Update participant count by replacing the prize with a new instance
        final prizeIndex = _activePrizes.indexWhere((p) => p.id == prize.id);
        if (prizeIndex != -1) {
          _activePrizes[prizeIndex] = Prize(
            id: prize.id,
            title: prize.title,
            description: prize.description,
            imageUrl: prize.imageUrl,
            entryFee: prize.entryFee,
            totalParticipants: prize.totalParticipants + 1,
            maxParticipants: prize.maxParticipants,
            endDate: prize.endDate,
            isActive: prize.isActive,
            winnerName: prize.winnerName,
          );
        }
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully entered the "${prize.title}" draw!'),
          backgroundColor: const Color(AppColors.success),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _loadPrizes() {
    // Mock data - In real app, this would come from API
    setState(() {
      _activePrizes.addAll([
        Prize(
          id: '1',
          title: 'iPhone 15 Pro',
          description: 'Latest iPhone with Pro features',
          imageUrl: 'assets/images/Electronics.jpg',
          entryFee: 1.0,
          totalParticipants: 245,
          maxParticipants: 500,
          endDate: DateTime.now().add(const Duration(days: 5)),
          isActive: true,
        ),
        Prize(
          id: '2',
          title: 'Samsung Galaxy S24',
          description: 'Premium Android smartphone',
          imageUrl: 'assets/images/Electronics.jpg',
          entryFee: 1.0,
          totalParticipants: 189,
          maxParticipants: 300,
          endDate: DateTime.now().add(const Duration(days: 3)),
          isActive: true,
        ),
        Prize(
          id: '3',
          title: 'MacBook Pro',
          description: 'High-performance laptop',
          imageUrl: 'assets/images/Electronics.jpg',
          entryFee: 1.0,
          totalParticipants: 456,
          maxParticipants: 1000,
          endDate: DateTime.now().add(const Duration(days: 7)),
          isActive: true,
        ),
      ]);

      _pastPrizes.addAll([
        Prize(
          id: '4',
          title: 'iPad Air',
          description: 'Previous draw winner',
          imageUrl: 'assets/images/Electronics.jpg',
          entryFee: 1.0,
          totalParticipants: 320,
          maxParticipants: 500,
          endDate: DateTime.now().subtract(const Duration(days: 2)),
          isActive: false,
          winnerName: 'John Doe',
        ),
      ]);
    });
  }
}

