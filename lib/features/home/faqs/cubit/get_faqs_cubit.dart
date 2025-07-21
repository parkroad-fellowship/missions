import 'package:app/models/local/prf_faq.dart';
import 'package:app/services/api/mission_faq_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_faqs_state.dart';
part 'get_faqs_cubit.freezed.dart';

class GetFaqsCubit extends Cubit<GetFaqsState> {
  GetFaqsCubit({
    required MissionFaqService missionFaqService,
    required IsarService isarService,
  }) : super(const GetFaqsState.initial()) {
    _missionFaqService = missionFaqService;
    _isarService = isarService;
  }

  late MissionFaqService _missionFaqService;
  late IsarService _isarService;

  Future<void> getFaqs({
    bool forceRefresh = false,
    String? categoryUlid,
    String? query,
  }) async {
    emit(const GetFaqsState.loading());
    try {
      final localFaqs = await _isarService.faqs.getAllFuture(
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

        final updatedLocalFaqs = await _isarService.faqs.getAllFuture(
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

    await _isarService.faqs.persistEntities(faqs);
  }
}
