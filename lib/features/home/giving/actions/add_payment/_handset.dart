import 'package:app/features/home/giving/cubit/add_payment_cubit.dart';
import 'package:app/features/home/giving/cubit/get_payment_types_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/payment/prf_payment_type.dart';
import 'package:prf_design/prf_design.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';

class AppPaymentHandset extends StatefulWidget {
  const AppPaymentHandset({super.key});

  @override
  State<AppPaymentHandset> createState() => _AppPaymentHandsetState();
}

class _AppPaymentHandsetState extends State<AppPaymentHandset> {
  final _amountController = TextEditingController();
  PRFPaymentType? selectedPaymentType;

  bool _isLoading = false;

  // Structured validation
  bool _showValidation = false;
  String? _amountError;
  String? _paymentTypeError;

  @override
  void initState() {
    super.initState();
    context.read<GetPaymentTypesCubit>().getPaymentTypes();
    _amountController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (_showValidation) {
      _validateForm();
    }
    setState(() {});
  }

  void _clearErrors() {
    _amountError = null;
    _paymentTypeError = null;
  }

  bool _validateForm() {
    _clearErrors();

    if (_amountController.text.trim().isEmpty) {
      _amountError = 'Amount is required';
    }
    if (selectedPaymentType == null) {
      _paymentTypeError = 'Please select a reason for giving';
    }

    setState(() => _showValidation = true);

    return _amountError == null && _paymentTypeError == null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: PRFSpacingTokens.lg),
            PRFFormSection(
              icon: Icons.volunteer_activism_outlined,
              title: l10n.reasonForGiving,
              isRequired: true,
              margin: const EdgeInsets.only(bottom: PRFSpacingTokens.md),
              child: BlocBuilder<GetPaymentTypesCubit, GetPaymentTypesState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const SizedBox.shrink(),
                    loading: () =>
                        const Center(child: LinearProgressIndicator()),
                    loaded: (classes) => PRFSearchableList<PRFPaymentType>(
                      entries: classes
                          .map(
                            (paymentType) =>
                                PRFSearchableListEntry<PRFPaymentType>(
                                  value: paymentType,
                                  label: paymentType.name,
                                ),
                          )
                          .toList(),
                      onSelected: (paymentType) => setState(() {
                        selectedPaymentType = paymentType;
                        if (_showValidation) _validateForm();
                      }),
                      selection: selectedPaymentType,
                      hintText: l10n.reasonForGiving,
                      emptyText: 'No payment types found',
                    ),
                  );
                },
              ),
            ),
            PRFFormSection(
              icon: Icons.attach_money,
              title: l10n.amount,
              isRequired: true,
              margin: const EdgeInsets.only(bottom: PRFSpacingTokens.md),
              child: PRFNumberInput(
                hintText: l10n.enterAmount,
                controller: _amountController,
                errorText: _showValidation ? _amountError : null,
              ),
            ),
            const SizedBox(height: PRFSpacingTokens.xxl),
            BlocConsumer<AddPaymentCubit, AddPaymentState>(
              listener: (context, state) {
                state.mapOrNull(
                  loading: (_) {
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  loaded: (result) async {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.success();
                    Navigator.of(context).pop();
                    if (result.payment.authorizationUrl != null) {
                      await UrlHelper.openUrl(
                        Uri.parse(result.payment.authorizationUrl!),
                      );
                    }
                  },
                  error: (error) {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.error();
                    PRFSnackbar.error(context, error.error);
                  },
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => PRFPrimaryButton(
                    title: _isLoading ? l10n.recording : l10n.record,
                    disabled: _isLoading,
                    isLoading: _isLoading ? true : null,
                    onPressed: () async {
                      if (!_validateForm()) {
                        Gaimon.warning();
                        PRFSnackbar.error(
                          context,
                          'Please fix the highlighted fields and try again.',
                        );
                        return;
                      }

                      await context.read<AddPaymentCubit>().addPayment(
                        amount: _amountController.text.trim(),
                        paymentTypeUlid: selectedPaymentType!.ulid,
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: PRFSpacingTokens.xxl),
            Text(
              l10n.directed,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(),
            ),
          ],
        ),
      ),
    );
  }
}
