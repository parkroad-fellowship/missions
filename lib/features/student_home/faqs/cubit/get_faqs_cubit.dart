import 'package:app/models/remote/prf_faq.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_faqs_state.dart';
part 'get_faqs_cubit.freezed.dart';

class GetFaqsCubit extends Cubit<GetFaqsState> {
  GetFaqsCubit({
    required StudentService studentService,
  }) : super(const GetFaqsState.initial()) {
    _studentService = studentService;
  }

  late StudentService _studentService;

  Future<void> getFaqs() async {
    emit(const GetFaqsState.loading());
    try {
      final faqs = await _studentService.getFaqs();
      emit(GetFaqsState.loaded(faqs: faqs));
    } catch (e) {
      emit(GetFaqsState.error(e.toString()));
    }
  }
}
