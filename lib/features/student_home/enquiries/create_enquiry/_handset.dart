import 'package:app/features/student_home/enquiries/cubit/create_enquiry_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateEnquiryPageHandset extends StatefulWidget {
  const CreateEnquiryPageHandset({super.key});

  @override
  State<CreateEnquiryPageHandset> createState() =>
      _CreateEnquiryPageHandsetState();
}

class _CreateEnquiryPageHandsetState extends State<CreateEnquiryPageHandset> {
  final _enquiryController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ask, style: Theme.of(context).textTheme.displayLarge),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(label: l10n.enquiry, isRequired: true),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(label: l10n.rules, isRequired: true),
            ),
            const SizedBox(height: 8),
            PRFTextAreaInput(
              hintText: l10n.enquiry,
              controller: _enquiryController,
            ),
            const SizedBox(height: 16),
            BlocConsumer<CreateEnquiryCubit, CreateEnquiryState>(
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
                    _enquiryController.clear();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.enquiryRecorded)),
                    );
                  },
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse:
                      () => PRFPrimaryButton(
                        title: _isLoading ? l10n.recording : l10n.ask,
                        disabled: _isLoading,
                        isLoading: _isLoading ? true : null,
                        onPressed: () async {
                          await context
                              .read<CreateEnquiryCubit>()
                              .createEnquiry(content: _enquiryController.text);
                        },
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
