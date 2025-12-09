import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../widgets/app_scaffold.dart';

/// Chat Detail Screen - Individual conversation view
class ChatDetailScreen extends StatefulWidget {
  final String? userId;
  final String? userName;
  final String? productId;
  final String? productTitle;

  const ChatDetailScreen({
    super.key,
    this.userId,
    this.userName,
    this.productId,
    this.productTitle,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'text': 'Hello, is this item still available?',
      'senderId': 'other',
      'senderName': 'John Doe',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'isRead': true,
    },
    {
      'id': '2',
      'text': 'Yes, it is still available!',
      'senderId': 'current',
      'senderName': 'You',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 25)),
      'isRead': true,
    },
    {
      'id': '3',
      'text': 'Great! What is your best price?',
      'senderId': 'other',
      'senderName': 'John Doe',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 20)),
      'isRead': true,
    },
    {
      'id': '4',
      'text': 'I can offer £950. Is that acceptable?',
      'senderId': 'current',
      'senderName': 'You',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final userId = args?['userId'] as String? ?? widget.userId ?? '1';
    final userName = args?['userName'] as String? ?? widget.userName ?? 'User';
    final productId = args?['productId'] as String? ?? widget.productId ?? '';
    final productTitle = args?['productTitle'] as String? ?? widget.productTitle ?? 'Product';
    final role = args?['role'] as String? ?? 'buyer';

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
      title: userName,
      showBackButton: true,
      showCart: false,
      showBottomNav: false,
      body: Column(
        children: [
          // Product Info Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                bottom: BorderSide(color: borderColor, width: 1),
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    _getProductImage(productTitle),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
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
                        productTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role == 'buyer'
                            ? 'You are buying this item'
                            : 'You are selling this item',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(AppColors.grayMedium),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(15),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isCurrentUser = message['senderId'] == 'current';

                return Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!isCurrentUser)
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: const AssetImage(
                              'assets/images/chat avatar.jpg',
                            ),
                          ),
                        if (!isCurrentUser) const SizedBox(width: 6),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? const Color(AppColors.primary)
                                  : cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isCurrentUser
                                    ? const Color(AppColors.primary)
                                    : borderColor,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['text'] as String,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isCurrentUser
                                        ? Colors.white
                                        : textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTime(message['timestamp'] as DateTime),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isCurrentUser
                                        ? Colors.white.withValues(alpha: 0.8)
                                        : const Color(AppColors.grayMedium),
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isCurrentUser) const SizedBox(width: 6),
                        if (isCurrentUser)
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: const AssetImage(
                              'assets/images/chat avatar.jpg',
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Message Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                top: BorderSide(color: borderColor, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(
                        color: Color(AppColors.grayPlaceholder),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      filled: true,
                      fillColor: backgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    style: TextStyle(color: textColor, fontSize: 15),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _handleSendMessage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _hasText
                          ? const Color(AppColors.primary)
                          : const Color(AppColors.grayLight),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send,
                      size: 18,
                      color: _hasText
                          ? Colors.white
                          : const Color(AppColors.grayMedium),
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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _hasText = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getProductImage(String? title) {
    if (title == null) return 'assets/images/Electronics.jpg';
    final titleLower = title.toLowerCase();
    if (titleLower.contains('iphone') ||
        titleLower.contains('samsung') ||
        titleLower.contains('phone') ||
        titleLower.contains('galaxy') ||
        titleLower.contains('macbook') ||
        titleLower.contains('laptop') ||
        titleLower.contains('computer')) {
      return 'assets/images/Electronics.jpg';
    }
    if (titleLower.contains('sofa') ||
        titleLower.contains('chair') ||
        titleLower.contains('furniture') ||
        titleLower.contains('fridge') ||
        titleLower.contains('refrigerator')) {
      return 'assets/images/Home & Garden.jpg';
    }
    return 'assets/images/Special Offer.jpg';
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': _messageController.text.trim(),
        'senderId': 'current',
        'senderName': 'You',
        'timestamp': DateTime.now(),
        'isRead': false,
      });
    });

    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
