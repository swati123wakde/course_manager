import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../localization/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/connectivity_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            children: [
              const SizedBox(height: 20),
              Text(
                localizations.translate(AppStrings.settings),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 24),
              Card(
                child: Column(
                  children: [
                    Consumer<LanguageProvider>(
                      builder: (context, languageProvider, child) {
                        return ListTile(
                          leading: const Icon(Icons.language, color: AppColors.primaryRed),
                          title: Text(localizations.translate(AppStrings.language)),
                          subtitle: Text(languageProvider.getLanguageName(languageProvider.locale.languageCode)),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => _showLanguageDialog(context, languageProvider),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    Consumer<ConnectivityProvider>(
                      builder: (context, connectivity, child) {
                        return ListTile(
                          leading: Icon(connectivity.isOnline ? Icons.wifi : Icons.wifi_off, color: connectivity.isOnline ? AppColors.success : AppColors.error),
                          title: const Text('Network Status'),
                          subtitle: Text(connectivity.isOnline ? 'Online' : 'Offline'),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline, color: AppColors.primaryRed),
                      title: Text(localizations.translate(AppStrings.about)),
                      onTap: () => _showAboutDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.code, color: AppColors.primaryRed),
                      title: Text(localizations.translate(AppStrings.version)),
                      subtitle: const Text('1.0.0'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(
                value: 'en',
                groupValue: provider.locale.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    provider.changeLanguage(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('हिन्दी (Hindi)'),
              leading: Radio<String>(
                value: 'hi',
                groupValue: provider.locale.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    provider.changeLanguage(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.school, size: 48, color: AppColors.primaryRed),
      children: [
        const Text('A professional course management app with offline support.'),
      ],
    );
  }
}