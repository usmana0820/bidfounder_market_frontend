import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../models/cart_item_model.dart';
import '../../../navigation/app_router.dart';
import '../../../store/cart_store.dart';
import '../../../widgets/app_scaffold.dart';

/// Product Detail Screen - Shows product details, images, bid information
class ProductDetailScreen extends StatefulWidget {
  final String? productId;
  final String? title;
  final String? price;
  final dynamic image;
  final String? category;
  final String? location;
  final String? startBid;
  final String? currentBid;
  final String? bidCount;
  final String? sellerId;
  final String? sellerName;

  const ProductDetailScreen({
    super.key,
    this.productId,
    this.title,
    this.price,
    this.image,
    this.category,
    this.location,
    this.startBid,
    this.currentBid,
    this.bidCount,
    this.sellerId,
    this.sellerName,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;
  bool _showBidHistory = false;

  final List<String> _productImages = [
    'assets/images/Electronics.jpg',
    'assets/images/Fashion.jpg',
    'assets/images/Home & Garden.jpg',
    'assets/images/Vehicles.jpg',
    'assets/images/Sports & Outdoors.jpg',
  ];

  // Mock bidding history
  final List<Map<String, dynamic>> _biddingHistory = [
    {
      'bidderName': 'John Doe',
      'bidAmount': 950,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isCurrent': false,
    },
    {
      'bidderName': 'Jane Smith',
      'bidAmount': 980,
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'isCurrent': false,
    },
    {
      'bidderName': 'You',
      'bidAmount': 1000,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'isCurrent': true,
    },
    {
      'bidderName': 'Bob Johnson',
      'bidAmount': 1050,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'isCurrent': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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

    final productTitle = widget.title ?? 'Product Title';
    final currentBid = widget.currentBid ?? widget.price ?? '£0';
    final startBid = widget.startBid ?? widget.price ?? '£0';
    final bidCount = int.tryParse(widget.bidCount ?? '0') ?? 0;
    final sellerName = widget.sellerName ?? 'Seller';
    final productCategory = widget.category ?? '';
    final productLocation = widget.location ?? '';

    return AppScaffold(
      title: productTitle,
      showBackButton: true,
      showCart: false,
      showBottomNav: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
                  // Product Images Carousel
                  SizedBox(
                    width: screenWidth,
                    height: screenWidth * 0.75,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _imagePageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemCount: _productImages.length,
                          itemBuilder: (context, index) {
                            return Image.asset(
                              _productImages[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(AppColors.grayLight),
                                  child: const Icon(Icons.image, size: 50),
                                );
                              },
                            );
                          },
                        ),
                        // Page Indicators
                        Positioned(
                          bottom: 15,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_productImages.length, (index) {
                              return Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentImageIndex == index
                                      ? const Color(AppColors.primary)
                                      : Colors.white.withValues(alpha: 0.5),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Product Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Title with Add to Cart button parallel
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                productTitle,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Consumer<CartStore>(
                              builder: (context, cartStore, child) {
                                final isInCart = cartStore.items
                                    .any((item) => item.productId == widget.productId);
                                return IconButton(
                                  onPressed: isInCart ? null : _handleAddToCart,
                                  icon: Icon(
                                    isInCart ? Icons.check_circle : Icons.shopping_cart_outlined,
                                    color: isInCart
                                        ? const Color(AppColors.success)
                                        : const Color(AppColors.primary),
                                    size: 28,
                                  ),
                                  tooltip: isInCart ? 'Added to Cart' : 'Add to Cart',
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Price Row
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
                                  currentBid,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.gavel,
                                  size: 16,
                                  color: Color(AppColors.primary),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$bidCount bids',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Bid Range
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      'Starting Bid',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(AppColors.grayMedium),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      startBid,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: borderColor,
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      'Current Bid',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(AppColors.grayMedium),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      currentBid,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(AppColors.primary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Product Details
                        Column(
                          children: [
                            _buildDetailRow(
                              'Category',
                              productCategory,
                              borderColor,
                              textColor,
                            ),
                            _buildDetailRow(
                              'Location',
                              productLocation,
                              borderColor,
                              textColor,
                              showIcon: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Seller',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(AppColors.grayMedium),
                                    ),
                                  ),
                                  Text(
                                    sellerName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Bidding History Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Bidding History',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _showBidHistory = !_showBidHistory;
                                      });
                                    },
                                    icon: Icon(
                                      _showBidHistory
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: 18,
                                      color: const Color(AppColors.primary),
                                    ),
                                    label: Text(
                                      _showBidHistory ? 'Hide' : 'Show All',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(AppColors.primary),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Bidding Range Progress
                              _buildBiddingProgress(
                                startBid: startBid,
                                currentBid: currentBid,
                                textColor: textColor,
                                borderColor: borderColor,
                              ),
                              const SizedBox(height: 16),
                              // Recent Bids
                              if (_showBidHistory)
                                ..._biddingHistory.take(3).map((bid) {
                                  return _buildBidItem(
                                    bid,
                                    textColor: textColor,
                                    borderColor: borderColor,
                                  );
                                })
                              else
                                _buildBidItem(
                                  _biddingHistory.first,
                                  textColor: textColor,
                                  borderColor: borderColor,
                                ),
                              const SizedBox(height: 16),
                              // Bid Now and Buy Now Buttons inside the card
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _handleBidNow,
                                      icon: const Icon(
                                        Icons.gavel,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Bid Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(AppColors.primary),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _handleBuyNow,
                                      icon: const Icon(
                                        Icons.shopping_bag,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Buy Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(AppColors.success),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'This is a high-quality product in excellent condition. Perfect for your needs. All items are carefully inspected and verified before listing.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Chat with Seller Button at the end of scrollable content
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
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
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _handleChatWithSeller,
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Chat with Seller',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  Widget _buildBiddingProgress({
    required String startBid,
    required String currentBid,
    required Color textColor,
    required Color borderColor,
  }) {
    final startAmount = _parsePrice(startBid);
    final currentAmount = _parsePrice(currentBid);
    final maxAmount = currentAmount * 1.5; // Estimated max for progress
    final progress = ((currentAmount - startAmount) / (maxAmount - startAmount)).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Starting Bid',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(AppColors.grayMedium),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  startBid,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Current Bid',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(AppColors.grayMedium),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentBid,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(AppColors.primary),
                      Color(AppColors.accent),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBidItem(
    Map<String, dynamic> bid, {
    required Color textColor,
    required Color borderColor,
  }) {
    final isCurrent = bid['isCurrent'] as bool;
    final bidderName = bid['bidderName'] as String;
    final bidAmount = bid['bidAmount'] as int;
    final timestamp = bid['timestamp'] as DateTime;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent
            ? const Color(AppColors.primary).withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isCurrent
            ? Border.all(
                color: const Color(AppColors.primary),
                width: 1.5,
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: isCurrent
                    ? const Color(AppColors.primary)
                    : const Color(AppColors.grayMedium),
                child: Text(
                  bidderName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        bidderName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(AppColors.primary),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'You',
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
                  const SizedBox(height: 2),
                  Text(
                    _formatTimestamp(timestamp),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(AppColors.grayMedium),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '£${bidAmount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCurrent
                  ? const Color(AppColors.primary)
                  : textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    Color borderColor,
    Color textColor, {
    bool showIcon = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(AppColors.grayMedium),
            ),
          ),
          if (showIcon)
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: Color(AppColors.grayMedium),
                ),
                const SizedBox(width: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            )
          else
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays > 0) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _handleAddToCart() {
    final cartStore = Provider.of<CartStore>(context, listen: false);
    final productImage = widget.image is String
        ? widget.image as String
        : _productImages[0];

    cartStore.addToCart(
      CartItem(
        id: 'cart-${DateTime.now().millisecondsSinceEpoch}-${widget.productId}',
        productId: widget.productId ?? '',
        title: widget.title ?? 'Product',
        price: widget.currentBid ?? widget.price ?? '£0',
        image: productImage,
        category: widget.category ?? '',
        location: widget.location ?? '',
        sellerId: widget.sellerId ?? '1',
        sellerName: widget.sellerName ?? 'Seller',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.title} added to cart'),
        backgroundColor: const Color(AppColors.success),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _handleBidNow() {
    final currentBidAmount = _parsePrice(widget.currentBid ?? widget.price ?? '£0');
    final minBidAmount = currentBidAmount + 10; // Minimum increment

    showDialog(
      context: context,
      builder: (context) {
        final bidController = TextEditingController(
          text: minBidAmount.toStringAsFixed(0),
        );
        return AlertDialog(
          title: const Text('Place a Bid'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Bid: ${widget.currentBid ?? widget.price ?? '£0'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(AppColors.grayMedium),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Minimum Bid: £${minBidAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bidController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Your Bid Amount',
                  prefixText: '£',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final bidAmount = double.tryParse(bidController.text) ?? 0;
                if (bidAmount < minBidAmount) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Bid must be at least £${minBidAmount.toStringAsFixed(0)}',
                      ),
                      backgroundColor: const Color(AppColors.error),
                    ),
                  );
                  return;
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bid of £${bidAmount.toStringAsFixed(0)} placed successfully'),
                    backgroundColor: const Color(AppColors.success),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(AppColors.primary),
              ),
              child: const Text('Place Bid'),
            ),
          ],
        );
      },
    );
  }

  void _handleBuyNow() {
    Navigator.pushNamed(
      context,
      AppRouter.paymentGateway,
      arguments: {
        'productId': widget.productId,
        'productTitle': widget.title,
        'amount': widget.currentBid ?? widget.price ?? '£0',
        'sellerId': widget.sellerId,
        'sellerName': widget.sellerName,
      },
    );
  }

  void _handleChatWithSeller() {
    Navigator.pushNamed(
      context,
      AppRouter.chatDetail,
      arguments: {
        'userId': widget.sellerId ?? '1',
        'userName': widget.sellerName ?? 'Seller',
        'productId': widget.productId ?? '',
        'productTitle': widget.title ?? 'Product',
      },
    );
  }

  double _parsePrice(String price) {
    final cleanPrice = price.replaceAll(RegExp(r'[£,\s]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }
}
