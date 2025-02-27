import 'package:app/features/home/missions/cubit/add_token_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTokenViewHandset extends StatefulWidget {
  const AddTokenViewHandset({required this.missionExpenseUlid, super.key});

  final String missionExpenseUlid;

  @override
  State<AddTokenViewHandset> createState() => _AddTokenViewHandsetState();
}

class _AddTokenViewHandsetState extends State<AddTokenViewHandset> {
  final _amountController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: FormFieldLabel(label: l10n.tokenAmount, isRequired: true),
          ),
          const SizedBox(height: 5),
          PRFNumberInput(
            hintText: l10n.tokenAmount,
            controller: _amountController,
          ),
          const SizedBox(height: 16),
          BlocConsumer<AddTokenCubit, AddTokenState>(
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
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.tokenRecorded)));
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
                          return;
                        }

                        await context.read<AddTokenCubit>().addToken(
                          missionExpenseUlid: widget.missionExpenseUlid,
                          tokenAmount: _amountController.text,
                        );
                      },
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
