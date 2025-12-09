import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../navigation/app_router.dart';
import '../../../store/cart_store.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/button.dart';

/// Cart Screen - Shows all items added to cart
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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

    return Consumer<CartStore>(
      builder: (context, cartStore, child) {
        return AppScaffold(
          title: 'Cart',
          showBackButton: true,
          showCart: false,
          showBottomNav: false,
          rightAction: cartStore.items.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                  onPressed: () => _handleClearCart(context, cartStore),
                  tooltip: 'Clear Cart',
                )
              : null,
          body: Column(
            children: [
              Expanded(
                child: cartStore.items.isEmpty
                    ? _buildEmptyState(context, textColor)
                    : ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: cartStore.items.length,
                        itemBuilder: (context, index) {
                          return _buildCartItem(
                            context,
                            cartStore.items[index],
                            cartStore,
                            cardColor,
                            borderColor,
                            textColor,
                            backgroundColor,
                          );
                        },
                      ),
              ),
              // Bottom Bar with Subtotal
              if (cartStore.items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    border: Border(
                      top: BorderSide(color: borderColor, width: 1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                          Text(
                            '£${cartStore.getTotalPrice().toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        title: 'Proceed to Checkout',
                        onPress: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Checkout functionality will be implemented soon.'),
                            ),
                          );
                        },
                        fullWidth: true,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    dynamic item,
    CartStore cartStore,
    Color cardColor,
    Color borderColor,
    Color textColor,
    Color backgroundColor,
  ) {
    final price = _parsePrice(item.price);
    final itemTotal = price * item.quantity;

    return InkWell(
      onTap: () {
        // Navigate to product detail screen
        Navigator.pushNamed(
          context,
          AppRouter.productDetail,
          arguments: {
            'productId': item.productId,
            'title': item.title,
            'price': item.price,
            'image': item.image,
            'category': item.category,
            'location': item.location,
            'sellerId': item.sellerId,
            'sellerName': item.sellerName,
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                _getImagePath(item.image),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: const Color(AppColors.grayLight),
                    child: const Icon(Icons.image),
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '£${itemTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: Color(AppColors.grayMedium),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(AppColors.grayMedium),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Quantity Controls
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (item.quantity > 1) {
                            cartStore.updateQuantity(item.id, item.quantity - 1);
                          } else {
                            _handleRemoveItem(context, cartStore, item.id, item.title);
                          }
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Icon(
                            Icons.remove,
                            size: 14,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${item.quantity}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          cartStore.updateQuantity(item.id, item.quantity + 1);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Icon(
                            Icons.add,
                            size: 14,
                            color: textColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          _handleRemoveItem(context, cartStore, item.id, item.title);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.delete,
                            size: 16,
                            color: Color(AppColors.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart,
            size: 64,
            color: Color(AppColors.grayMedium),
          ),
          const SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Add items to your cart to see them here',
            style: TextStyle(
              fontSize: 14,
              color: const Color(AppColors.grayMedium),
            ),
          ),
          const SizedBox(height: 30),
          AppButton(
            title: 'Browse Products',
            onPress: () {
              // Simply pop back to dashboard - cart is pushed from dashboard navigator
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                // Fallback: navigate to dashboard if we can't pop
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.dashboard,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }


  String _getImagePath(dynamic image) {
    if (image is String) {
      return image;
    }
    return 'assets/images/Electronics.jpg';
  }

  void _handleClearCart(BuildContext context, CartStore cartStore) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cartStore.clearCart();
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleRemoveItem(BuildContext context, CartStore cartStore, String itemId, String itemTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Remove "$itemTitle" from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cartStore.removeFromCart(itemId);
              Navigator.pop(context);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  double _parsePrice(String price) {
    return double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
  }
}
