import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../widgets/app_scaffold.dart';

/// Bid Management Screen - Seller Side
class BidManagementScreen extends StatefulWidget {
  const BidManagementScreen({super.key});

  @override
  State<BidManagementScreen> createState() => _BidManagementScreenState();
}

class _BidManagementScreenState extends State<BidManagementScreen> {
  bool _showAcceptModal = false;
  bool _showCancelModal = false;

  final _auction = {
    'id': '1',
    'title': 'iPhone 15 Pro',
    'currentPrice': 999,
    'reservePrice': 800,
    'startDate': DateTime.now().subtract(const Duration(days: 1)),
    'endDate': DateTime.now().add(const Duration(days: 6)),
    'status': 'active',
    'bids': [
      {
        'id': '1',
        'amount': 999,
        'bidder': 'John Doe',
        'bidderId': 'user1',
        'timestamp': DateTime.now(),
        'isWinning': true,
      },
      {
        'id': '2',
        'amount': 950,
        'bidder': 'Jane Smith',
        'bidderId': 'user2',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'isWinning': false,
      },
      {
        'id': '3',
        'amount': 900,
        'bidder': 'Bob Johnson',
        'bidderId': 'user3',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'isWinning': false,
      },
    ],
  };

  bool get _canAccept {
    final status = _auction['status'] as String;
    final hasBids = (_auction['bids'] as List).isNotEmpty;
    final reservePrice = _auction['reservePrice'] as int?;
    if (status != 'active' || !hasBids) return false;
    if (reservePrice != null) {
      return (_highestBid['amount'] as int) >= reservePrice;
    }
    return true;
  }

  bool get _canCancel {
    return _auction['status'] == 'active' && (_auction['bids'] as List).isEmpty;
  }

  Map<String, dynamic> get _highestBid {
    final bids = _auction['bids'] as List;
    return bids.reduce((a, b) => (a['amount'] as int) > (b['amount'] as int) ? a : b);
  }

  @override
  Widget build(BuildContext context) {
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

    final bids = (_auction['bids'] as List)
      ..sort((a, b) => (b['amount'] as int).compareTo(a['amount'] as int));

    return AppScaffold(
      title: 'Bid Management',
      showBackButton: true,
      showCart: false,
      showBottomNav: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Auction Info
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _auction['title'] as String,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Current Price',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(AppColors.grayMedium),
                                ),
                              ),
                              Text(
                                '£${_auction['currentPrice']}',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(AppColors.grayLight),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              (_auction['status'] as String).toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_auction['reservePrice'] != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          'Reserve Price: £${_auction['reservePrice']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(AppColors.grayMedium),
                          ),
                        ),
                      ],
                      const SizedBox(height: 5),
                      Text(
                        '${_getTimeRemaining()} remaining',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(AppColors.grayMedium),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bid Statistics
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${bids.length}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const Text(
                            'Total Bids',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(AppColors.grayMedium),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '£${_highestBid['amount']}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const Text(
                            'Highest Bid',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(AppColors.grayMedium),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '£${bids.length > 1 ? (_highestBid['amount'] as int) - (bids[1]['amount'] as int) : 0}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const Text(
                            'Bid Increment',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(AppColors.grayMedium),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                if (_auction['status'] == 'active') ...[
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        if (_canAccept)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => setState(() => _showAcceptModal = true),
                              icon: const Icon(Icons.check_circle, color: Colors.white),
                              label: const Text(
                                'Accept Highest Bid',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(AppColors.primary),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        if (_canCancel) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => setState(() => _showCancelModal = true),
                              icon: const Icon(Icons.cancel, color: Color(AppColors.black)),
                              label: const Text(
                                'Cancel Auction',
                                style: TextStyle(color: Color(AppColors.black), fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: borderColor),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],

                // Bids List
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Bids',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (bids.isEmpty)
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.gavel,
                                size: 48,
                                color: const Color(AppColors.grayMedium),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'No bids placed yet',
                                style: TextStyle(
                                  color: const Color(AppColors.grayMedium),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...bids.asMap().entries.map((entry) {
                          final index = entry.key;
                          final bid = entry.value;
                          final isWinning = index == 0;
                          return Container(
                            margin: EdgeInsets.only(bottom: index < bids.length - 1 ? 10 : 0),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isWinning
                                  ? const Color(AppColors.grayLight)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isWinning
                                    ? const Color(AppColors.primary)
                                    : borderColor,
                                width: isWinning ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '#${index + 1}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isWinning
                                                ? const Color(AppColors.primary)
                                                : const Color(AppColors.grayMedium),
                                          ),
                                        ),
                                        if (isWinning) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(AppColors.primary),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'WINNING',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    Text(
                                      '£${bid['amount']}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bid['bidder'] as String,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(AppColors.grayMedium),
                                  ),
                                ),
                                Text(
                                  '${_formatDate(bid['timestamp'] as DateTime)} ${_formatTime(bid['timestamp'] as DateTime)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(AppColors.grayMedium),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Accept Bid Modal
          if (_showAcceptModal) _buildAcceptModal(cardColor, borderColor, textColor),
          // Cancel Auction Modal
          if (_showCancelModal) _buildCancelModal(cardColor, borderColor, textColor),
        ],
      ),
    );
  }

  Widget _buildAcceptModal(Color cardColor, Color borderColor, Color textColor) {
    return GestureDetector(
      onTap: () => setState(() => _showAcceptModal = false),
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping inside
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Accept Bid',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _showAcceptModal = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Highest Bid: £${_highestBid['amount']}',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bidder: ${_highestBid['bidder']}',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  if (_auction['reservePrice'] != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Reserve Price: £${_auction['reservePrice']}',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Text(
                    'An invoice will be automatically sent to the buyer. They have 24 hours to complete payment.',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(AppColors.grayMedium),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleAcceptBid,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Accept Bid',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelModal(Color cardColor, Color borderColor, Color textColor) {
    return GestureDetector(
      onTap: () => setState(() => _showCancelModal = false),
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping inside
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cancel Auction',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _showCancelModal = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Are you sure you want to cancel this auction? This action cannot be undone.',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _handleCancelAuction,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel Auction',
                        style: TextStyle(color: Color(AppColors.black), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getTimeRemaining() {
    if (_auction['status'] != 'active') return 'Auction Ended';
    final endDate = _auction['endDate'] as DateTime;
    final now = DateTime.now();
    final diff = endDate.difference(now);
    if (diff.isNegative) return 'Auction Ended';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    return '${days}d ${hours}h ${minutes}m';
  }

  void _handleAcceptBid() {
    final highestBid = _highestBid;
    final reservePrice = _auction['reservePrice'] as int?;

    if (reservePrice != null && (highestBid['amount'] as int) < reservePrice) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reserve Not Met'),
          content: Text(
            'The highest bid (£${highestBid['amount']}) does not meet the reserve price (£$reservePrice).',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Bid'),
        content: Text(
          'Accept the highest bid of £${highestBid['amount']} from ${highestBid['bidder']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _showAcceptModal = false;
                _auction['status'] = 'ended';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Invoice has been sent to ${highestBid['bidder']}. Buyer has 24 hours to pay.',
                  ),
                ),
              );
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _handleCancelAuction() {
    if ((_auction['bids'] as List).isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cannot Cancel'),
          content: const Text('This auction cannot be cancelled because bids have been placed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Auction'),
        content: const Text('Are you sure you want to cancel this auction? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _auction['status'] = 'cancelled';
              });
              Navigator.pop(context);
              setState(() {
                _showCancelModal = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Auction has been cancelled successfully.')),
              );
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
