import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_logo_mark.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.backgroundGradientMid,
              AppColors.backgroundGradientEnd,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.spaceXl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppLogoMark(size: 140),
                    const SizedBox(height: AppDimensions.spaceL),
                    Text(
                      'Giriş',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    Text(
                      'Auth feature dalinda gercek kimlik dogrulama akisi burada tamamlanacak.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppDimensions.spaceXl),
                    const TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'E-posta',
                        hintText: 'Auth feature bekleniyor',
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceM),
                    const TextField(
                      enabled: false,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Sifre',
                        hintText: 'Auth feature bekleniyor',
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    ElevatedButton(
                      onPressed: null,
                      child: const Text('Giris Yap'),
                    ),
                    const SizedBox(height: AppDimensions.spaceM),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.spaceM),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: AppDecorations.borderRadiusL,
                      ),
                      child: const Text(
                        'Sifrenizi unuttuysaniz sistem yoneticinizle iletisim kurun.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}