import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:radiounicorn/cubits/requestsonglist/requestsonglist_cubit.dart';
import 'package:radiounicorn/cubits/searchstring/searchstring_cubit.dart';
import 'package:radiounicorn/models/requestsongdata.dart';
part 'filteredlist_state.dart';

class FilteredlistCubit extends Cubit<FilteredlistState> {
  final List<RequestSongData> initialList;
  final RequestsonglistCubit requestsonglistCubit;
  final SearchstringCubit searchstringCubit;
  late final StreamSubscription searchStreamSubscription;
  FilteredlistCubit(
      {required this.requestsonglistCubit, required this.searchstringCubit, required this.initialList})
      : super(FilteredlistState(filteredList: initialList)) {
    searchStreamSubscription =
        searchstringCubit.stream.listen((SearchstringState event) {
      if (event.searchString.isEmpty) {
        emitNewFilteredList(requestsonglistCubit.state.list);
      } else {
        List<RequestSongData> newCreatedList =
            requestsonglistCubit.state.list.where((RequestSongData e) {
          if (e.song!.artist!
                  .toLowerCase()
                  .contains('${event.searchString}'.toLowerCase()) ||
              e.song!.title!
                  .toLowerCase()
                  .contains('${event.searchString}'.toLowerCase())) {
            return true;
          } else {
            return false;
          }
        }).toList();
        emitNewFilteredList(newCreatedList);
        print(
            'NEW LIST NEW LIST NEW LIST NEW LIST NEW LIST NEW L       ${newCreatedList.length} ');
      }
    });
  }

  emitNewFilteredList(List<RequestSongData> newList) {
    emit(state.copyWith(filteredList: newList));
  }

  @override
  Future<void> close() {
    searchStreamSubscription.cancel();
    return super.close();
  }
}
