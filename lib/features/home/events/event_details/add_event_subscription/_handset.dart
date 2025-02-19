import 'package:app/features/home/events/cubit/add_event_subscription_cubit.dart';
import 'package:app/features/home/events/cubit/get_events_cubit.dart';
import 'package:app/features/home/events/cubit/get_member_event_subscriptions_cubit.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/add_mission_ground_suggestion_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_event.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AddEventSubscriptionViewHandset extends StatefulWidget {
  const AddEventSubscriptionViewHandset({required this.event, super.key});

  final PRFEvent event;

  @override
  State<AddEventSubscriptionViewHandset> createState() =>
      _AddEventSubscriptionViewHandsetState();
}

class _AddEventSubscriptionViewHandsetState
    extends State<AddEventSubscriptionViewHandset> {
  final _ticketController = TextEditingController();

  bool _isLoading = false;

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
                label: l10n.tickets,
                isRequired: true,
                color: PRFApp.theme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            InputFormField(
              hintText: l10n.tickets,
              controller: _ticketController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 32),
            BlocConsumer<AddEventSubscriptionCubit, AddEventSubscriptionState>(
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
                    Gaimon.success();
                     Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    context.read<GetEventsCubit>().getEvents();
                    context
                        .read<GetMemberEventSubscriptionsCubit>()
                        .getMemberEventSubscriptions();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.eventRegistrationRecorded,
                        ),
                      ),
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
                      () => PrimaryButton(
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
                              .read<AddEventSubscriptionCubit>()
                              .addEventSubscription(
                                event: widget.event,
                                tickets: _ticketController.text.trim(),
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
