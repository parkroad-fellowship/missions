import 'package:app/enums/payment/prf_charge_type.dart';
import 'package:app/features/missions/mission_details/widgets/expenses/cubit/allocation_entry_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/expense/prf_allocation_entry.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class AddTokenViewHandset extends StatefulWidget {
  const AddTokenViewHandset({
    required this.accountingEventUlid,
    super.key,
  });

  final String accountingEventUlid;

  @override
  State<AddTokenViewHandset> createState() => _AddTokenViewHandsetState();
}

class _AddTokenViewHandsetState extends State<AddTokenViewHandset> {
  final _amountController = TextEditingController();
  final _confirmationController = TextEditingController();

  bool _isLoading = false;
  PRFChargeType _selectedChargeType = PRFChargeType.cash;

  // Structured validation
  bool _showValidation = false;
  String? _amountError;
  String? _confirmationError;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onFormChange);
    _confirmationController.addListener(_onFormChange);
  }

  bool get _isFormValid {
    return _amountController.text.isNotEmpty &&
        _confirmationController.text.isNotEmpty;
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
    final l10n = context.l10n;

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
                          Icons.toll,
                          size: 32,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        Text(
                          l10n.addTokenTitle,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onTertiary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.xs),
                        Text(
                          l10n.addTokenDesc,
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
                          title: context.l10n.amount,
                          isRequired: true,
                          child: _buildNumberField(
                            controller: _amountController,
                            label: context.l10n.tokenAmount_2,
                            hint: l10n.enterTokenAmount,
                            prefix: 'KES ',
                          ),
                        )
                        .animate(delay: PRFMotionTokens.standard)
                        .slideX(begin: -0.2)
                        .fadeIn(),

                    PRFFormSection(
                          icon: Icons.description,
                          title: l10n.description,
                          isRequired: true,
                          child: Column(
                            children: [
                              PRFTextField(
                                type: PRFTextFieldType.textArea,
                                hintText: l10n.confirmationMessage,
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

                    PRFFormSection(
                          icon: Icons.payment,
                          title: l10n.paymentMethod,
                          isRequired: true,
                          child: _buildTransactionTypeSelector(
                            Theme.of(context),
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
                        title: context.l10n.addToken,
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

  Widget _buildTransactionTypeSelector(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: PRFChargeType.values.map((type) {
        final isSelected = _selectedChargeType == type;
        return GestureDetector(
          onTap: () => setState(() => _selectedChargeType = type),
          child: AnimatedContainer(
            duration: PRFMotionTokens.standard,
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.lg,
              vertical: PRFSpacingTokens.md,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(
                        alpha: PRFOpacities.glow,
                      ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getPaymentIcon(type),
                  size: 16,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: PRFSpacingTokens.sm),
                Text(
                  type.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getPaymentIcon(PRFChargeType type) {
    switch (type) {
      case PRFChargeType.cash:
        return Icons.payments;
      case PRFChargeType.mpesaATMWithdrawal:
        return Icons.atm;
      case PRFChargeType.mpesaAgentWithdrawal:
      case PRFChargeType.mpesaDefault:
      case PRFChargeType.mpesaOtherRegisteredUser:
        return Icons.phone_android;
    }
  }

  void _submitForm() {
    if (!_isFormValid) return;

    final amount = double.parse(_amountController.text).round();

    context.read<AllocationEntryResourceCubit>().addTokenEntry(
      accountingEventUlid: widget.accountingEventUlid,
      amount: amount,
      confirmationMessage: _confirmationController.text,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }
}
