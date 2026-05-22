import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/analytics_service.dart';
import '../../shared/widgets/colony_card.dart';
import '../../shared/widgets/colony_dialog.dart';
import '../../shared/widgets/colony_gradient_background.dart';

/// Settings Screen
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _radarEnabled = true;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('settings');
  }

  @override
  Widget build(BuildContext context) {
    return ColonyGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Account Section
            _buildSectionTitle('Account'),
            ColonyCard(
              margin: const EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildTile(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildTile(
                    icon: Icons.lock_outline,
                    title: 'Privacy',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildTile(
                    icon: Icons.security,
                    title: 'Security',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildTile(
                    icon: Icons.workspace_premium_outlined,
                    title: 'Premium',
                    subtitle: 'Upgrade for more features',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.colonyAmber, AppColors.colonyRed],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('PRO',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                          )),
                      ),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Preferences Section
            _buildSectionTitle('Preferences'),
            ColonyCard(
              margin: const EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildSwitchTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    value: _notificationsEnabled,
                    onChanged: (val) =>
                        setState(() => _notificationsEnabled = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    value: _locationEnabled,
                    onChanged: (val) =>
                        setState(() => _locationEnabled = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.radar,
                    title: 'Radar',
                    value: _radarEnabled,
                    onChanged: (val) => setState(() => _radarEnabled = val),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.fingerprint,
                    title: 'Biometric Lock',
                    value: _biometricEnabled,
                    onChanged: (val) =>
                        setState(() => _biometricEnabled = val),
                  ),
                ],
              ),
            ),

            // Support Section
            _buildSectionTitle('Support'),
            ColonyCard(
              margin: const EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildTile(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildTile(
                    icon: Icons.flag_outlined,
                    title: 'Report a Problem',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildTile(
                    icon: Icons.star_outline,
                    title: 'Rate Colony',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildTile(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Danger Zone
            ColonyCard(
              margin: const EdgeInsets.only(bottom: 32),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    titleColor: AppColors.colonyAmber,
                    onTap: () => _showLogoutDialog(),
                  ),
                  _buildDivider(),
                  _buildTile(
                    icon: Icons.delete_outline,
                    title: 'Delete Account',
                    titleColor: AppColors.error,
                    onTap: () => _showDeleteDialog(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: AppTypography.titleMedium),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.textSecondary),
      title: Text(title,
          style: AppTypography.bodyLarge.copyWith(
            color: titleColor ?? AppColors.textPrimary,
          )),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ))
          : null,
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.textSecondary),
      title: Text(title, style: AppTypography.bodyLarge),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56);
  }

  void _showLogoutDialog() {
    ColonyDialog.confirm(
      context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        AnalyticsService.trackEvent('logout');
        Navigator.pushReplacementNamed(context, '/auth');
      }
    });
  }

  void _showDeleteDialog() {
    ColonyDialog.confirm(
      context,
      title: 'Delete Account',
      message:
          'This action is permanent. All your data will be deleted.',
      confirmText: 'Delete',
    ).then((confirmed) {
      if (confirmed == true) {
        AnalyticsService.trackEvent('delete_account');
      }
    });
  }
}
