import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/phone_normalizer.dart';
import '../../data/customer_repository.dart';
import '../../data/dto/create_customer_request_dto.dart';
import '../../data/dto/customer_dto.dart';
import '../../data/dto/update_customer_request_dto.dart';
import '../cubit/customer_form_cubit.dart';
import '../cubit/customer_form_state.dart';
import '../cubit/iys_verification_cubit.dart';
import '../widgets/iys_verification_panel.dart';

class CustomerFormPage extends StatelessWidget {
  const CustomerFormPage({super.key, this.existingCustomer});

  final CustomerDto? existingCustomer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerFormCubit>(
      create: (_) => CustomerFormCubit(getIt<ICustomerRepository>()),
      child: _CustomerFormView(existingCustomer: existingCustomer),
    );
  }
}

class _CustomerFormView extends StatefulWidget {
  const _CustomerFormView({this.existingCustomer});

  final CustomerDto? existingCustomer;

  bool get isEditMode => existingCustomer != null;

  @override
  State<_CustomerFormView> createState() => _CustomerFormViewState();
}

class _CustomerFormViewState extends State<_CustomerFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  String? _phoneError;

  @override
  void initState() {
    super.initState();
    final customer = widget.existingCustomer;
    _firstNameController = TextEditingController(text: customer?.firstName);
    _lastNameController = TextEditingController(text: customer?.lastName);
    _phoneController = TextEditingController(text: customer?.phone);
    _emailController = TextEditingController(text: customer?.email);
    _addressController = TextEditingController(text: customer?.address);
  }

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

    final email =
        _emailController.text.trim().isEmpty ? null : _emailController.text.trim();
    final address = _addressController.text.trim().isEmpty
        ? null
        : _addressController.text.trim();

    final cubit = context.read<CustomerFormCubit>();

    if (widget.isEditMode) {
      final existing = widget.existingCustomer!;
      final phoneChanged = normalizedPhone != existing.phone;

      if (phoneChanged) {
        final confirmed = await _confirmPhoneChange(context);
        if (confirmed != true) {
          return;
        }
      }

      await cubit.updateCustomer(
        existing.id,
        UpdateCustomerRequestDto(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: normalizedPhone,
          email: email,
          address: address,
        ),
        phoneChanged: phoneChanged,
      );
    } else {
      await cubit.createCustomer(
        CreateCustomerRequestDto(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: normalizedPhone,
          email: email,
          address: address,
        ),
      );
    }
  }

  Future<bool?> _confirmPhoneChange(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Telefon değişikliği'),
        content: const Text(
          'Telefon değiştirilirse İYS onayı sıfırlanır, açık iş emirlerinin '
          'takip linkleri yenilenir ve müşteriye yeni SMS gönderilir. '
          'Devam edilsin mi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spaceXl),
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
                } else if (!success.requiresIysVerification) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Müşteri güncellendi.')),
                  );
                  context.go('${AppRoutes.customers}/${success.customer.id}');
                }
              },
              builder: (context, state) {
                final success = state.success;

                if (success != null && success.requiresIysVerification) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.spaceL),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Müşteri kaydedildi',
                            style: Theme.of(context).textTheme.headlineMedium,
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
                      ),
                    ),
                  );
                }

                final isSubmitting = state.status == CustomerFormStatus.submitting;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spaceL),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isEditMode ? 'Müşteri Düzenle' : 'Yeni Müşteri',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppDimensions.spaceL),
                          TextFormField(
                            controller: _firstNameController,
                            enabled: !isSubmitting,
                            decoration: InputDecoration(
                              labelText: 'Ad',
                              errorText: state.fieldErrors['firstName']?.first,
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
                              errorText: state.fieldErrors['lastName']?.first,
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
                              errorText:
                                  _phoneError ?? state.fieldErrors['phone']?.first,
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
                              errorText: state.fieldErrors['email']?.first,
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
                            child: ElevatedButton(
                              onPressed:
                                  isSubmitting ? null : () => _submit(context),
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
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
