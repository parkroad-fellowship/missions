import 'package:app/features/home/events/cubit/delete_event_subscription_cubit.dart';
import 'package:app/features/home/events/cubit/get_events_cubit.dart';
import 'package:app/features/home/events/cubit/get_member_event_subscriptions_cubit.dart';
import 'package:app/features/home/events/cubit/update_event_subscription_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/models/remote/prf_event_subscription.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';

class UpdateEventSubscriptionViewHandset extends StatefulWidget {
  const UpdateEventSubscriptionViewHandset({required this.event, super.key});

  final PRFEvent event;

  @override
  State<UpdateEventSubscriptionViewHandset> createState() =>
      _UpdateEventSubscriptionViewHandsetState();
}

class _UpdateEventSubscriptionViewHandsetState
    extends State<UpdateEventSubscriptionViewHandset> {
  PRFEventSubscription get eventSubscription =>
      widget.event.loggedInMemberEventSubscription!;
  PRFEvent get event => widget.event;

  final _ticketController = TextEditingController();
  bool _isLoading = false;

  // Add form validity check
  bool get _isFormValid {
    return _ticketController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    // Initialize the fields with the current values
    _ticketController.text = eventSubscription.numberOfAttendees.toString();
    // Add listeners to update form validity
    _ticketController.addListener(() => setState(() {}));
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
                      Icons.edit_calendar_rounded,
                      size: 32,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.updateRegistration,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.event.name,
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
                      icon: Icons.confirmation_number_rounded,
                      title: l10n.tickets,
                      isRequired: true,
                      child: PRFNumberInput(
                        hintText: l10n.tickets,
                        controller: _ticketController,
                      ),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Update Button
              BlocConsumer<
                UpdateEventSubscriptionCubit,
                UpdateEventSubscriptionState
              >(
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
                      Navigator.of(context).pop();
                      context.read<GetEventsCubit>().getEvents();
                      context
                          .read<GetMemberEventSubscriptionsCubit>()
                          .getMemberEventSubscriptions();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.eventRegistrationRecorded),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    error: (error) {
                      setState(() {
                        _isLoading = false;
                      });
                      Gaimon.error();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.message),
                          backgroundColor: Theme.of(context).colorScheme.error,
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
                  return PRFPrimaryButton(
                    onPressed: _submitForm,
                    title: l10n.record,
                    disabled: !_isFormValid,
                    isLoading: _isLoading,
                  );
                },
              ).animate(delay: 200.ms).slideY(begin: 0.3).fadeIn(),

              const SizedBox(height: 24),

              // Cancel Registration Button
              PRFDestroyButton(
                title: l10n.cancelRegistration,
                disabled: false,
                onPressed: () async => showDialog<void>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        l10n.cancelRegistration,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      content: Text(
                        l10n.confirmCancellation,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            l10n.cancel,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        BlocConsumer<
                          DeleteEventSubscriptionCubit,
                          DeleteEventSubscriptionState
                        >(
                          listener: (context, state) {
                            state.mapOrNull(
                              loaded: (_) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                context.read<GetEventsCubit>().getEvents();
                                context
                                    .read<GetMemberEventSubscriptionsCubit>()
                                    .getMemberEventSubscriptions();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.subscriptionCancelled),
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                              error: (e) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.message),
                                    backgroundColor: Theme.of(context).colorScheme.error,
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
                            return TextButton(
                              onPressed: () {
                                context
                                    .read<DeleteEventSubscriptionCubit>()
                                    .deleteSubscription(
                                      eventSubscriptionUlid:
                                          eventSubscription.ulid,
                                    );
                              },
                              child: state.maybeWhen(
                                orElse: () => Text(
                                  l10n.next,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                loading: () => SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
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

    if (_ticketController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.enterTickets),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      Gaimon.warning();
      return;
    }

    await context
        .read<UpdateEventSubscriptionCubit>()
        .updateEventSubscription(
          event: widget.event,
          eventSubscription: eventSubscription,
          tickets: _ticketController.text.trim(),
        );
  }
}
