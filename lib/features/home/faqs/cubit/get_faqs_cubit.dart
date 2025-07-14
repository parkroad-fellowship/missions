import 'package:app/models/local/prf_faq.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/api/mission_faq_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_faqs_state.dart';
part 'get_faqs_cubit.freezed.dart';

class GetFaqsCubit extends Cubit<GetFaqsState> {
  GetFaqsCubit({
    required MissionFaqService missionFaqService,
    required LocalDBService localDBService,
  }) : super(const GetFaqsState.initial()) {
    _missionFaqService = missionFaqService;
    _localDBService = localDBService;
  }

  late MissionFaqService _missionFaqService;
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

      // If we have local data and not forcing refresh, use cached data
      if (localFaqs.isNotEmpty && !forceRefresh) {
        emit(GetFaqsState.loaded(faqs: localFaqs));
        return;
      }

      // If no local data OR forcing refresh, fetch from network
      if (localFaqs.isEmpty || forceRefresh) {
        await _networkFetch();

        final updatedLocalFaqs = await _localDBService.retreiveFaqs(
          categoryUlid: categoryUlid,
          query: query,
        );

        if (updatedLocalFaqs.isEmpty) {
          emit(const GetFaqsState.empty());
          return;
        }
        emit(GetFaqsState.loaded(faqs: updatedLocalFaqs));
        return;
      }
    } catch (e) {
      emit(GetFaqsState.error(e.toString()));
    }
  }

  Future<void> _networkFetch() async {
    final faqs = await _missionFaqService.list(
      limit: 500,
      includes: ['missionFaqCategory'],
    );
    await _localDBService.persistFaqs(faqs: faqs);
  }
}
