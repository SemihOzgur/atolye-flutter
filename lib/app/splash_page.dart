import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_dimensions.dart';
import '../core/widgets/app_logo_mark.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

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
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spaceXl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLogoMark(size: 180),
                    const SizedBox(height: AppDimensions.spaceL),
                    Text(
                      'DoTiKa',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    Text(
                      'Güvenli oturum ve uygulama kabuğu hazırlanıyor.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spaceXl),
                    const LinearProgressIndicator(minHeight: 4),
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