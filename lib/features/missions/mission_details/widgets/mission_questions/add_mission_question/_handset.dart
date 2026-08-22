import 'package:app/features/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_question.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

class AddMissionQuestionViewHandset extends StatefulWidget {
  const AddMissionQuestionViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<AddMissionQuestionViewHandset> createState() =>
      _AddMissionQuestionViewHandsetState();
}

class _AddMissionQuestionViewHandsetState
    extends State<AddMissionQuestionViewHandset> {
  final _questionController = TextEditingController();
  bool _isLoading = false;

  // Structured validation
  bool _showValidation = false;
  String? _questionError;

  bool get _isFormValid => _questionController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _questionController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (_showValidation) {
      _validateForm();
    }
    setState(() {});
  }

  void _clearErrors() {
    _questionError = null;
  }

  bool _validateForm() {
    _clearErrors();

    if (_questionController.text.trim().isEmpty) {
      _questionError = context.l10n.fieldRequired(context.l10n.question);
    }

    setState(() => _showValidation = true);
    return _questionError == null;
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
            ).colorScheme.primary.withValues(alpha: PRFOpacities.faint),
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
                          ).colorScheme.primary.withValues(
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
                              ).colorScheme.primary.withValues(
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
                          Icons.help_outline,
                          size: 32,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        Text(
                          l10n.addQuestion,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.xs),
                        Text(
                          l10n.addQuestionSubTitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimary.withValues(
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
                      icon: Icons.help_outline,
                      title: l10n.addQuestion,
                      isRequired: true,
                      child: PRFTextField(
                        type: PRFTextFieldType.textArea,
                        hintText: l10n.addQuestionDesc,
                        controller: _questionController,
                        enabled: !_isLoading,
                        maxLines: 6,
                        errorText: _showValidation ? _questionError : null,
                      ),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: PRFSpacingTokens.xl),

              // Submit Button
              BlocConsumer<
                    MissionQuestionResourceCubit,
                    ResourceState<PRFMissionQuestion>
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
                          Gaimon.success();
                          Navigator.of(context).pop();
                          PRFSnackbar.success(context, l10n.questionRecorded);
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
                      return PRFButton(
                        onPressed: _submitForm,
                        title: l10n.record,
                        disabled: !_isFormValid,
                        isLoading: _isLoading,
                      );
                    },
                  )
                  .animate(delay: PRFMotionTokens.standard)
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
        context.l10n.fixHighlightedFields,
      );
      return;
    }

    await context.read<MissionQuestionResourceCubit>().addMissionQuestion(
      missionUlid: widget.missionUlid,
      question: _questionController.text.trim(),
    );
  }
}
