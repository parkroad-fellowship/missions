import 'package:app/enums/prf_charge_type.dart';
import 'package:app/features/home/missions/cubit/add_expense_cubit.dart';
import 'package:app/features/home/missions/cubit/get_expense_categories_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_expense_category.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';

class AddExpenseViewHandset extends StatefulWidget {
  const AddExpenseViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<AddExpenseViewHandset> createState() => _AddExpenseViewHandsetState();
}

class _AddExpenseViewHandsetState extends State<AddExpenseViewHandset> {
  final _unitCostController = TextEditingController();
  final _quantityController = TextEditingController();
  final _chargeController = TextEditingController();
  final _narrationController = TextEditingController();
  final _confirmationMessageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  PRFExpenseCategory? selectedExpenseCategory;
  PRFChargeType? selectedChargeType;
  double _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _unitCostController.addListener(_calculateTotal);
    _quantityController.addListener(_calculateTotal);
    _chargeController.addListener(_calculateTotal);
  }

  void _calculateTotal() {
    final unitCost = double.tryParse(_unitCostController.text) ?? 0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final charge = double.tryParse(_chargeController.text) ?? 0;
    final lineTotal = unitCost * quantity;

    setState(() {
      _totalAmount = lineTotal + charge;
    });
  }

  bool get _isFormValid {
    return selectedExpenseCategory != null &&
        selectedChargeType != null &&
        _unitCostController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty &&
        _chargeController.text.isNotEmpty &&
        _narrationController.text.isNotEmpty &&
        _confirmationMessageController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Card with Gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      color: theme.colorScheme.onPrimary,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add New Expense',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_totalAmount > 0) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Total: KES ${_totalAmount.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ).animate().fadeIn().slideY(begin: -0.3, end: 0),

              const SizedBox(height: 24),

              // Main Form Card
              Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Selection
                          _buildSectionHeader(
                            'Expense Details',
                            Icons.category,
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<
                            GetExpenseCategoriesCubit,
                            GetExpenseCategoriesState
                          >(
                            builder: (context, state) {
                              return state.maybeWhen(
                                orElse: () => const SizedBox.shrink(),
                                loading: () => const LinearProgressIndicator(),
                                loaded: (expenseCategories) =>
                                    _buildCategorySelector(
                                      expenseCategories,
                                      theme,
                                    ),
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // Amount Section
                          _buildSectionHeader('Amount Details', Icons.payments),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildNumberField(
                                  controller: _unitCostController,
                                  label: 'Unit Cost',
                                  hint: 'Enter cost per item',
                                  prefix: 'KES ',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildNumberField(
                                  controller: _quantityController,
                                  label: 'Quantity',
                                  hint: 'Enter quantity',
                                  prefix: '× ',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Manual Charge Entry
                          _buildNumberField(
                            controller: _chargeController,
                            label: 'Transaction Charge',
                            hint: 'Enter transaction cost manually',
                            prefix: 'KES ',
                            fullWidth: true,
                          ),

                          if (_totalAmount > 0) ...[
                            const SizedBox(height: 16),
                            _buildCalculationSummary(theme),
                          ],

                          const SizedBox(height: 24),

                          // Transaction Type
                          _buildSectionHeader('Payment Method', Icons.payment),
                          const SizedBox(height: 16),
                          _buildTransactionTypeSelector(theme),

                          const SizedBox(height: 24),

                          // Description Section
                          _buildSectionHeader('Description', Icons.description),
                          const SizedBox(height: 16),
                          PRFTextAreaInput(
                            hintText: 'Describe what the money was used for...',
                            controller: _narrationController,
                          ),

                          const SizedBox(height: 16),
                          PRFTextInput(
                            hintText:
                                'Enter confirmation message (SMS/Receipt)',
                            controller: _confirmationMessageController,
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate(delay: const Duration(milliseconds: 200))
                  .fadeIn()
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 24),

              // Submit Button
              BlocConsumer<AddExpenseCubit, AddExpenseState>(
                    listener: (context, state) {
                      state.mapOrNull(
                        loading: (_) => setState(() => _isLoading = true),
                        loaded: (_) {
                          setState(() => _isLoading = false);
                          Gaimon.success();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.expenseRecorded)),
                          );
                        },
                        error: (error) {
                          setState(() => _isLoading = false);
                          Gaimon.error();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.message)),
                          );
                        },
                      );
                    },
                    builder: (context, state) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isFormValid && !_isLoading
                              ? _submitForm
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFormValid
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surfaceContainerHighest,
                            foregroundColor: _isFormValid
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: _isFormValid ? 4 : 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add_circle_outline,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Record Expense',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  )
                  .animate(delay: const Duration(milliseconds: 400))
                  .fadeIn()
                  .slideY(begin: 0.5, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(
    List<PRFExpenseCategory> categories,
    ThemeData theme,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = selectedExpenseCategory?.ulid == category.ulid;
        return GestureDetector(
          onTap: () => setState(() => selectedExpenseCategory = category),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              category.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String prefix,
    bool fullWidth = false,
  }) {
    final theme = Theme.of(context);
    final field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            prefixStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );

    return fullWidth ? field : Expanded(child: field);
  }

  Widget _buildCalculationSummary(ThemeData theme) {
    final unitCost = double.tryParse(_unitCostController.text) ?? 0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final charge = double.tryParse(_chargeController.text) ?? 0;
    final lineTotal = unitCost * quantity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          _buildCalculationRow('Subtotal', lineTotal, theme),
          const SizedBox(height: 8),
          _buildCalculationRow('Transaction Charge', charge, theme),
          const Divider(),
          _buildCalculationRow(
            'Total Amount',
            _totalAmount,
            theme,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationRow(
    String label,
    double amount,
    ThemeData theme, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: isTotal
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          'KES ${amount.toStringAsFixed(2)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isTotal
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTypeSelector(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: PRFChargeType.values.map((type) {
        final isSelected = selectedChargeType == type;
        return GestureDetector(
          onTap: () => setState(() => selectedChargeType = type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
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
                const SizedBox(width: 8),
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
      default:
        return Icons.phone_android;
    }
  }

  Future<void> _submitForm() async {
    if (!_isFormValid) return;

    await context.read<AddExpenseCubit>().addExpense(
      missionUlid: widget.missionUlid,
      expenseCategoryUlid: selectedExpenseCategory!.ulid,
      unitCost: _unitCostController.text,
      quantity: _quantityController.text,
      chargeType: selectedChargeType!,
      charge: _chargeController.text, // Manual charge entry preserved
      confirmationMessage: _confirmationMessageController.text,
      narration: _narrationController.text.trim(),
    );
  }

  @override
  void dispose() {
    _unitCostController.dispose();
    _quantityController.dispose();
    _chargeController.dispose();
    _narrationController.dispose();
    _confirmationMessageController.dispose();
    super.dispose();
  }
}
