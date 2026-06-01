import 'package:app/features/home/giving/cubit/payment_resource_cubit.dart';
import 'package:app/features/home/giving/cubit/payment_type_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/payment/prf_payment.dart';
import 'package:app/models/remote/payment/prf_payment_type.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/helpers/url_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

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
    context.read<PaymentTypeResourceCubit>().loadAll();
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
              child:
                  BlocBuilder<
                    PaymentTypeResourceCubit,
                    ResourceState<PRFPaymentType>
                  >(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () => const SizedBox.shrink(),
                        listLoading: (_) =>
                            const Center(child: PRFLinearProgressIndicator()),
                        listLoaded: (classes, _, _) =>
                            PRFSearchableList<PRFPaymentType>(
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
            BlocConsumer<PaymentResourceCubit, ResourceState<PRFPayment>>(
              listenWhen: (prev, curr) =>
                  curr is ResourceListLoaded<PRFPayment> ||
                  curr is ResourceError<PRFPayment>,
              listener: (context, state) {
                switch (state) {
                  case ResourceListLoaded<PRFPayment>(:final items):
                    if (!_isLoading) break;
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.success();
                    Navigator.of(context).pop();
                    final paymentWithAuthorization = items
                        .where((payment) => payment.authorizationUrl != null)
                        .cast<PRFPayment?>()
                        .firstWhere(
                          (payment) => payment != null,
                          orElse: () => null,
                        );
                    if (paymentWithAuthorization?.authorizationUrl != null) {
                      UrlHelper.openUrl(
                        Uri.parse(paymentWithAuthorization!.authorizationUrl!),
                      );
                    }
                  case ResourceError<PRFPayment>(:final message):
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.error();
                    PRFSnackbar.error(context, message);
                  default:
                    break;
                }
              },
              buildWhen: (prev, curr) =>
                  curr is ResourceMutating<PRFPayment> ||
                  curr is ResourceError<PRFPayment>,
              builder: (context, state) {
                return PRFPrimaryButton(
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

                    setState(() {
                      _isLoading = true;
                    });

                    await context.read<PaymentResourceCubit>().addPayment(
                      paymentTypeUlid: selectedPaymentType!.ulid,
                      amount: int.parse(_amountController.text.trim()),
                    );
                  },
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
