import 'package:app/models/local/prf_faq.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_faqs_state.dart';
part 'get_faqs_cubit.freezed.dart';

class GetFaqsCubit extends Cubit<GetFaqsState> {
  GetFaqsCubit({
    required StudentService studentService,
    required LocalDBService localDBService,
  }) : super(const GetFaqsState.initial()) {
    _studentService = studentService;
    _localDBService = localDBService;
  }

  late StudentService _studentService;
  late LocalDBService _localDBService;

  Future<void> getFaqs({
    bool forceRefresh = false,
    String? categoryUlid,
    String? query,
  }) async {
    emit(const GetFaqsState.loading());
    try {
      final localFaqs = await _localDBService.retreiveFaqs(
        categoryUlid: categoryUlid,
        query: query,
      );
      if (localFaqs.isNotEmpty && !forceRefresh) {
        emit(GetFaqsState.loaded(faqs: localFaqs));
        return;
      }

      if (localFaqs.isEmpty || forceRefresh) {
        await _networkFetch();

        final localFaqs = await _localDBService.retreiveFaqs(
          categoryUlid: categoryUlid,
          query: query,
        );
        emit(GetFaqsState.loaded(faqs: localFaqs));
        return;
      }
    } catch (e) {
      emit(GetFaqsState.error(e.toString()));
    }
  }

  Future<void> _networkFetch() async {
    final faqs = await _studentService.getFaqs(include: 'missionFaqCategory');
    await _localDBService.persistFaqs(faqs: faqs);
  }
}
