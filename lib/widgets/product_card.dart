import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../navigation/app_router.dart';
import '../store/cart_store.dart';

/// Product Card Widget - Displays product in grid
class ProductCard extends StatelessWidget {
  final Product product;
  final double width;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.width,
    this.onTap,
  });

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

    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.pushNamed(
              context,
              AppRouter.productDetail,
              arguments: {
                'productId': product.id,
                'title': product.title,
                'price': product.price,
                'image': product.image,
                'category': product.category,
                'location': product.location,
                'startBid': product.startBid ?? product.price,
                'currentBid': product.currentBid ?? product.price,
                'bidCount': product.bidCount ?? '0',
                'sellerId': product.sellerId ?? '1',
                'sellerName': product.sellerName ?? 'Seller Name',
              },
            );
          },
      child: Container(
        width: width,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    _getImagePath(product.image),
                    width: width,
                    height: width * 0.7, // Reduced height to fit better
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: width,
                        height: width * 0.7,
                        color: const Color(AppColors.grayLight),
                        child: const Icon(Icons.image, size: 50),
                      );
                    },
                  ),
                ),
                // Add to Cart Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<CartStore>(
                    builder: (context, cartStore, child) {
                      return GestureDetector(
                        onTap: () {
                          cartStore.addToCart(
                            CartItem.fromProduct(product),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.title} added to cart'),
                              backgroundColor: const Color(AppColors.success),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(AppColors.primary),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.shopping_cart,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Product Info
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.price,
                      style: TextStyle(
                        fontSize: 16,
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
                        Flexible(
                          child: Text(
                            product.location,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(AppColors.secondary),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getImagePath(dynamic image) {
    if (image is String) {
      return image;
    }
    // Default to electronics image if not provided
    return 'assets/images/Electronics.jpg';
  }
}

