import 'package:flutter_bloc/flutter_bloc.dart';

import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterState.initial()) {
    on<ApplyFilterRequested>((event, emit) {
      emit(FilterState(
        type: event.type,
        dateStart: event.dateStart,
        dateEnd: event.dateEnd,
        category: event.category,
        search: event.search,
      ));
    });
    on<ClearFilterRequested>((event, emit) => emit(FilterState.initial()));
  }
}

