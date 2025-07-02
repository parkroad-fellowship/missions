import 'package:app/features/home/events/cubit/delete_event_subscription_cubit.dart';
import 'package:app/features/home/events/cubit/get_events_cubit.dart';
import 'package:app/features/home/events/cubit/get_member_event_subscriptions_cubit.dart';
import 'package:app/features/home/events/cubit/update_event_subscription_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/models/remote/prf_event_subscription.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    // Initialize the fields with the current values
    _ticketController.text = eventSubscription.numberOfAttendees.toString();
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
              child: FormFieldLabel(label: l10n.tickets, isRequired: true),
            ),
            const SizedBox(height: 6),
            PRFNumberInput(
              hintText: l10n.tickets,
              controller: _ticketController,
            ),

            const SizedBox(height: 32),
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
                  loaded: (result) {
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    context.read<GetEventsCubit>().getEvents();
                    context
                        .read<GetMemberEventSubscriptionsCubit>()
                        .getMemberEventSubscriptions();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.eventRegistrationRecorded)),
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
                  orElse: () => PRFPrimaryButton(
                    title: _isLoading ? l10n.recording : l10n.record,
                    disabled: _isLoading,
                    isLoading: _isLoading ? true : null,
                    onPressed: () async {
                      if (_ticketController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.enterTickets)),
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
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: PRFDestoryButton(
                title: l10n.cancelRegistration,
                disabled: false,
                onPressed: () async => showDialog<void>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(l10n.cancelRegistration),
                      content: Text(l10n.confirmCancellation),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.cancel),
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
                                context
                                    .read<DeleteEventSubscriptionCubit>()
                                    .deleteSubscription(
                                      eventSubscriptionUlid:
                                          eventSubscription.ulid,
                                    );
                                context.read<GetEventsCubit>().getEvents();
                                context
                                    .read<GetMemberEventSubscriptionsCubit>()
                                    .getMemberEventSubscriptions();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.subscriptionCancelled,
                                    ),
                                  ),
                                );
                              },
                              error: (e) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.message)),
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
                                orElse: () => Text(l10n.next),
                                loading: () =>
                                    const CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
