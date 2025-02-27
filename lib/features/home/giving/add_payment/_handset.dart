import 'package:app/features/home/giving/cubit/add_payment_cubit.dart';
import 'package:app/features/home/giving/cubit/get_payment_types_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_payment_type.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<GetPaymentTypesCubit>().getPaymentTypes();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.reasonForGiving,
                isRequired: true,
              ),
            ),
            const SizedBox(height: 6),
            BlocBuilder<GetPaymentTypesCubit, GetPaymentTypesState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  loading: () => const Center(child: LinearProgressIndicator()),
                  loaded:
                      (classes) => LayoutBuilder(
                        builder: (context, constraints) {
                          return DropdownMenu<PRFPaymentType>(
                            width: constraints.maxWidth,
                            initialSelection: selectedPaymentType,
                            hintText: l10n.reasonForGiving,
                            dropdownMenuEntries:
                                classes
                                    .map(
                                      (paymentType) =>
                                          DropdownMenuEntry<PRFPaymentType>(
                                            value: paymentType,
                                            label: paymentType.name,
                                          ),
                                    )
                                    .toList(),
                            onSelected:
                                (paymentType) => setState(() {
                                  selectedPaymentType = paymentType;
                                }),
                            inputDecorationTheme: InputDecorationTheme(
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              hintStyle:
                                  Theme.of(context).textTheme.headlineSmall,
                            ),
                          );
                        },
                      ),
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(label: l10n.amount, isRequired: true),
            ),
            const SizedBox(height: 6),
            InputFormField(
              hintText: l10n.enterAmount,
              controller: _amountController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
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
                    if (result.payment.redirectUrl != null) {
                      await Misc.openUrl(
                        Uri.parse(result.payment.redirectUrl!),
                      );
                    }
                  },
                  error: (error) {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.error();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.error)));
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
                          if (_amountController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.enterAmount)),
                            );
                            Gaimon.warning();
                            return;
                          }

                          if (selectedPaymentType == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.selectReasonForGiving),
                              ),
                            );
                            Gaimon.warning();
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
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
