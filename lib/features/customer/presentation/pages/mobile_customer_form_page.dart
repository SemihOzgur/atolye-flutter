import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/field_error_resolver.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/phone_normalizer.dart';
import '../../data/customer_repository.dart';
import '../../data/dto/create_customer_request_dto.dart';
import '../cubit/customer_form_cubit.dart';
import '../cubit/customer_form_state.dart';
import '../cubit/iys_verification_cubit.dart';
import '../widgets/iys_verification_panel.dart';

/// Mobil müşteri ekleme formu — masaüstü [CustomerFormPage] ile aynı
/// [CustomerFormCubit]/[ICustomerRepository]/[CreateCustomerRequestDto]'yu
/// paylaşır; yalnızca oluşturma modu (düzenleme kapsam dışı). Alan hataları
/// masaüstünün ham map erişimi yerine [FieldErrorResolver] ile bağlanır
/// (mobile_work_order_form_page.dart'taki desenle tutarlı).
class MobileCustomerFormPage extends StatelessWidget {
  const MobileCustomerFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerFormCubit>(
      create: (_) => CustomerFormCubit(getIt<ICustomerRepository>()),
      child: const _MobileCustomerFormView(),
    );
  }
}

class _MobileCustomerFormView extends StatefulWidget {
  const _MobileCustomerFormView();

  @override
  State<_MobileCustomerFormView> createState() =>
      _MobileCustomerFormViewState();
}

class _MobileCustomerFormViewState extends State<_MobileCustomerFormView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  String? _phoneError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    setState(() => _phoneError = null);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    late final String normalizedPhone;
    try {
      normalizedPhone = PhoneNormalizer.normalize(_phoneController.text);
    } on FormatException catch (e) {
      setState(() => _phoneError = e.message);
      return;
    }

    final email = _emailController.text.trim().isEmpty
        ? null
        : _emailController.text.trim();
    final address = _addressController.text.trim().isEmpty
        ? null
        : _addressController.text.trim();

    await context.read<CustomerFormCubit>().createCustomer(
          CreateCustomerRequestDto(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phone: normalizedPhone,
            email: email,
            address: address,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Müşteri')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: BlocConsumer<CustomerFormCubit, CustomerFormState>(
          listener: (context, state) {
            final success = state.success;
            if (success == null) {
              return;
            }

            if (success.isDuplicate) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Bu numara zaten kayıtlı: '
                    '${success.customer.firstName} ${success.customer.lastName} '
                    '— bu müşteriyle devam ediliyor.',
                  ),
                ),
              );
              context.go('${AppRoutes.customers}/${success.customer.id}');
            }
          },
          builder: (context, state) {
            final success = state.success;

            if (success != null &&
                !success.isDuplicate &&
                success.requiresIysVerification) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Müşteri kaydedildi',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  BlocProvider<IysVerificationCubit>(
                    create: (_) => IysVerificationCubit(
                      getIt<ICustomerRepository>(),
                      success.customer.id,
                      expiresAt: success.iysCodeExpiresAt,
                    ),
                    child: IysVerificationPanel(
                      onDone: () => context.go(
                        '${AppRoutes.customers}/${success.customer.id}',
                      ),
                    ),
                  ),
                ],
              );
            }

            final isSubmitting =
                state.status == CustomerFormStatus.submitting;
            final fieldErrors = FieldErrorResolver(state.fieldErrors);

            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    enabled: !isSubmitting,
                    decoration: InputDecoration(
                      labelText: 'Ad',
                      errorText: fieldErrors.errorFor('firstName'),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Ad zorunludur'
                            : null,
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  TextFormField(
                    controller: _lastNameController,
                    enabled: !isSubmitting,
                    decoration: InputDecoration(
                      labelText: 'Soyad',
                      errorText: fieldErrors.errorFor('lastName'),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Soyad zorunludur'
                            : null,
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  TextFormField(
                    controller: _phoneController,
                    enabled: !isSubmitting,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Telefon',
                      hintText: '05XX XXX XX XX',
                      errorText: _phoneError ?? fieldErrors.errorFor('phone'),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Telefon zorunludur'
                            : null,
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  TextFormField(
                    controller: _emailController,
                    enabled: !isSubmitting,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-posta (opsiyonel)',
                      errorText: fieldErrors.errorFor('email'),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  TextFormField(
                    controller: _addressController,
                    enabled: !isSubmitting,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Adres (opsiyonel)',
                    ),
                  ),
                  if (state.status == CustomerFormStatus.failure &&
                      state.errorMessage != null) ...[
                    const SizedBox(height: AppDimensions.spaceM),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.spaceM),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: AppDecorations.borderRadiusL,
                      ),
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimensions.spaceL),
                  SizedBox(
                    width: double.infinity,
                    height: AppDimensions.buttonHeight,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : () => _submit(context),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.onPrimary,
                              ),
                            )
                          : const Text('Kaydet'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
