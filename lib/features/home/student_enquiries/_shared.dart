// ignore_for_file: avoid_positional_boolean_parameters
import 'package:app/features/home/student_enquiries/cubit/enquiry_resource_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentEnquiriesFormState {
  StudentEnquiriesFormState();

  late final VoidCallback _rebuild;

  bool selectedReplyStatus = false;

  // ignore: use_setters_to_change_properties
  void attach(VoidCallback rebuild) {
    _rebuild = rebuild;
  }

  void setReplyStatus(bool status) {
    selectedReplyStatus = status;
    _rebuild();
  }

  void load(BuildContext context) {
    context.read<EnquiryResourceCubit>().loadAll();
  }

  void dispose() {}
}
