import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../navigation/app_router.dart';
import '../../../widgets/app_scaffold.dart';

/// Chat Screen - Chat List View
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _conversations = [
    {
      'id': '1',
      'userId': 'user2',
      'userName': 'John Doe',
      'userImage': 'assets/images/chat avatar.jpg',
      'lastMessage': 'Is the item still available?',
      'lastMessageTime': DateTime.now().subtract(const Duration(minutes: 5)),
      'unreadCount': 2,
      'productId': '1',
      'productTitle': 'iPhone 15 Pro',
      'productImage': 'assets/images/Electronics.jpg',
      'role': 'seller',
    },
    {
      'id': '2',
      'userId': 'user3',
      'userName': 'Jane Smith',
      'userImage': 'assets/images/chat avatar.jpg',
      'lastMessage': 'I can pick it up today if available',
      'lastMessageTime': DateTime.now().subtract(const Duration(minutes: 30)),
      'unreadCount': 0,
      'productId': '3',
      'productTitle': 'Sofa Set',
      'productImage': 'assets/images/Home & Garden.jpg',
      'role': 'buyer',
    },
    {
      'id': '3',
      'userId': 'user4',
      'userName': 'Bob Johnson',
      'userImage': 'assets/images/chat avatar.jpg',
      'lastMessage': 'What is the lowest price you can accept?',
      'lastMessageTime': DateTime.now().subtract(const Duration(hours: 2)),
      'unreadCount': 1,
      'productId': '2',
      'productTitle': 'MacBook Pro',
      'productImage': 'assets/images/Electronics.jpg',
      'role': 'seller',
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

    // Sort by last message time
    final sortedConversations = List<Map<String, dynamic>>.from(_conversations)
      ..sort((a, b) => (b['lastMessageTime'] as DateTime)
          .compareTo(a['lastMessageTime'] as DateTime));

    return AppScaffold(
      title: AppStrings.chat,
      showBackButton: true, // Show back arrow on other screens
      showCart: false,
      showBottomNav: false, // Bottom nav is handled by MainScreen
      currentTabIndex: null,
      body: sortedConversations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Color(AppColors.grayMedium),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.chatDescription,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your conversations with buyers and sellers will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(AppColors.grayMedium),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(15),
              itemCount: sortedConversations.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final conversation = sortedConversations[index];
                final role = conversation['role'] as String;
                final unreadCount = conversation['unreadCount'] as int;

                return GestureDetector(
                  onTap: () => _handleConversationPress(conversation),
                  child: Container(
                    padding: const EdgeInsets.all(12),
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
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            conversation['productImage'] as String,
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
                        // Conversation Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundImage: AssetImage(
                                            conversation['userImage'] as String,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                conversation['userName'] as String,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: textColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Icon(
                                                    role == 'buyer'
                                                        ? Icons.shopping_cart
                                                        : Icons.person,
                                                    size: 10,
                                                    color: role == 'buyer'
                                                        ? const Color(0xFF4CAF50)
                                                        : const Color(AppColors.primary),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    role == 'buyer' ? 'Buying' : 'Selling',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500,
                                                      color: role == 'buyer'
                                                          ? const Color(0xFF4CAF50)
                                                          : const Color(AppColors.primary),
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _formatTime(conversation['lastMessageTime'] as DateTime),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(AppColors.grayMedium),
                                        ),
                                      ),
                                      if (unreadCount > 0) ...[
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          constraints: const BoxConstraints(minWidth: 20),
                                          decoration: BoxDecoration(
                                            color: const Color(AppColors.primary),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '$unreadCount',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                conversation['productTitle'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                conversation['lastMessage'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(AppColors.grayMedium),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    final minutes = diff.inMinutes;
    final hours = diff.inHours;
    final days = diff.inDays;

    if (minutes < 60) return '${minutes}m ago';
    if (hours < 24) return '${hours}h ago';
    if (days < 7) return '${days}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleConversationPress(Map<String, dynamic> conversation) {
    Navigator.pushNamed(
      context,
      AppRouter.chatDetail,
      arguments: {
        'conversationId': conversation['id'],
        'userId': conversation['userId'],
        'userName': conversation['userName'],
        'productId': conversation['productId'],
        'productTitle': conversation['productTitle'],
        'role': conversation['role'],
      },
    );
  }
}
