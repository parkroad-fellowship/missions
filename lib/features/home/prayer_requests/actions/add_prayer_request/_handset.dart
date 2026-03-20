import 'package:app/features/home/prayer_requests/cubit/prayer_request_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prayer/prf_prayer_request.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

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

  // Structured validation
  bool _showValidation = false;
  String? _titleError;
  String? _requestError;

  bool get _isFormValid {
    return _titleController.text.isNotEmpty &&
        _requestController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onFormChanged);
    _requestController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (_showValidation) {
      _validateForm();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _requestController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    _titleError = null;
    _requestError = null;
  }

  bool _validateForm() {
    _clearErrors();

    if (_titleController.text.trim().isEmpty) {
      _titleError = 'Title is required';
    }
    if (_requestController.text.trim().isEmpty) {
      _requestError = 'Prayer request is required';
    }

    setState(() => _showValidation = true);

    return _titleError == null && _requestError == null;
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
                          Theme.of(context).colorScheme.primary,
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
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
                        const SizedBox(height: PRFSpacingTokens.sm),
                        Text(
                          l10n.submitPrayerRequest,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.xs),
                        Text(
                          l10n.submitPrayerRequestDesc,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withValues(alpha: 0.9),
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
                    PRFFormSection(
                      icon: Icons.title_outlined,
                      title: l10n.title,
                      isRequired: true,
                      child: PRFTextInput(
                        hintText: l10n.title,
                        controller: _titleController,
                        errorText: _showValidation ? _titleError : null,
                      ),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),

                    PRFFormSection(
                          icon: Icons.notes_outlined,
                          title: l10n.prayerRequest,
                          isRequired: true,
                          child: PRFTextAreaInput(
                            hintText: l10n.prayerRequest,
                            controller: _requestController,
                            errorText: _showValidation ? _requestError : null,
                          ),
                        )
                        .animate(delay: PRFMotionTokens.standard)
                        .slideX(begin: -0.2)
                        .fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: PRFSpacingTokens.xl),

              // Submit Button
              BlocConsumer<
                    PrayerRequestResourceCubit,
                    ResourceState<PRFPrayerRequest>
                  >(
                    listenWhen: (prev, curr) =>
                        curr is ResourceMutated<PRFPrayerRequest> ||
                        curr is ResourceError<PRFPrayerRequest>,
                    listener: (context, state) {
                      switch (state) {
                        case ResourceMutated<PRFPrayerRequest>():
                          setState(() {
                            _isLoading = false;
                          });
                          Gaimon.success();
                          Navigator.of(context).pop();
                          PRFSnackbar.success(
                            context,
                            l10n.prayerRequestSubmitted,
                          );
                        case ResourceError<PRFPrayerRequest>(:final message):
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
                        curr is ResourceMutating<PRFPrayerRequest> ||
                        curr is ResourceError<PRFPrayerRequest>,
                    builder: (context, state) {
                      return PRFPrimaryButton(
                        onPressed: _submitForm,
                        title: l10n.submit,
                        disabled: !_isFormValid,
                        isLoading: _isLoading,
                      );
                    },
                  )
                  .animate(delay: PRFMotionTokens.slow)
                  .slideY(begin: 0.3)
                  .fadeIn(),

              const SizedBox(height: PRFSpacingTokens.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
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

    await context.read<PrayerRequestResourceCubit>().createPrayerRequest(
      title: _titleController.text.trim(),
      description: _requestController.text.trim(),
    );
  }
}
