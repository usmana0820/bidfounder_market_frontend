import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../navigation/app_router.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/faq_accordion.dart';

/// Account Settings Screen - Professional settings interface
class AccountSettingsScreen extends StatelessWidget {
  // FAQ Items
  static final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'How do I create an account?',
      answer:
          'To create an account, click on the "Sign Up" button and follow the registration process. You will need to provide your phone number, verify it with an OTP, and set a password.',
    ),
    FAQItem(
      question: 'How do I list a product?',
      answer:
          'To list a product, go to the "Sell" tab, select a category and subcategory, then fill in the product details including title, description, price, images, and other relevant information.',
    ),
    FAQItem(
      question: 'How does bidding work?',
      answer:
          'Bidding allows buyers to place bids on products. The highest bid wins when the auction ends. You can also enable auto-bid to automatically increase your bid up to a maximum amount.',
    ),
    FAQItem(
      question: 'How do I contact a seller?',
      answer:
          'You can contact a seller by clicking the "Chat with Seller" button on any product detail page. This will open a chat where you can discuss the product.',
    ),
    FAQItem(
      question: 'What payment methods are accepted?',
      answer:
          'We accept various payment methods including credit cards, debit cards, and digital wallets. Payment options are displayed during checkout.',
    ),
    FAQItem(
      question: 'How do I track my orders?',
      answer:
          'You can track your orders in the "My Ads" section if you are a seller, or in your account dashboard. Order status updates will be sent via notifications.',
    ),
  ];

  const AccountSettingsScreen({super.key});

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
    final primaryColor = const Color(AppColors.primary);
    final backgroundColor = isDark
        ? const Color(AppColors.darkBackground)
        : const Color(AppColors.background);

    return AppScaffold(
      title: AppStrings.accountSettings,
      showBackButton: true, // Show back arrow on other screens
      showCart: false,
      showBottomNav: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Settings Sections
            _buildSettingsSection(
              context: context,
              title: 'Account',
              icon: Icons.person_outline_rounded,
              iconColor: primaryColor,
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
              backgroundColor: backgroundColor,
              children: [
                _buildSettingsTile(
                  context: context,
                  icon: Icons.person_rounded,
                  title: AppStrings.profileSettings,
                  subtitle: 'Manage your profile information',
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.profile);
                  },
                  textColor: textColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
                _buildDivider(borderColor),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.location_on_outlined,
                  title: 'Address Book',
                  subtitle: 'Manage your delivery addresses',
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.addressBook);
                  },
                  textColor: textColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
                _buildDivider(borderColor),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.lock_outline_rounded,
                  title: AppStrings.security,
                  subtitle: 'Change password and security settings',
                  onTap: () {
                    _showSecuritySettings(context);
                  },
                  textColor: textColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Preferences Section
            _buildSettingsSection(
              context: context,
              title: 'Preferences',
              icon: Icons.tune_rounded,
              iconColor: Colors.orange,
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
              backgroundColor: backgroundColor,
              children: [
                _buildSettingsTile(
                  context: context,
                  icon: Icons.notifications_outlined,
                  title: AppStrings.notifications,
                  subtitle: 'Manage notification preferences',
                  onTap: () {
                    _showNotificationSettings(context);
                  },
                  textColor: textColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
                _buildDivider(borderColor),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.language_rounded,
                  title: 'Language & Region',
                  subtitle: 'Change language and region settings',
                  onTap: () {
                    _showLanguageSettings(context);
                  },
                  textColor: textColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Help & Support Section
            _buildSettingsSection(
              context: context,
              title: AppStrings.helpAndSupport,
              icon: Icons.help_outline_rounded,
              iconColor: Colors.blue,
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
              backgroundColor: backgroundColor,
              children: [
                _buildActionButton(
                  context: context,
                  icon: Icons.email_outlined,
                  title: AppStrings.contactUs,
                  subtitle: 'Get in touch with our support team',
                  onTap: () {
                    _showContactDialog(context);
                  },
                  textColor: textColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                  cardColor: cardColor,
                ),
                const SizedBox(height: 10),
                _buildActionButton(
                  context: context,
                  icon: Icons.report_problem_outlined,
                  title: AppStrings.reportIssue,
                  subtitle: 'Report a bug or issue',
                  onTap: () {
                    _showReportDialog(context);
                  },
                  textColor: textColor,
                  borderColor: borderColor,
                  primaryColor: primaryColor,
                  cardColor: cardColor,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // FAQ Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.help_center_rounded,
                          color: Colors.purple,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.faq,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Frequently asked questions',
                              style: TextStyle(
                                fontSize: 14,
                                color: textColor.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ..._faqItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: FAQAccordion(item: item),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color textColor,
    required Color borderColor,
    required Color primaryColor,
    required Color cardColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: primaryColor),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: textColor.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: textColor.withValues(alpha: 0.7)),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(
            color: textColor.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(AppColors.primary),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(Color borderColor) {
    return Divider(
      color: borderColor,
      thickness: 0.5,
      height: 1,
      indent: 20,
      endIndent: 20,
    );
  }

  Widget _buildSettingsSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color backgroundColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color textColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: primaryColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: textColor.withValues(alpha: 0.7),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: textColor.withValues(alpha: 0.5),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  void _showContactDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.email, color: Color(AppColors.primary)),
            const SizedBox(width: 12),
            Text(
              AppStrings.contactUs,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in touch with our support team:',
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 15),
            _buildContactInfo(
              icon: Icons.email,
              label: 'Email',
              value: 'support@bidfounder.com',
              textColor: textColor,
            ),
            const SizedBox(height: 10),
            _buildContactInfo(
              icon: Icons.phone,
              label: 'Phone',
              value: '+92 300 1234567',
              textColor: textColor,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSettings(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language & Region',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('English'),
              trailing: const Icon(Icons.check, color: Color(AppColors.primary)),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('اردو'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Language change coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.notifications,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text('Push Notifications'),
              trailing: Switch(value: true, onChanged: (val) {}),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email Notifications'),
              trailing: Switch(value: true, onChanged: (val) {}),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.report_problem, color: Color(AppColors.error)),
            const SizedBox(width: 12),
            Text(
              AppStrings.reportIssue,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        content: Text(
          'Report an issue at support@bidfounder.com\n\nWe\'ll get back to you within 24 hours.',
          style: TextStyle(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSecuritySettings(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(AppColors.darkCard)
        : const Color(AppColors.white);
    final textColor = isDark
        ? const Color(AppColors.darkText)
        : const Color(AppColors.black);

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.security,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Change password feature coming soon')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text('Biometric Authentication'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Biometric authentication coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
