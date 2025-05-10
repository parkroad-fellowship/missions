import 'package:app/enums/prf_charge_type.dart';
import 'package:app/features/home/missions/cubit/add_expense_cubit.dart';
import 'package:app/features/home/missions/cubit/get_expense_categories_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_expense_category.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
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

  bool _isLoading = false;

  PRFExpenseCategory? selectedExpenseCategory;
  PRFChargeType? selectedChargeType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16) +
          const EdgeInsets.only(bottom: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.expenseCategory,
                isRequired: true,
              ),
            ),
            const SizedBox(height: 5),
            BlocBuilder<GetExpenseCategoriesCubit, GetExpenseCategoriesState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  loading: () => const Center(child: LinearProgressIndicator()),
                  loaded:
                      (expenseCategories) => LayoutBuilder(
                        builder: (context, constraints) {
                          return DropdownMenu<PRFExpenseCategory>(
                            width: constraints.maxWidth,
                            initialSelection: selectedExpenseCategory,
                            hintText: l10n.expenseCategory,
                            dropdownMenuEntries:
                                expenseCategories
                                    .map(
                                      (expenseCategory) =>
                                          DropdownMenuEntry<PRFExpenseCategory>(
                                            value: expenseCategory,
                                            label: expenseCategory.name,
                                          ),
                                    )
                                    .toList(),
                            onSelected:
                                (classGroup) => setState(() {
                                  selectedExpenseCategory = classGroup;
                                }),
                          );
                        },
                      ),
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(label: l10n.narration, isRequired: true),
            ),
            const SizedBox(height: 6),
            PRFTextAreaInput(
              hintText: l10n.narration,
              controller: _narrationController,
              minLines: 2,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(label: l10n.unitCost, isRequired: true),
            ),
            const SizedBox(height: 12),
            PRFNumberInput(
              hintText: l10n.unitCost,
              controller: _unitCostController,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(label: l10n.quantity, isRequired: true),
            ),
            const SizedBox(height: 12),
            PRFNumberInput(
              hintText: l10n.quantity,
              controller: _quantityController,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(label: l10n.charge, isRequired: true),
            ),
            const SizedBox(height: 12),
            PRFNumberInput(
              hintText: l10n.charge,
              controller: _chargeController,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.confirmationMessage,
                isRequired: true,
              ),
            ),
            const SizedBox(height: 6),
            PRFTextAreaInput(
              hintText: l10n.confirmationMessage,
              controller: _confirmationMessageController,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.transactionType,
                isRequired: true,
              ),
            ),
            const SizedBox(height: 5),
            LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenu<PRFChargeType>(
                  width: constraints.maxWidth,
                  initialSelection: selectedChargeType,
                  hintText: l10n.transactionType,
                  dropdownMenuEntries:
                      PRFChargeType.values
                          .map(
                            (chargeType) => DropdownMenuEntry<PRFChargeType>(
                              value: chargeType,
                              label: chargeType.name,
                            ),
                          )
                          .toList(),
                  onSelected:
                      (chargeType) => setState(() {
                        selectedChargeType = chargeType;
                      }),
                );
              },
            ),
            const SizedBox(height: 16),
            BlocConsumer<AddExpenseCubit, AddExpenseState>(
              listener: (context, state) {
                state.mapOrNull(
                  loading: (_) {
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  loaded: (_) {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.success();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.expenseRecorded)),
                    );
                  },
                  error: (error) {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.error();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.message)));
                  },
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse:
                      () => PRFPrimaryButton(
                        title: _isLoading ? l10n.recording : l10n.record,
                        disabled: _isLoading,
                        isLoading: _isLoading ? true : null,
                        onPressed: () async {
                          if (selectedExpenseCategory == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.selectExpenseCategory),
                              ),
                            );
                            Gaimon.warning();
                            return;
                          }

                          if (selectedChargeType == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.selectTransactionType),
                              ),
                            );
                            Gaimon.warning();
                            return;
                          }

                          if (_unitCostController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.enterAmount)),
                            );
                            Gaimon.warning();
                            return;
                          }

                          if (_quantityController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.enterQuantity)),
                            );
                            Gaimon.warning();
                            return;
                          }

                          if (_chargeController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.enterCharge)),
                            );
                            Gaimon.warning();
                            return;
                          }

                          if (_confirmationMessageController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.enterConfirmationMessage),
                              ),
                            );
                            Gaimon.warning();
                            return;
                          }

                          if (_narrationController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.enterNarration)),
                            );
                            Gaimon.warning();
                            return;
                          }

                          await context.read<AddExpenseCubit>().addExpense(
                            missionUlid: widget.missionUlid,
                            expenseCategoryUlid: selectedExpenseCategory!.ulid,
                            unitCost: _unitCostController.text,
                            quantity: _quantityController.text,
                            chargeType: selectedChargeType!,
                            charge: _chargeController.text,
                            confirmationMessage:
                                _confirmationMessageController.text,
                            narration: _narrationController.text.trim(),
                          );
                        },
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
