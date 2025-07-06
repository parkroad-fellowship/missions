import 'package:app/features/home/prayer_requests/cubit/add_prayer_request_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:app/widgets/input/name.dart';
import 'package:app/widgets/input/text_area.dart';

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
    final theme = Theme.of(context);

    return Column(
      children: [
        // Modal Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: .3),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: .1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.self_improvement_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.submitPrayerRequest,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.submitPrayerRequestDesc,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Form Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.title} *',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                PRFNameInput(
                  hintText: l10n.title,
                  controller: _titleController,
                ),
                const SizedBox(height: 24),
                Text(
                  '${l10n.prayerRequest} *',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                PRFTextAreaInput(
                  hintText: l10n.prayerRequest,
                  controller: _requestController,
                ),
                const SizedBox(height: 40),
                BlocConsumer<AddPrayerRequestCubit, AddPrayerRequestState>(
                  listener: (context, state) {
                    state.mapOrNull(
                      loading: (_) => setState(() => _isLoading = true),
                      loaded: (_) {
                        setState(() => _isLoading = false);
                        Gaimon.success();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.prayerRequestSubmitted),
                            backgroundColor: theme.colorScheme.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      error: (error) {
                        setState(() => _isLoading = false);
                        Gaimon.error();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.message),
                            backgroundColor: theme.colorScheme.error,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: PRFPrimaryButton(
                        title: _isLoading ? l10n.submitting : l10n.submit,
                        isLoading: _isLoading,
                        disabled: _isLoading,
                        onPressed: () {
                          final name = _titleController.text.trim();
                          final request = _requestController.text.trim();

                          if (name.isEmpty || request.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.fillAllFields),
                                backgroundColor: theme.colorScheme.error,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                            Gaimon.warning();
                            return;
                          }

                          context
                              .read<AddPrayerRequestCubit>()
                              .addPrayerRequest(
                                title: name,
                                description: request,
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
        ),
      ],
    );
  }
}
