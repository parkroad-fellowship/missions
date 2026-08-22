import 'package:app/features/missions/mission_details/widgets/expenses/cubit/allocation_entry_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/expense/prf_allocation_entry.dart';
import 'package:app/models/remote/expense/prf_refund_dto.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class AddRefundViewHandset extends StatefulWidget {
  const AddRefundViewHandset({
    required this.accountingEventUlid,
    super.key,
  });

  final String accountingEventUlid;

  @override
  State<AddRefundViewHandset> createState() => _AddRefundViewHandsetState();
}

class _AddRefundViewHandsetState extends State<AddRefundViewHandset> {
  final _amountController = TextEditingController();
  final _confirmationController = TextEditingController();

  bool _isLoading = false;

  // Structured validation
  bool _showValidation = false;
  String? _amountError;
  String? _confirmationError;

  bool get _isFormValid {
    return _amountController.text.isNotEmpty &&
        _confirmationController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onFormChange);
    _confirmationController.addListener(_onFormChange);
  }

  void _onFormChange() {
    if (_showValidation) {
      _validateForm();
    }
    setState(() {});
  }

  void _clearErrors() {
    _amountError = null;
    _confirmationError = null;
  }

  bool _validateForm() {
    _clearErrors();

    if (_amountController.text.trim().isEmpty) {
      _amountError = context.l10n.fieldRequired(context.l10n.amount);
    }
    if (_confirmationController.text.trim().isEmpty) {
      _confirmationError = context.l10n.confirmationMessageRequired;
    }

    setState(() => _showValidation = true);
    return _amountError == null && _confirmationError == null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(
              context,
            ).colorScheme.tertiary.withValues(alpha: PRFOpacities.faint),
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: PRFSpacingTokens.lg),

              // Header Card
              Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.tertiary,
                          Theme.of(
                            context,
                          ).colorScheme.tertiary.withValues(
                            alpha: PRFOpacities.stronger,
                          ),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.tertiary.withValues(
                                alpha: PRFOpacities.glow,
                              ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 32,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        Text(
                          context.l10n.addRefundEntryTitle,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onTertiary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.xs),
                        Text(
                          context.l10n.addRefundEntryDesc,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onTertiary.withValues(
                                      alpha: PRFOpacities.nearOpaque,
                                    ),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .slideY(begin: -0.3)
                  .fadeIn(duration: PRFMotionTokens.enterShort),

              const SizedBox(height: PRFSpacingTokens.xl),

              // Form Card
              Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: PRFOpacities.muted),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.shadow.withValues(
                            alpha: PRFOpacities.subtle,
                          ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    PRFFormSection(
                          icon: Icons.attach_money,
                          title: context.l10n.refundAmount,
                          isRequired: true,
                          child: _buildNumberField(
                            controller: _amountController,
                            label: context.l10n.amount,
                            hint: context.l10n.enterRefundAmount,
                            prefix: 'KES ',
                          ),
                        )
                        .animate(delay: PRFMotionTokens.standard)
                        .slideX(begin: -0.2)
                        .fadeIn(),

                    PRFFormSection(
                          icon: Icons.description,
                          title: context.l10n.confirmationMessage,
                          isRequired: true,
                          child: Column(
                            children: [
                              PRFTextField(
                                type: PRFTextFieldType.textArea,
                                hintText: context.l10n.enterConfirmationHint,
                                controller: _confirmationController,
                                maxLines: 3,
                                textInputAction: TextInputAction.done,
                                errorText: _showValidation
                                    ? _confirmationError
                                    : null,
                              ),
                            ],
                          ),
                        )
                        .animate(delay: PRFMotionTokens.slow)
                        .slideX(begin: -0.2)
                        .fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: PRFSpacingTokens.xl),

              // Submit Button
              BlocConsumer<
                    AllocationEntryResourceCubit,
                    ResourceState<PRFAllocationEntry>
                  >(
                    listener: (context, state) {
                      state.mapOrNull(
                        mutating: (_) {
                          setState(() {
                            _isLoading = true;
                          });
                        },
                        listLoaded: (_) {
                          if (!_isLoading) return;
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.of(context).pop();
                          PRFSnackbar.success(
                            context,
                            context.l10n.refundAddedSuccessfully,
                          );
                        },
                        error: (error) {
                          setState(() {
                            _isLoading = false;
                          });
                          PRFSnackbar.error(context, error.message);
                        },
                      );
                    },
                    builder: (context, state) {
                      return PRFButton(
                        onPressed: _submitForm,
                        title: context.l10n.addRefundEntry,
                        disabled: !_isFormValid,
                        isLoading: _isLoading,
                      );
                    },
                  )
                  .animate(delay: PRFMotionTokens.enterShort)
                  .slideY(begin: 0.3)
                  .fadeIn(),

              const SizedBox(height: PRFSpacingTokens.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String prefix,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: PRFSpacingTokens.sm),
        PRFTextField(
          type: PRFTextFieldType.number,
          controller: controller,
          hintText: hint,
          prefixText: prefix,
          errorText: _showValidation ? _amountError : null,
        ),
      ],
    );
  }

  void _submitForm() {
    if (!_validateForm()) return;

    final amount = double.parse(_amountController.text).round();
    final confirmationMessage = _confirmationController.text.trim();

    context.read<AllocationEntryResourceCubit>().addRefund(
      data: PRFRefundDTO(
        accountingEventUlid: widget.accountingEventUlid,
        amount: amount,
        confirmationMessage: confirmationMessage,
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }
}
