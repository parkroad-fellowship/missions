import 'package:app/features/home/prayer_requests/cubit/add_prayer_request_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/widgets/_index.dart';
import 'package:app/widgets/buttons/primary.dart';
import 'package:app/widgets/input/name.dart';
import 'package:app/widgets/input/text_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';

class AddPrayerRequestViewHandset extends StatefulWidget {
  const AddPrayerRequestViewHandset({super.key});

  @override
  State<AddPrayerRequestViewHandset> createState() =>
      _AddPrayerRequestViewHandsetState();
}

class _AddPrayerRequestViewHandsetState
    extends State<AddPrayerRequestViewHandset> {
  final _titleController = TextEditingController();
  final _requestController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(label: l10n.title, isRequired: true),
            ),
            const SizedBox(height: 12),
            PRFNameInput(hintText: l10n.title, controller: _titleController),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.prayerRequest,
                isRequired: true,
              ),
            ),
            const SizedBox(height: 12),
            PRFTextAreaInput(
              hintText: l10n.prayerRequest,
              controller: _requestController,
            ),
            const SizedBox(height: 32),
            BlocConsumer<AddPrayerRequestCubit, AddPrayerRequestState>(
              listener: (context, state) {
                state.mapOrNull(
                  loading: (_) => setState(() => _isLoading = true),
                  loaded: (_) {
                    setState(() => _isLoading = false);
                    Gaimon.success();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.prayerRequestSubmitted)),
                    );
                  },
                  error: (error) {
                    setState(() => _isLoading = false);
                    Gaimon.error();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.message)));
                  },
                );
              },
              builder: (context, state) {
                return PRFPrimaryButton(
                  title: _isLoading ? l10n.submitting : l10n.submit,
                  isLoading: _isLoading,
                  disabled: _isLoading,
                  onPressed: () {
                    final name = _titleController.text.trim();
                    final request = _requestController.text.trim();

                    if (name.isEmpty || request.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.fillAllFields)),
                      );
                      Gaimon.warning();
                      return;
                    }

                    context.read<AddPrayerRequestCubit>().addPrayerRequest(
                      title: name,
                      description: request,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
