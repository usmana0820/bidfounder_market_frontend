import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../widgets/app_scaffold.dart';

/// Shipping Track Screen - Track order status and shipping information
class ShippingTrackScreen extends StatefulWidget {
  const ShippingTrackScreen({super.key});

  @override
  State<ShippingTrackScreen> createState() => _ShippingTrackScreenState();
}

class _ShippingTrackScreenState extends State<ShippingTrackScreen> {
  // Mock orders - In real app, this would come from a store/service
  final List<Map<String, dynamic>> _orders = [
    {
      'orderId': 'ORD-2024-001',
      'productTitle': 'iPhone 15 Pro',
      'productImage': 'assets/images/Electronics.jpg',
      'orderDate': DateTime.now().subtract(const Duration(days: 5)),
      'status': 'shipped',
      'trackingNumber': 'TRK123456789',
      'estimatedDelivery': DateTime.now().add(const Duration(days: 2)),
      'currentLocation': 'Lahore Distribution Center',
      'price': '£999.00',
    },
    {
      'orderId': 'ORD-2024-002',
      'productTitle': 'Designer Watch',
      'productImage': 'assets/images/Fashion.jpg',
      'orderDate': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'in_transit',
      'trackingNumber': 'TRK987654321',
      'estimatedDelivery': DateTime.now().add(const Duration(days: 5)),
      'currentLocation': 'Karachi Sorting Facility',
      'price': '£299.00',
    },
    {
      'orderId': 'ORD-2024-003',
      'productTitle': 'Garden Tools Set',
      'productImage': 'assets/images/Home & Garden.jpg',
      'orderDate': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'delivered',
      'trackingNumber': 'TRK456789123',
      'estimatedDelivery': DateTime.now().subtract(const Duration(days: 1)),
      'currentLocation': 'Delivered',
      'price': '£149.00',
    },
  ];

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
    final backgroundColor = isDark
        ? const Color(AppColors.darkBackground)
        : const Color(AppColors.background);

    return AppScaffold(
      title: 'Track Orders',
      showBackButton: true,
      showCart: false,
      showBottomNav: false,
      body: _orders.isEmpty
          ? _buildEmptyState(textColor)
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(
                  _orders[index],
                  cardColor,
                  borderColor,
                  textColor,
                  backgroundColor,
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            size: 64,
            color: Color(AppColors.grayMedium),
          ),
          const SizedBox(height: 20),
          Text(
            'No orders to track',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your order tracking information will appear here',
            style: TextStyle(
              fontSize: 16,
              color: const Color(AppColors.grayMedium),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    Map<String, dynamic> order,
    Color cardColor,
    Color borderColor,
    Color textColor,
    Color backgroundColor,
  ) {
    final status = order['status'] as String;
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
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
          // Order Header
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  order['productImage'] as String,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: const Color(AppColors.grayLight),
                      child: const Icon(Icons.image),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['productTitle'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['orderId'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(AppColors.grayMedium),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tracking Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_shipping,
                      size: 16,
                      color: Color(AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tracking Number',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(AppColors.grayMedium),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  order['trackingNumber'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Color(AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order['currentLocation'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Color(AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Est. Delivery: ${_formatDate(order['estimatedDelivery'] as DateTime)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(AppColors.grayMedium),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Order Date and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ordered: ${_formatDate(order['orderDate'] as DateTime)}',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(AppColors.grayMedium),
                ),
              ),
              Text(
                order['price'] as String,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return const Color(AppColors.success);
      case 'shipped':
        return const Color(AppColors.primary);
      case 'in_transit':
        return Colors.orange;
      case 'pending':
        return Colors.grey;
      default:
        return const Color(AppColors.grayMedium);
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'delivered':
        return 'Delivered';
      case 'shipped':
        return 'Shipped';
      case 'in_transit':
        return 'In Transit';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }
}

