import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_startup_controller.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_logo_mark.dart';
import '../../data/auth_repository.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.startupController});

  final AppStartupController startupController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(getIt<IAuthRepository>(), startupController),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  Timer? _countdownTimer;
  int? _countdownSeconds;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown(int seconds) {
    _countdownTimer?.cancel();
    setState(() => _countdownSeconds = seconds);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final remaining = (_countdownSeconds ?? 1) - 1;
      if (remaining <= 0) {
        timer.cancel();
        setState(() => _countdownSeconds = null);
      } else {
        setState(() => _countdownSeconds = remaining);
      }
    });
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.read<AuthCubit>().login(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

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
                child: BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state.status == AuthFormStatus.rateLimited &&
                        state.retryAfterSeconds != null) {
                      _startCountdown(state.retryAfterSeconds!);
                    }
                  },
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isSubmitting =
                          state.status == AuthFormStatus.submitting;
                      final isRateLimited = _countdownSeconds != null;
                      final showError = state.status ==
                              AuthFormStatus.failure ||
                          (state.status == AuthFormStatus.rateLimited &&
                              isRateLimited);
                      final errorText =
                          state.status == AuthFormStatus.rateLimited
                              ? '${state.errorMessage} ($_countdownSeconds sn)'
                              : state.errorMessage;

                      return Form(
                        key: _formKey,
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
                              'DoTiKa admin paneline giriş yapın.',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: AppDimensions.spaceXl),
                            TextFormField(
                              controller: _emailController,
                              enabled: !isSubmitting && !isRateLimited,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              decoration: const InputDecoration(
                                labelText: 'E-posta',
                              ),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                      ? 'E-posta zorunludur'
                                      : null,
                            ),
                            const SizedBox(height: AppDimensions.spaceM),
                            TextFormField(
                              controller: _passwordController,
                              enabled: !isSubmitting && !isRateLimited,
                              obscureText: _obscurePassword,
                              autofillHints: const [AutofillHints.password],
                              decoration: InputDecoration(
                                labelText: 'Şifre',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Şifre zorunludur'
                                      : null,
                              onFieldSubmitted: (_) => _submit(context),
                            ),
                            if (showError) ...[
                              const SizedBox(height: AppDimensions.spaceM),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(
                                  AppDimensions.spaceM,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: AppDecorations.borderRadiusL,
                                ),
                                child: Text(
                                  errorText ?? '',
                                  style: const TextStyle(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: AppDimensions.spaceL),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: (isSubmitting || isRateLimited)
                                    ? null
                                    : () => _submit(context),
                                child: isSubmitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.onPrimary,
                                        ),
                                      )
                                    : const Text('Giriş Yap'),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spaceM),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                AppDimensions.spaceM,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: AppDecorations.borderRadiusL,
                              ),
                              child: const Text(
                                'Şifrenizi unuttuysanız sistem yöneticinizle '
                                'iletişime geçin.',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
