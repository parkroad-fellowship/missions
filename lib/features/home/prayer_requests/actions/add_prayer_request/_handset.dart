import 'package:app/features/home/prayer_requests/cubit/add_prayer_request_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/shared_widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

  // Add form validity check
  bool get _isFormValid {
    return _titleController.text.isNotEmpty &&
        _requestController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to update form validity
    _titleController.addListener(() => setState(() {}));
    _requestController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _requestController.dispose();
    super.dispose();
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
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.self_improvement_rounded,
                      size: 32,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.submitPrayerRequest,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.submitPrayerRequestDesc,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().slideY(begin: -0.3).fadeIn(duration: 600.ms),

              const SizedBox(height: 24),

              // Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildFormSection(
                      icon: Icons.title_outlined,
                      title: l10n.title,
                      isRequired: true,
                      child: PRFNameInput(
                        hintText: l10n.title,
                        controller: _titleController,
                      ),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),

                    _buildFormSection(
                      icon: Icons.notes_outlined,
                      title: l10n.prayerRequest,
                      isRequired: true,
                      child: PRFTextAreaInput(
                        hintText: l10n.prayerRequest,
                        controller: _requestController,
                      ),
                    ).animate(delay: 200.ms).slideX(begin: -0.2).fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              BlocConsumer<AddPrayerRequestCubit, AddPrayerRequestState>(
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
                      PRFSnackbar.success(context, l10n.prayerRequestSubmitted);
                    },
                    error: (error) {
                      setState(() {
                        _isLoading = false;
                      });
                      Gaimon.error();
                      PRFSnackbar.error(context, error.message);
                    },
                  );
                },
                builder: (context, state) {
                  return PRFPrimaryButton(
                    onPressed: _submitForm,
                    title: l10n.submit,
                    disabled: !_isFormValid,
                    isLoading: _isLoading,
                  );
                },
              ).animate(delay: 300.ms).slideY(begin: 0.3).fadeIn(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required IconData icon,
    required String title,
    required Widget child,
    bool isRequired = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              FormFieldLabel(label: title, isRequired: isRequired),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    final l10n = context.l10n;

    if (_titleController.text.isEmpty) {
      PRFSnackbar.warning(context, l10n.fillAllFields);
      Gaimon.warning();
      return;
    }

    if (_requestController.text.isEmpty) {
      PRFSnackbar.warning(context, l10n.fillAllFields);
      Gaimon.warning();
      return;
    }

    await context.read<AddPrayerRequestCubit>().addPrayerRequest(
      title: _titleController.text.trim(),
      description: _requestController.text.trim(),
    );
  }
}
